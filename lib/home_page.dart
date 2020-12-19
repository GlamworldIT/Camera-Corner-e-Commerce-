import 'dart:async';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: NavigationLeading(_controller.future),
            elevation: 0,
            titleSpacing: -5,
            //centerTitle: true,
            // title: Text(
            //   pageTitle,
            // ),
            //backgroundColor: Colors.white,
            //iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            actions: [
              NavigationControls(_controller.future),
            ],
          ),
          body: FutureBuilder(
            future: _controller.future,
            builder: (BuildContext context,
                AsyncSnapshot<WebViewController> snapshot) {
              WebViewController controller = snapshot.data;

              return WebView(
                initialUrl: "https://www.cameracornerbd.com/",
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              );
            },
          )),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _webViewControllerFuture,
        builder:
            (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
          final bool webViewReady =
              snapshot.connectionState == ConnectionState.done;
          final WebViewController controller = snapshot.data;
          return Row(
            children: [
              IconButton(
                  icon: Icon(Icons.refresh_rounded),
                  onPressed: !webViewReady
                      ? null
                      : () async {
                          controller.reload();
                        }),
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: !webViewReady
                      ? null
                      : () async {
                          if (await controller.canGoForward()) {
                            controller.goForward();
                          } else {
                            Scaffold.of(context).showSnackBar(const SnackBar(
                                content: Text("No forward history")));
                          }
                        }),
            ],
          );
        });
  }
}

// class NavigationLeading extends StatelessWidget {
//   const NavigationLeading(this._webViewControllerFuture);

//   final Future<WebViewController> _webViewControllerFuture;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: _webViewControllerFuture,
//         builder:
//             (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//           final bool webViewReady =
//               snapshot.connectionState == ConnectionState.done;
//           final WebViewController controller = snapshot.data;
//           return IconButton(
//               icon: Icon(Icons.arrow_back_ios),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                       if (await controller.canGoBack()) {
//                         controller.goBack();
//                       } else {
//                         Scaffold.of(context).showSnackBar(
//                             const SnackBar(content: Text("No back history")));
//                       }
//                     });
//         });
//   }
// }

// ignore: must_be_immutable
class NavigationLeading extends StatefulWidget {
  NavigationLeading(this._webViewControllerFuture);

  Future<WebViewController> _webViewControllerFuture;

  @override
  _NavigationLeadingState createState() => _NavigationLeadingState();
}

class _NavigationLeadingState extends State<NavigationLeading> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget._webViewControllerFuture,
        builder:
            (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
          final bool webViewReady =
              snapshot.connectionState == ConnectionState.done;
          final WebViewController controller = snapshot.data;

          return IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                      } else {
                        Scaffold.of(context).showSnackBar(
                            const SnackBar(content: Text("No back history")));
                      }
                    });
        });
  }
}
