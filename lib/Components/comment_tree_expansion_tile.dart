import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone_x/Controllers/reddit_controller.dart';
import 'package:reddit_clone_x/Helpers/rich_text_view.dart';
import 'package:reddit_clone_x/Models/comment_tree.dart';
import 'package:reddit_clone_x/Screens/inapp_web_view.dart';
import 'package:reddit_clone_x/widget_utils.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [CommentTreeExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.
class CommentTreeExpansionTile extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const CommentTreeExpansionTile({
    Key key,
    this.commentTree,
    this.redditController,
    this.backgroundColor,
    this.onExpansionChanged,
    this.initiallyExpanded = false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final CommentTree commentTree;
  final RedditController redditController;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  @override
  _CommentTreeExpansionTileState createState() =>
      _CommentTreeExpansionTileState();
}

class _CommentTreeExpansionTileState extends State<CommentTreeExpansionTile>
    with TickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController _controller;

  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _backgroundColor;

  AnimationController _optionsController;
  Animation<double> _optionsheightFactor;

  bool _isExpanded = false;

  bool _isOptionsExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));
    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;

    _isOptionsExpanded = false;
    _optionsController = AnimationController(duration: _kExpand, vsync: this);
    _optionsheightFactor = _optionsController.drive(_easeOutTween);
    if (_isOptionsExpanded) _optionsController.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  void _handleLongPress() {
    _isOptionsExpanded = !_isOptionsExpanded;
    setState(() {
      if (_isOptionsExpanded) {
        _optionsController.forward();
      } else {
        _optionsController.reverse().then<void>((void value) {
          if (!mounted) return;
        });
      }
    });
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    /*Duration timesincecomment = (widget.commentTree.postedTime != null)
        ? DateTime.now().toUtc().difference(widget.commentTree.postedTime)
        : null;
*/
    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor.value ?? Colors.transparent,
          border: Border(
            top: BorderSide(color: borderSideColor),
            bottom: BorderSide(color: borderSideColor),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: _handleTap,
            onLongPress: _handleLongPress,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  color: _isOptionsExpanded
                      ? Colors.lightBlue.withOpacity(.3)
                      : Colors.transparent,
                  border: Border(
                      left: BorderSide(
                          color: commentColors[
                              widget.commentTree.depth % commentColors.length],
                          width: 3.0 + 1.0 * widget.commentTree.depth))),
              child: Column(
                children: <Widget>[
                  IconTheme.merge(
                    data: IconThemeData(color: _iconColor.value),
                    child: Row(children: <Widget>[
                      Text(
                        widget.commentTree.author ?? "-",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                      Text(
                        widget.commentTree.score.toString() + " pts ᛫ ",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10.0,
                        ),
                      ),
                      Text(
                        timeSince(widget.commentTree.postedTime),
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 10.0),
                      ),
                      Icon(
                        Icons.perm_identity,
                        size: 15.0,
                        color: Colors.grey[500],
                      ),
                      RotationTransition(
                        turns: _iconTurns,
                        child:
                            /*IconButton(
                          onPressed: _handleTap,
                          icon:*/
                            const Icon(
                          Icons.expand_more,
                          size: 30.0,
                        ),
                        //   iconSize: 30.0,
                        // ),
                      ),
                    ]),
                  ),
                  RichTextView(
                    text: widget.commentTree.body,
                    onLinkClicked: (url) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (_) => InAppWebView(
                                    url: url,
                                  )
                              /*PostWebView(
                              activePost: widget.newPost,
                            )*/
                              ));
                    },
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _optionsController.view,
            builder: (BuildContext context, Widget child) {
              return ClipRect(
                child: Align(
                  heightFactor: _optionsheightFactor.value,
                  child: Container(
                    //  color: Colors.grey[300],
                    height: 40.0,
                    width: double.infinity,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(6, (i) {
                          if (optionsIcons[i] == Icons.arrow_upward ||
                              optionsIcons[i] == Icons.arrow_downward) {
                            return voteIconButton(
                                upvote: i ==
                                    optionsIcons.indexOf(Icons.arrow_upward),
                                likes: widget.commentTree.likes,
                                onVote: (way, newlikes, add) {
                                  setState(() {
                                    widget.commentTree.likes = newlikes;
                                    widget.commentTree.score += (add) ? 1 : -1;
                                    widget.redditController
                                        .vote(widget.commentTree.fullId, way);
                                  });
                                });
                          }
                          return IconButton(
                            icon: Icon(
                              optionsIcons[i],
                              size: 20.0,
                              color: Colors.grey[500],
                            ),
                            onPressed: () {},
                          );
                        })),
                  ),
                ),
              );
            },
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColorTween..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: (closed || widget.commentTree.replies == null)
          ? null
          : Column(
              children:
                  List.generate(widget.commentTree.replies.length, (index) {
              return CommentTreeExpansionTile(
                commentTree: widget.commentTree.replies[index],
                redditController: widget.redditController,
              );
            })),
    );
  }
}

final List<Color> commentColors = [
  Colors.blue,
  Colors.orange,
  Colors.green,
  Colors.purple,
  Colors.pink
];

final List<IconData> optionsIcons = [
  Icons.star,
  Icons.keyboard_backspace,
  Icons.arrow_upward,
  Icons.arrow_downward,
  Icons.keyboard_arrow_up,
  Icons.more_vert,
];
