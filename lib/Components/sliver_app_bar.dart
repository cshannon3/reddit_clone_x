import 'package:flutter/material.dart';
import 'dart:math' as math;

class MainCollapsingToolbar extends StatefulWidget {
  @override
  _MainCollapsingToolbarState createState() => _MainCollapsingToolbarState();
}

class _MainCollapsingToolbarState extends State<MainCollapsingToolbar> {
  TabBar _tabbar = TabBar(
    isScrollable: true,
    labelColor: Colors.black87,
    unselectedLabelColor: Colors.grey,
    tabs: [
      Tab(icon: Icon(Icons.info), text: "Tab 1"),
      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
    ],
  );
  AppBar _appbar = AppBar(
    leading: IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {}, // => _scaffoldKey.currentState.openDrawer(),
    ),
    title: Column(
      children: <Widget>[
        Text("currentSubreddit"),
        Text("Hot"),
      ],
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.filter_hdr),
        onPressed: () {
          /*setState(() {
  widget.redditController.userInfo();
  });*/
        },
      ),
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          // bloc.fetchmore();
        },
      ),
      IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          //setState(() {});
        },
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                    minHeight: 30.0,
                    maxHeight: 150.0,
                    child: _appbar), //Container(color: Colors.blue,)),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                    maxHeight: _tabbar.preferredSize.height,
                    minHeight: _tabbar.preferredSize.height,
                    child: _tabbar),
                pinned: true,
              ),
            ];
          },
          body: Center(
            child: Text("Sample text"),
          ),
        ),
      ),
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
