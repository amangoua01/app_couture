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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
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
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: configure ? () => ouvrirVitrine(code) : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              icon: const Icon(AppIconsBold.globe, size: 19),
              label: const Text(
                'Voir ma boutique',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: configure ? ctl.shareBoutique : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: const Icon(AppIcons.shareNetwork, size: 18),
                  label: const Text('Partager'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: configure ? ctl.copierLien : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: const Icon(AppIcons.copy, size: 18),
                  label: const Text('Copier le lien'),
                ),
              ),
            ],
          ),
        ],
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
            borderRadius: BorderRadius.circular(6),
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
