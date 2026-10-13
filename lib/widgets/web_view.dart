
import 'package:invently/assortment/network/endpoints.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/page_widgets/delete_button.dart';
import 'package:invently/widgets/page_widgets/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatefulWidget {
  final Endpoint url;
  final bool navigation;

  const WebView({super.key, required this.url, this.navigation = false});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  InAppWebViewController? controller;
  int progress = 0;
  bool canGoBack = false;
  bool canGoFront = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (canGoBack)
              SquareIconButton(
                model: _getButtonModel('Go backward', Assets.icons.arrowLeft, canGoBack ? controller?.goBack : null),
              ),
            RefreshButton(onRefreshTap: _onReload, status: Status.success),
            if (canGoFront)
              SquareIconButton(
                model:
                    _getButtonModel('Go forward', Assets.icons.arrowRight, canGoFront ? controller?.goForward : null),
              ),
          ],
        ),
        SizedBox(height: 6),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Offstage(
                offstage: progress < 100,
                child: InAppWebView(
                  key: Key(widget.url.url),
                  onWebViewCreated: (c) => controller = c,
                  onProgressChanged: _onProgress,
                  initialSettings: InAppWebViewSettings(
                    disableContextMenu: true,
                    isInspectable: false,
                    supportZoom: false,
                    cacheMode: CacheMode.LOAD_NO_CACHE,
                    cacheEnabled: false,
                    clearCache: true,
                    clearSessionCache: true,
                    safeBrowsingEnabled: true,
                    useShouldOverrideUrlLoading: true,
                  ),
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    final url = navigationAction.request.url.toString();
                    if (url.startsWith(widget.url.baseUrl)) return NavigationActionPolicy.ALLOW;
                    if (widget.navigation) return NavigationActionPolicy.ALLOW;

                    return NavigationActionPolicy.CANCEL;
                  },
                  initialUrlRequest: URLRequest(url: WebUri(widget.url.url)),
                ),
              ),
              if (progress != 100) CustomProgressIndicator(),
            ],
          ),
        ),
      ],
    );
  }

  void _onReload() {
    if (progress < 100) return;
    controller?.reload();
  }

  void _onProgress(InAppWebViewController a, int b) async {
    progress = b;
    canGoBack = await a.canGoBack();
    canGoFront = await a.canGoForward();
    _refresh();
  }

  void _refresh() => mounted ? setState(() => {}) : null;

  SquareIconButtonModel _getButtonModel(String text, String icon, Function()? onTap) => SquareIconButtonModel(
        buttonIcon: icon,
        tooltip: text,
        iconColor: Tm.color(Tc.priIconLight),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Tm.color(Tc.priDefLight),
        ),
        onTap: onTap,
      );
}
