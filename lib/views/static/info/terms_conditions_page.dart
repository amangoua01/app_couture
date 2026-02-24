import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/env.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Termes & Conditions"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () async {
              final uri = Uri.parse(Env.termsAndConditionsUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.open_in_new_rounded,
                size: 16, color: AppColors.primary),
            label: const Text("Voir en ligne",
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // En-tête
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.gavel_rounded, color: Colors.white, size: 40),
                const Gap(14),
                const Text(
                  "Termes & Conditions d'utilisation",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                Text(
                  "Dernière mise à jour : Janvier 2025",
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12),
                ),
              ],
            ),
          ),
          const Gap(28),

          _TermsSection(
            icon: Icons.info_outline_rounded,
            title: "1. Acceptation des conditions",
            body:
                "En utilisant l'application Ateliya, vous acceptez d'être lié par les présentes conditions d'utilisation. Si vous n'acceptez pas ces conditions, veuillez ne pas utiliser l'application.",
          ),
          _TermsSection(
            icon: Icons.account_circle_outlined,
            title: "2. Compte utilisateur",
            body:
                "Vous êtes responsable de la confidentialité de vos identifiants de connexion. Toute activité réalisée depuis votre compte est sous votre responsabilité. Vous vous engagez à nous signaler immédiatement toute utilisation non autorisée de votre compte.",
          ),
          _TermsSection(
            icon: Icons.security_outlined,
            title: "3. Protection des données",
            body:
                "Ateliya s'engage à protéger vos données personnelles conformément aux lois en vigueur. Vos données ne seront jamais vendues à des tiers. Elles sont utilisées uniquement dans le cadre de la fourniture du service.",
          ),
          _TermsSection(
            icon: Icons.devices_outlined,
            title: "4. Utilisation du service",
            body:
                "L'application est destinée à une utilisation professionnelle pour la gestion d'ateliers de couture et de boutiques. Toute utilisation frauduleuse, abusive ou contraire aux lois en vigueur est strictement interdite.",
          ),
          _TermsSection(
            icon: Icons.card_membership_outlined,
            title: "5. Abonnements",
            body:
                "L'accès à certaines fonctionnalités est soumis à un abonnement payant. Les tarifs en vigueur sont indiqués dans l'application. Les paiements effectués ne sont pas remboursables, sauf dispositions légales contraires.",
          ),
          _TermsSection(
            icon: Icons.update_outlined,
            title: "6. Modifications",
            body:
                "Ateliya se réserve le droit de modifier les présentes conditions à tout moment. Vous serez informé de tout changement significatif par notification dans l'application. L'utilisation continue de l'application après modification vaut acceptation des nouvelles conditions.",
          ),
          _TermsSection(
            icon: Icons.contact_support_outlined,
            title: "7. Responsabilité",
            body:
                "Ateliya ne saurait être tenu responsable des pertes de données, interruptions de service ou dommages indirects résultant de l'utilisation de l'application. Nous faisons tout notre possible pour assurer la continuité et la sécurité du service.",
          ),
          _TermsSection(
            icon: Icons.gavel_rounded,
            title: "8. Droit applicable",
            body:
                "Les présentes conditions sont régies par le droit ivoirien. Tout litige sera soumis à la compétence exclusive des tribunaux compétents de Côte d'Ivoire.",
          ),
          const Gap(20),

          // Lien vers la version complète
          InkWell(
            onTap: () async {
              final uri = Uri.parse(Env.termsAndConditionsUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language_rounded,
                      color: AppColors.primary, size: 22),
                  const Gap(14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Version complète",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                        Text(
                          "Consultez nos termes complets sur notre site web",
                          style:
                              TextStyle(fontSize: 12, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ),
          const Gap(30),
        ],
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _TermsSection({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const Gap(6),
                Text(
                  body,
                  style: TextStyle(
                      color: Colors.grey[700], fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
