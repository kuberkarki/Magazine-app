import 'common/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class WebView extends StatefulWidget {
  final String selectedUrl;
  final String title;

  WebView({Key key, @required this.selectedUrl, this.title}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  bool connectionStatus = false;

  @override
  void initState() {
    super.initState();
    check();
  }

  Future check() async {
    bool cs = await checkInternet();
    setState(() {
      connectionStatus = cs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: connectionStatus == true
          ? widget.selectedUrl
          : Uri.dataFromString(
                  '<html><body><center><br/><br/><br/><h2>Sjekk Internettforbindelse</h2></center></body></html>',
                  mimeType: 'text/html')
              .toString(),
      javascriptChannels: jsChannels,
      debuggingEnabled: true,
      ignoreSSLErrors: true,
      mediaPlaybackRequiresUserGesture: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
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
