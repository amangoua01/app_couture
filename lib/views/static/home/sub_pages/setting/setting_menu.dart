import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/entite_entreprise_type.dart';
import 'package:ateliya/tools/constants/type_user_enum.dart';
import 'package:ateliya/views/controllers/home/setting_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/abonnements_list_page.dart';
import 'package:ateliya/views/static/ateliers/ateliers_list_page.dart';
import 'package:ateliya/views/static/boutiques/boutiques_list_page.dart';
import 'package:ateliya/views/static/depense/charges_list_page.dart';
import 'package:ateliya/views/static/depense/types_depense_list_page.dart';
import 'package:ateliya/views/static/caisse/mouvement_caisse_list_page.dart';
import 'package:ateliya/views/static/clients/client_liste_page.dart';
import 'package:ateliya/views/static/depense/depense_list_page.dart';
import 'package:ateliya/views/static/home/sub_pages/statistique_entreprise_page.dart';
import 'package:ateliya/views/static/info/contact_us_page.dart';
import 'package:ateliya/views/static/info/terms_conditions_page.dart';
import 'package:ateliya/views/static/mall_ya/mall_ya_home_page.dart';
import 'package:ateliya/views/static/modele/modele_list_page.dart';
import 'package:ateliya/views/static/modele_boutique/modele_list_boutique_page.dart';
import 'package:ateliya/views/static/personnels/personnels_list_page.dart';
import 'package:ateliya/views/static/printers/print_list_page.dart';
import 'package:ateliya/views/static/ravitaillement/ravitaillement_list_page.dart';
import 'package:ateliya/views/static/stats/stock_statistiques_page.dart';
import 'package:ateliya/views/static/type_mesure/type_mesure_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Une entrée du menu des réglages.
class SettingEntry {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final bool visible;
  final VoidCallback? onTap;

  /// Termes alternatifs pris en compte par la recherche (synonymes, pluriels).
  final List<String> keywords;

  const SettingEntry({
    required this.title,
    required this.icon,
    required this.color,
    this.subtitle,
    this.visible = true,
    this.onTap,
    this.keywords = const [],
  });

  bool matches(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase().trim();
    return title.toLowerCase().contains(q) ||
        (subtitle?.toLowerCase().contains(q) ?? false) ||
        keywords.any((k) => k.toLowerCase().contains(q));
  }
}

/// Un groupe d'entrées présenté dans une même carte.
class SettingSection {
  final String? label;
  final List<SettingEntry> entries;

  const SettingSection({required this.entries, this.label});

  List<SettingEntry> visibleEntries(String query) =>
      entries.where((e) => e.visible && e.matches(query)).toList();
}

