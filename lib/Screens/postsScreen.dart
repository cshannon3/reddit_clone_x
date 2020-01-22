import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:reddit_clone_x/Components/menu_drawer.dart';
import 'package:reddit_clone_x/Components/post_widget.dart';
import 'package:reddit_clone_x/Controllers/reddit_controller.dart';
import 'package:reddit_clone_x/Models/post.dart';
import 'dart:math' as math;

class PostsScreen extends StatefulWidget {
  final RedditController redditController;

  const PostsScreen({Key key, this.redditController}) : super(key: key);

  @override
  PostsScreenState createState() {
    return new PostsScreenState();
  }
}

class PostsScreenState extends State<PostsScreen>
    with TickerProviderStateMixin {
  String currentSubreddit = "frontpage";
  bool first = true;
  bool reloading = true;
  TabController _tabController;
  int selectedIndex;
  //CurrentScreen screen = CurrentScreen.postsScreen;
  List<Post> posts = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();
  AnimationController cardEntranceAnimationController;
  List<Animation> postTileAnimations;
  Animation fabAnimation;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    widget.redditController.addListener(() {
      if (first && widget.redditController.redditInitialized) {
        widget.redditController.getFrontPage();
        setState(() {
          first = false;
        });
      }
    });
  }

  setUpAnimations(List<Post> _newposts) {
    print("yoo");
    cardEntranceAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );

    fabAnimation = new CurvedAnimation(
        parent: cardEntranceAnimationController,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate));
    postTileAnimations = _newposts.map((post) {
      int index = _newposts.indexOf(post);
      double start = index < 5 ? index * 0.1 : .4;
      double duration = 0.6;
      double end = duration + start;
      return new Tween<double>(begin: 800.0, end: 0.0).animate(
          new CurvedAnimation(
              parent: cardEntranceAnimationController,
              curve: new Interval(start, end, curve: Curves.decelerate)));
    }).toList();

    cardEntranceAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: StreamBuilder(
          initialData: widget.redditController.postsBloc.getCurrentState(),
          stream: widget.redditController.postsBloc.postsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(""),
              );
            }
            if (snapshot.data.loading) {
              reloading = true;
              return Scaffold(
                body: DefaultTabController(
                  length: widget.redditController.subscribedSubreddits.length,
                  initialIndex: selectedIndex,
                  child: CustomScrollView(slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                          minHeight: 80.0,
                          maxHeight: 140.0,
                          child:
                              _buildAppBar()), //Container(color: Colors.blue,)),
                    ),
                    //  Center(
                    //  child: CircularProgressIndicator(),
                    // ),
                  ]),
                ),
              );
            }
            posts = snapshot.data.posts;
            // scrollController.jumpTo(0.0);
            if (reloading) {
              setUpAnimations(posts);
              reloading = false;
            }
            _tabController = TabController(
                length: widget.redditController.subscribedSubreddits.length,
                vsync: this,
                initialIndex: selectedIndex);
            _tabController.addListener(() {
              selectedIndex = _tabController.index;
              currentSubreddit = widget
                  .redditController.subscribedSubreddits[_tabController.index];
              widget.redditController.setCurrentSubreddit = widget
                  .redditController.subscribedSubreddits[_tabController.index];
            });
            return Scaffold(
              body: DefaultTabController(
                length: widget.redditController.subscribedSubreddits.length,
                initialIndex: selectedIndex,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                          minHeight: 80.0,
                          maxHeight: 140.0,
                          child:
                              _buildAppBar()), //Container(color: Colors.blue,)),
                    ),
                    /* SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                          maxHeight: 40.0,
                          minHeight: 40.0,
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            height: 40.0,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                    widget.redditController.subscribedSubreddits
                                        .length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      print(widget.redditController
                                          .subscribedSubreddits[index]);
                                      currentSubreddit = widget.redditController
                                          .subscribedSubreddits[index];
                                      widget.redditController
                                              .setCurrentSubreddit =
                                          widget.redditController
                                              .subscribedSubreddits[index];
                                    },
                                    child: Container(
                                      height: 40.0,
                                      width: 70.0,
                                      child: Center(
                                        child: Text(
                                          widget.redditController
                                              .subscribedSubreddits[index],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                          )),
                      pinned: true,
                    ),*/
                    SliverList(
                        delegate: SliverChildListDelegate(
                      _buildPosts().toList(),
                    ))
                  ],
                ),
              ),
            );
          },
        ),
        //  ],
        //),
        drawer: MenuDrawer(widget.redditController) // _buildDrawer(),
        );
  }

  Iterable<Widget> _buildPosts() {
    return posts.map((post) {
      int index = posts.indexOf(post);
      return AnimatedBuilder(
        animation: cardEntranceAnimationController,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0, /* horizontal: 8.0*/
          ),
          child: PostWidget(
            newPost: post,
            redditController: widget.redditController,
          ),
        ),
        builder: (context, child) => new Transform.translate(
              offset: Offset(0.0, postTileAnimations[index].value),
              child: child,
            ),
      );
    });
  }

  AppBar _buildAppBar() {
    return new AppBar(
      //pinned: true,
      //expandedHeight: 100.0,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      title: Column(
        children: <Widget>[
          Flexible(child: Text(currentSubreddit)),
          Flexible(child: Text("Hot")),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.filter_hdr),
          onPressed: () {
            setState(() {
              widget.redditController.userInfo();
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            String g =
                'Add something then [my link](https://github.com/cshannon3/reddit_clone_x/pull/1'
                    .splitMapJoin(
                        (new RegExp(
                            r"(\[.*?\])?(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)")),
                        onMatch: (m) => '${m.group(0)}',
                        onNonMatch: (n) => '*'); // *shoots*
            print(g);
            String p =
                'Add something then [my link](https://github.com/cshannon3/reddit_clone_x/pull/1'
                    .splitMapJoin((new RegExp(r"\[.*?\]")),
                        onMatch: (m) => '${m.group(0)}',
                        onNonMatch: (n) => '*'); // *shoots*
            print(p);
            // bloc.fetchmore();
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            setState(() {});
          },
        ),
      ],
      bottom: new TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: widget.redditController.subscribedSubreddits.map((_subreddit) {
            return Tab(
              text: _subreddit,
            );
          }).toList()),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

/*
class ResultsList extends StatelessWidget {
  final bool isLoaded;
  final List<Widget> posts;
  final

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: widget.redditController.subscribedSubreddits.length,
        initialIndex: selectedIndex,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                  minHeight: 80.0,
                  maxHeight: 140.0,
                  child:
                  _buildAppBar()), //Container(color: Colors.blue,)),
            ),

            SliverList(
                delegate: SliverChildListDelegate(
                  posts,
                ))
          ],
        ),
      ),
    );
  }
}
*/
