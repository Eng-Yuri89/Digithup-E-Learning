
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreenIframe extends StatelessWidget {
  static const routeName = '/webview-iframe';

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewScreenIframe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          "الموقع",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(
                '<html><body><iframe style="height: 25%;width:25%" src="$selectedUrl" allowfullscreen></iframe></body></html>',
                mimeType: 'text/html')
            .toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