/// Construit le menu complet selon le profil et le type d'entité courante.
///
/// Garder cette description séparée de la page permet d'y brancher la
/// recherche sans dupliquer la liste des écrans.
List<SettingSection> buildSettingSections(SettingPageVctl ctl) {
  final isAdmin = ctl.user.isAdmin;
  final entiteType = ctl.getEntite().value.type;
  final isBoutique = entiteType == EntiteEntrepriseType.boutique;
  final isSuccursale = entiteType == EntiteEntrepriseType.succursale;
  final isAc = ctl.user.type?.code == TypeUserEnum.ac.code;

  return [
    SettingSection(
      label: "Gestion de mon entreprise",
      entries: [
        SettingEntry(title: "Mall Ya", icon: Icons.factory_outlined, color: AppColors.primary, visible: isAdmin, keywords: const ["marketplace", "vitrine"], onTap: () => Get.to(() => const MallYaHomePage())),
      ],
    ),
    SettingSection(
      label: "Finances & Comptabilité",
      entries: [
        SettingEntry(title: "Mouvements caisse", icon: Icons.account_balance_wallet_outlined, color: AppColors.primary, visible: isAdmin, keywords: const ["caisse", "tresorerie", "encaissement"], onTap: () => Get.to(() => const MouvementCaisseListPage())),
        SettingEntry(title: "Mes dépenses", icon: Icons.monetization_on_outlined, color: AppColors.primary, visible: isAdmin, keywords: const ["sortie"], onTap: () => Get.to(() => const DepenseListPage())),
        SettingEntry(title: "Charges récurrentes", icon: Icons.event_repeat_rounded, color: AppColors.primary, visible: isAdmin, keywords: const ["charge", "salaire", "loyer", "récurrent"], onTap: () => Get.to(() => const ChargesListPage())),
        SettingEntry(title: "Types de dépense", icon: Icons.sell_outlined, color: AppColors.primary, visible: isAdmin, keywords: const ["famille", "catégorie"], onTap: () => Get.to(() => const TypesDepenseListPage())),
        SettingEntry(title: "Abonnements", icon: Icons.card_membership_outlined, color: AppColors.primary, visible: isAdmin, keywords: const ["forfait", "paiement", "renouveler"], onTap: () => Get.to(() => const AbonnementsListPage())),
      ],
    ),
    SettingSection(
      label: "Ressources de l'Entreprise",
      entries: [
        SettingEntry(title: "Statistiques", icon: Icons.bar_chart_outlined, color: AppColors.primary, visible: isAdmin, keywords: const ["stats", "chiffres", "rapport"], onTap: () => Get.to(() => const StatistiqueEntreprisePage())),
        SettingEntry(title: "Mes boutiques", icon: Icons.storefront_outlined, color: AppColors.primary, visible: isAdmin, keywords: const ["magasin", "point de vente"], onTap: () => Get.to(() => const BoutiquesListPage())),
        SettingEntry(title: "Mes ateliers", icon: Icons.business_outlined, color: AppColors.primary, visible: isAdmin, keywords: const ["succursale"], onTap: () => Get.to(() => const AteliersListPage())),
        SettingEntry(title: "Mon personnel", icon: Icons.people_outline, color: AppColors.primary, visible: isAdmin, keywords: const ["employe", "equipe", "utilisateur"], onTap: () => Get.to(() => const PersonnelListPage())),
        SettingEntry(title: "Imprimantes", icon: Icons.print_outlined, color: AppColors.primary, keywords: const ["ticket", "bluetooth", "impression"], onTap: () => Get.to(() => const PrintListPage())),
      ],
    ),
    SettingSection(
      label: "Atelier & Catalogue",
      entries: [
        SettingEntry(title: "Mes clients", icon: Icons.group_outlined, color: AppColors.primary, visible: !isAc, keywords: const ["clientele", "contact"], onTap: () => Get.to(() => const ClientListePage())),
        SettingEntry(title: "Mes modèles", icon: Icons.style_outlined, color: AppColors.primary, visible: isAdmin && isBoutique, keywords: const ["article", "produit"], onTap: () => Get.to(() => const ModeleListPage())),
        SettingEntry(title: "Modèles boutiques", icon: Icons.shopping_bag_outlined, color: AppColors.primary, visible: isAdmin && isBoutique, keywords: const ["catalogue", "tarif"], onTap: () => Get.to(() => const ModeleListBoutiquePage())),
        SettingEntry(title: "Type de mesure", icon: Icons.straighten_outlined, color: AppColors.primary, visible: isAdmin && isSuccursale, keywords: const ["mensuration", "taille"], onTap: () => Get.to(() => const TypeMesureListPage())),
        SettingEntry(title: "Suivi de stock", icon: Icons.analytics_outlined, color: AppColors.primary, visible: isAdmin && isBoutique, keywords: const ["inventaire", "stock"], onTap: () => Get.to(() => const StockStatistiquesPage())),
        SettingEntry(title: "Ravitaillements", icon: Icons.inventory_2_outlined, color: AppColors.primary, visible: isBoutique, keywords: const ["approvisionnement", "entree stock"], onTap: () => Get.to(() => const RavitaillementListPage())),
      ],
    ),
    SettingSection(
      label: "À propos",
      entries: [
        SettingEntry(title: "Contactez-nous", icon: Icons.support_agent_outlined, color: AppColors.primary, keywords: const ["aide", "support", "assistance"], onTap: () => Get.to(() => const ContactUsPage())),
        SettingEntry(title: "Termes & Conditions", icon: Icons.gavel_outlined, color: AppColors.primary, keywords: const ["cgu", "mentions legales", "confidentialite"], onTap: () => Get.to(() => const TermsConditionsPage())),
      ],
    ),
    SettingSection(
      label: "Partager l'application",
      entries: [
        SettingEntry(title: "Disponible sur Play Store", icon: Icons.android_rounded, color: const Color(0xFF34A853), keywords: const ["android", "google"], onTap: ctl.openPlayStore),
        SettingEntry(title: "Disponible sur App Store", icon: Icons.apple_rounded, color: AppColors.primary, keywords: const ["ios", "iphone", "apple"], onTap: ctl.openAppStore),
        SettingEntry(title: "Copier le lien de partage", icon: Icons.share_outlined, color: AppColors.primary, keywords: const ["partager", "lien", "inviter"], onTap: ctl.shareApp),
      ],
    ),
    SettingSection(
      entries: [
        SettingEntry(title: "Déconnexion", icon: Icons.logout_rounded, color: const Color(0xFFC76D6D), keywords: const ["quitter", "logout", "sortir"], onTap: ctl.logoutUser),
      ],
    ),
  ];
}
