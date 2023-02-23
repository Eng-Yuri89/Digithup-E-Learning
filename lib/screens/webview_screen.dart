import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/main_data.dart';


class WebViewScreen extends StatefulWidget {
  static const routeName = '/webview';

  const WebViewScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();





  @override
  Widget build(BuildContext context) {
    final selectedUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        iconTheme: const IconThemeData(
          color: kSecondaryColor, //change your color here
        ),
        title: const Text(
          "الموقع",
          style: TextStyle(
            color: kSecondaryColor,
          ),
        ),
        backgroundColor: kBackgroundColor,
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: WebView(
        initialUrl: selectedUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture, {Key? key})
      : assert(_webViewControllerFuture != null),
        super(key: key);

  final Future<WebViewController>? _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoBack()) {
                        await controller.goBack();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("لا يمكن الرجوع"),
                          ),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoForward()) {
                        await controller.goForward();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("لا يمكن الانتقال للامام")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller!.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
