import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:reddit_clone_x/Models/post.dart';

class InAppWebView extends StatefulWidget {
  final String url;

  InAppWebView({this.url});

  @override
  _InAppWebViewState createState() => new _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebView> {
  final webView = FlutterWebviewPlugin();
  // TextEditingController controller = TextEditingController(text: url);
  String currenturl;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void initState() {
    super.initState();

    webView.close();
    /*controller.addListener((){
      url = controller.text;
    });*/
    _onUrlChanged = webView.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          //_history.add("onUrlChanged: $url");
          currenturl = url;
          print("onUrlChanged: $url");
        });
      }
    });

    _onStateChanged =
        webView.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          // _history.add("onStateChanged: ${state.type} ${state.url}");
          print("onStateChanged: ${state.type} ${state.url}");
        });
      }
    });
  }

  @override
  void dispose() {
    webView.dispose();
    // controller.dispose();
    super.dispose();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.url;

    return new WebviewScaffold(
      url: url,
      appBar: AppBar(
        title: Text("WebView"),
        leading: new IconButton(
            padding: EdgeInsets.only(left: 300.0),
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              setState(() {});
            }),
      ), // Appbar
      withJavascript: true,
      withLocalStorage: true,
      withZoom: true,
    ); // WebviewScaffold
  }
}
