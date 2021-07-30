import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WhatsAppWeb extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WhatsAppWebState();
  }
}

class WhatsAppWebState extends State<WhatsAppWeb>
    with AutomaticKeepAliveClientMixin<WhatsAppWeb> {
  InAppWebViewController _webViewController;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      width: MediaQuery.of(context).size.width * 0.98,
      child: InAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse('https://web.whatsapp.com')),
        initialOptions: InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36")),
        onWebViewCreated: (InAppWebViewController controller) {
          _webViewController = controller;
        },
        onLoadStop: (InAppWebViewController controller, Uri url) async {
          var result = controller.injectCSSCode(source: ".landing-header {display: none;} ._2WuPw {display: none} ._3aF8K {display: none}");
          print(result);
        },
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<HorizontalDragGestureRecognizer>(
                () => HorizontalDragGestureRecognizer(),
          ),
        },
      )
    );
  }
}
