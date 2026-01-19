import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  bool isLoading = true;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            isLoading = true;
          });
        },
        onProgress: (progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
        onPageFinished: (url) {
          setState(() {
            isLoading = false;
          });
        },
        onWebResourceError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erro ao carregar página: ${error.description}')),
          );
        },
        onNavigationRequest: (request) {
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (isLoading)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.purple,
            ),
        ],
      ),
    );
  }
}
