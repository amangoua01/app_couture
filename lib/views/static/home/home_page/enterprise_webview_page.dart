import 'dart:async';

import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/tools/services/mall_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Vitrine en ligne de l'entreprise, affichée dans l'application.
///
/// Elle n'est chargée qu'à l'ouverture (jamais en arrière-plan) et la page
/// s'affiche au fur et à mesure, sous une fine barre de progression : plus de
/// roue qui masque tout jusqu'à la fin. Si le site tarde, un message l'indique
/// et propose de réessayer ou de l'ouvrir dans le navigateur.
class EnterpriseWebViewPage extends StatefulWidget {
  /// Code marchand de l'entreprise (adresse de sa vitrine).
  final String? code;
  const EnterpriseWebViewPage({super.key, required this.code});

  @override
  State<EnterpriseWebViewPage> createState() => _EnterpriseWebViewPageState();
}

class _EnterpriseWebViewPageState extends State<EnterpriseWebViewPage> {
  late final WebViewController _web;
  String? get _code => widget.code;

  double _progress = 0;
  bool _slow = false;
  bool _failed = false;
  Timer? _slowTimer;

  @override
  void initState() {
    super.initState();
    _web = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _failed = false;
            _progress = 0.05;
          }),
          onProgress: (p) => setState(() => _progress = p / 100),
          onPageFinished: (_) {
            _slowTimer?.cancel();
            setState(() {
              _progress = 1;
              _slow = false;
            });
          },
          onWebResourceError: (e) {
            if (e.isForMainFrame ?? true) setState(() => _failed = true);
          },
        ),
      );
    MallService.warmUp(_code);
    _load();
  }

  void _load() {
    final code = _code;
    if (code == null || code.isEmpty) return;
    setState(() {
      _slow = false;
      _failed = false;
      _progress = 0.05;
    });
    _slowTimer?.cancel();
    _slowTimer = Timer(const Duration(seconds: 8), () {
      if (mounted && _progress < 0.6) setState(() => _slow = true);
    });
    _web.loadRequest(MallService.urlOf(code));
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = _code;
    final loading = _progress < 1 && !_failed;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ma boutique en ligne'),
        actions: [
          if (code != null && code.isNotEmpty) ...[
            IconButton(
              tooltip: 'Partager le lien',
              onPressed: () => MallService.share(code),
              icon: const Icon(AppIcons.shareNetwork),
            ),
            IconButton(
              tooltip: 'Ouvrir dans le navigateur',
              onPressed: () => MallService.openInBrowser(code),
              icon: const Icon(AppIcons.globe),
            ),
          ],
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: loading ? 1 : 0,
            child: LinearProgressIndicator(
              value: _progress.clamp(0.05, 1),
              minHeight: 3,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
            ),
          ),
        ),
      ),
      body: code == null || code.isEmpty
          ? const _NonConfiguree()
          : Stack(
              children: [
                WebViewWidget(controller: _web),
                if (_failed)
                  _Message(
                    titre: 'Impossible de charger la boutique',
                    texte: 'Vérifiez votre connexion, puis réessayez.',
                    onRetry: _load,
                    onBrowser: () => MallService.openInBrowser(code),
                  )
                else if (_slow && loading)
                  _Message(
                    titre: 'Le site se réveille…',
                    texte:
                        "Il n'a pas été visité depuis un moment, le premier chargement peut prendre une trentaine de secondes. Les suivants seront rapides.",
                    onRetry: _load,
                    onBrowser: () => MallService.openInBrowser(code),
                    discret: true,
                  ),
              ],
            ),
    );
  }
}

/// Ouvre la vitrine de l'entreprise [code] dans l'application.
void ouvrirVitrine(String? code) {
  Get.to(() => EnterpriseWebViewPage(code: code));
}

class _Message extends StatelessWidget {
  final String titre;
  final String texte;
  final VoidCallback onRetry;
  final VoidCallback onBrowser;
  final bool discret;

  const _Message({
    required this.titre,
    required this.texte,
    required this.onRetry,
    required this.onBrowser,
    this.discret = false,
  });

  @override
  Widget build(BuildContext context) {
    final contenu = Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFDDE3DF))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            texte,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              FilledButton(onPressed: onRetry, child: const Text('Réessayer')),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onBrowser,
                child: const Text('Ouvrir dans le navigateur'),
              ),
            ],
          ),
        ],
      ),
    );
    return discret
        ? Align(alignment: Alignment.bottomCenter, child: contenu)
        : Container(color: Colors.white, alignment: Alignment.center, child: contenu);
  }
}

class _NonConfiguree extends StatelessWidget {
  const _NonConfiguree();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Text(
          "Le code marchand de votre entreprise est manquant : la boutique en ligne n'est pas encore configurée.",
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.4, color: AppColors.textMuted),
        ),
      ),
    );
  }
}
