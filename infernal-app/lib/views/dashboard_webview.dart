import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Ecran principal : affiche le dashboard dans un WebView
class DashboardWebView extends StatefulWidget {
  final String serverUrl;

  const DashboardWebView({super.key, required this.serverUrl});

  @override
  State<DashboardWebView> createState() => _DashboardWebViewState();
}

class _DashboardWebViewState extends State<DashboardWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        // BUG+035 fix: only allow navigation to the loopback local_server.
        // Without this, any anchor/script that navigates to an external
        // URL (e.g. an accidental http://example.com in future content)
        // would load third-party content inside our WebView, with full JS
        // access to the dashboard session.
        onNavigationRequest: (request) {
          final url = request.url;
          if (url.startsWith('http://127.0.0.1:8011') ||
              url.startsWith('http://localhost:8011')) {
            return NavigationDecision.navigate;
          }
          return NavigationDecision.prevent;
        },
        onPageStarted: (_) {
          if (mounted) setState(() { _isLoading = true; _hasError = false; });
        },
        onPageFinished: (_) {
          if (mounted) setState(() => _isLoading = false);
        },
        onWebResourceError: (error) {
          if (mounted) setState(() { _isLoading = false; _hasError = true; });
        },
      ))
      ..setBackgroundColor(const Color(0xFF0E1319))
      ..loadRequest(Uri.parse(widget.serverUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1319),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF35D99A),
                ),
              ),
            if (_hasError)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFFF7A7A), size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Erreur de chargement',
                      style: TextStyle(color: Color(0xFFE7EDF3), fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() { _hasError = false; _isLoading = true; });
                        _controller.loadRequest(Uri.parse(widget.serverUrl));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF35D99A),
                      ),
                      child: const Text('Reessayer'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
