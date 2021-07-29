import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WhatsAppWeb extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WhatsAppWebState();
  }
}

class WhatsAppWebState extends State<WhatsAppWeb>
    with AutomaticKeepAliveClientMixin<WhatsAppWeb> {
  WebViewController _myController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      width: MediaQuery.of(context).size.width * 0.98,
      child: WebView(
        onWebViewCreated: (controller) {
          _myController = controller;
        },
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer(),
          ),
        },
        gestureNavigationEnabled: true,
        userAgent:
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://web.whatsapp.com',
        onPageFinished: (initialUrl) {
          // sleep(Duration(seconds:5));
          // _myController.evaluateJavascript(
          //     "while (true){try {var isMobileVersion = document.getElementsByClassName('landing-header');if (isMobileVersion.length > 0) {document.querySelector('.landing-header').setAttribute('style', 'display: none');break;}}catch (err){alert('aaaaaaaaaaaa');}}");
        },
      ),
    );
  }
}