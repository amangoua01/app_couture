import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/home_page_vctl.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_ya_home_vctl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EnterpriseWebViewPage extends StatefulWidget {
  const EnterpriseWebViewPage({super.key});

  @override
  State<EnterpriseWebViewPage> createState() => _EnterpriseWebViewPageState();
}

class _EnterpriseWebViewPageState extends State<EnterpriseWebViewPage> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  String? _currentUrl;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
                _updateNavigationState();
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
                _updateNavigationState();
              },
              onProgress: (int progress) {
                _updateNavigationState();
              },
              onUrlChange: (UrlChange change) {
                _updateNavigationState();
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint("WebView Error: ${error.description}");
              },
            ),
          );
  }

  Future<void> _updateNavigationState() async {
    if (!mounted) return;
    try {
      final canGoBack = await _webViewController.canGoBack();
      final canGoForward = await _webViewController.canGoForward();
      if (mounted) {
        setState(() {
          _canGoBack = canGoBack;
          _canGoForward = canGoForward;
        });
      }
    } catch (e) {
      debugPrint("Error updating navigation state: $e");
    }
  }

  void _loadUrl(String codeMarchand) {
    final newUrl = 'https://malliya.ateliya.com/enterprise/$codeMarchand';
    if (_currentUrl != newUrl) {
      _currentUrl = newUrl;
      _webViewController.loadRequest(Uri.parse(newUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageVctl>(
      init: HomePageVctl(),
      builder: (ctl) {
        final codeMarchand = ctl.user.entreprise?.codeMarchand;

        if (codeMarchand == null || codeMarchand.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: const Text(
                "Ma boutique",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Boutique non configurée",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Le code marchand de votre entreprise est manquant. Veuillez configurer votre boutique dans les options.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Load the URL if it hasn't been loaded yet or if the code marchand changed
        _loadUrl(codeMarchand);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Ma boutique",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  if (Get.isRegistered<MallYaHomeVctl>()) {
                    Get.find<MallYaHomeVctl>().shareBoutique();
                  }
                },
                icon: const Icon(Icons.share_rounded, color: Colors.white),
              ),
            ],
          ),
          body: Stack(
            children: [
              WebViewWidget(controller: _webViewController),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            height: 56,
            color: Colors.white,
            elevation: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: _canGoBack ? AppColors.primary : Colors.grey[400],
                    size: 20,
                  ),
                  onPressed:
                      _canGoBack
                          ? () async {
                            await _webViewController.goBack();
                            _updateNavigationState();
                          }
                          : null,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  onPressed: () {
                    _webViewController.reload();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _canGoForward ? AppColors.primary : Colors.grey[400],
                    size: 20,
                  ),
                  onPressed:
                      _canGoForward
                          ? () async {
                            await _webViewController.goForward();
                            _updateNavigationState();
                          }
                          : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
