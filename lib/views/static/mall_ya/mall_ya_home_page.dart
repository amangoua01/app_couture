import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/tools/services/mall_service.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_ya_home_vctl.dart';
import 'package:ateliya/views/static/home/home_page/enterprise_webview_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Espace Mall Ya : la vitrine en ligne de l'entreprise en tête (voir,
/// partager, copier le lien), puis tout ce qui la configure, regroupé par
/// thème. La vitrine n'est chargée que si on appuie sur « Voir ».
class MallYaHomePage extends StatelessWidget {
  const MallYaHomePage({super.key});

  // Ordre d'affichage des entrées du contrôleur, par groupe.
  static const _maBoutique = [
    'Tableau de bord',
    'Modèles boutique',
    'Couvertures',
    'Statut boutique',
    'Paramètres boutique',
  ];
  static const _commandes = [
    'Commandes reçues',
    'Mes commandes',
    'Mes favoris',
    'Mes adresses',
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MallYaHomeVctl(),
      builder: (ctl) {
        // Le site se réveille pendant que l'utilisateur lit cet écran.
        MallService.warmUp(ctl.code);

        List<MallYaMenuItem> items(List<String> labels) => [
              for (final l in labels)
                ...ctl.menuItems.where((i) => i.label == l),
            ];

        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: AppBar(title: const Text('Mall Ya')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            children: [
              _CarteVitrine(ctl: ctl),
              const SizedBox(height: 28),
              _Groupe(titre: 'Ma boutique en ligne', items: items(_maBoutique)),
              const SizedBox(height: 24),
              _Groupe(titre: 'Commandes et achats', items: items(_commandes)),
            ],
          ),
        );
      },
    );
  }
}

/// Bloc principal : l'adresse de la vitrine et les trois gestes utiles.
class _CarteVitrine extends StatelessWidget {
  final MallYaHomeVctl ctl;
  const _CarteVitrine({required this.ctl});

  @override
  Widget build(BuildContext context) {
    final code = ctl.code;
    final configure = code != null && code.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VOTRE BOUTIQUE EN LIGNE',
            style: TextStyle(
              fontSize: 10.5,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Vos modèles visibles par tous les acheteurs',
            style: TextStyle(
              fontSize: 20,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          if (configure)
            Text(
              MallService.urlOf(code).toString().replaceFirst('https://', ''),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'GeistMono',
                fontSize: 12,
                color: Colors.white70,
              ),
            )
          else
            const Text(
              "Le code marchand est manquant : la vitrine n'est pas encore configurée.",
              style: TextStyle(fontSize: 12.5, color: Colors.white70),
            ),
          const SizedBox(height: 18),
          // Geste principal : grand bouton rond, comme « Déposer » sur l'accueil.
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: configure ? () => ouvrirVitrine(code) : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white24,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              icon: const Icon(AppIconsBold.globe, size: 21),
              label: const Text('Voir ma boutique'),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _BoutonRond(
                  icon: AppIcons.shareNetwork,
                  label: 'Partager',
                  onTap: configure ? ctl.shareBoutique : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BoutonRond(
                  icon: AppIcons.copy,
                  label: 'Copier le lien',
                  onTap: configure ? ctl.copierLien : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bouton rond à contour blanc, pour les gestes secondaires sur fond vert.
class _BoutonRond extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _BoutonRond({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white54),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _Groupe extends StatelessWidget {
  final String titre;
  final List<MallYaMenuItem> items;
  const _Groupe({required this.titre, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(
            titre.toUpperCase(),
            style: const TextStyle(
              fontSize: 10.5,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDDE3DF)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const Divider(height: 1, color: Color(0xFFDDE3DF)),
                InkWell(
                  onTap: items[i].onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Icon(items[i].icon, size: 24, color: AppColors.primary),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[i].label,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                items[i].subtitle,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          AppIcons.caretRight,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
