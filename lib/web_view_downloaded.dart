import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'common/config.dart';
// import 'main.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class WebViewDownloaded extends StatefulWidget {
  final String selectedUrl;
  final String title;
  final String content;

  WebViewDownloaded(
      {Key key, @required this.selectedUrl, this.title, this.content})
      : super(key: key);

  @override
  _WebViewDownloadedState createState() => _WebViewDownloadedState();
}

class _WebViewDownloadedState extends State<WebViewDownloaded> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.selectedUrl,
      javascriptChannels: jsChannels,
      debuggingEnabled: true,
      ignoreSSLErrors: true,
      mediaPlaybackRequiresUserGesture: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => MainPage()),
            //     (Route<dynamic> route) => false);
          },
        ),
        title: widget.title != '' ? Text(widget.title) : Text(APPNAME),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
