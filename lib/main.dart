import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:reddit_clone_x/Controllers/reddit_controller.dart';
import 'package:reddit_clone_x/Screens/image_overlay_screen.dart';
import 'package:reddit_clone_x/Screens/single_post_screen.dart';
import 'package:reddit_clone_x/Screens/login.dart';
import 'package:reddit_clone_x/Screens/postsScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //PostsBloc bloc;
  RedditController redditController;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    redditController = new RedditController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PostsScreen(
          redditController: redditController,
        ),
        ImageOverlayScreen(
          redditController: redditController,
        ),
        LoginWebView(redditController: redditController),
      ],
    );
  }
}
