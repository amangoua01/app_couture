import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/data/models/operateur.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/views/controllers/abonnements/operator_list_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/abonnement_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class OperatorListPage extends StatefulWidget {
  final ModuleAbonnement forfait;
  const OperatorListPage(this.forfait, {super.key});

  @override
  State<OperatorListPage> createState() => _OperatorListPageState();
}

class _OperatorListPageState extends State<OperatorListPage> {
  Operateur? _selectedOperateur;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: OperatorListPageVctl(),
      builder: (ctl) {
        if (_selectedOperateur == null && ctl.operateurs.isNotEmpty) {
          _selectedOperateur = ctl.operateurs.first;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7FAF8),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              onPressed: () => Get.back(),
            ),
            centerTitle: true,
            title: const Text(
              "Mode de paiement",
              style: TextStyle(
                color: Color(0xFF0E2C24),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ),
          body: ctl.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(8),

                              // Carte récapitulative Ateliya avec dégradé émeraude signature
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF06231C),
                                      Color(0xFF0A3A30),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.22),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        border: Border.all(
                                          color: AppColors.secondary
                                              .withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.workspace_premium_rounded,
                                          color: AppColors.secondary,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    const Gap(14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "FORMULE CHOISIE",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white
                                                  .withValues(alpha: 0.65),
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          const Gap(3),
                                          Text(
                                            widget.forfait.libelle.value
                                                .toUpperCase(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${widget.forfait.montant.toAmount(unit: "")} FCFA",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                        const Gap(2),
                                        Text(
                                          "${widget.forfait.duree} mois d'accès",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(26),

                              // Titre de sélection
                              const Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                  Gap(8),
                                  Text(
                                    "Choisissez votre opérateur Mobile Money",
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F2620),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(6),
                              Text(
                                "Sélectionnez le réseau avec lequel vous souhaitez régler en toute sécurité.",
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const Gap(16),

                              // Grille stylisée des opérateurs
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: ctl.operateurs.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.12,
                                ),
                                itemBuilder: (context, index) {
                                  final op = ctl.operateurs[index];
                                  final isSelected =
                                      _selectedOperateur?.id == op.id;

                                  return _buildOperatorTile(op, isSelected);
                                },
                              ),
                              const Gap(20),

                              // Bannière de réassurance
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.08),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.shield_outlined,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Paiement 100% sécurisé",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF0F2620),
                                            ),
                                          ),
                                          Text(
                                            "Transaction chiffrée de bout en bout via votre opérateur",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(16),
                            ],
                          ),
                        ),
                      ),

                      // Bouton de validation inférieur
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  Color(0xFF135043),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.28),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _selectedOperateur == null
                                  ? null
                                  : () => Get.to(() => AbonnementPaymentPage(
                                        forfait: widget.forfait,
                                        operateur: _selectedOperateur!,
                                      )),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _selectedOperateur != null
                                        ? "Continuer avec ${_selectedOperateur!.libelle ?? 'cet opérateur'}"
                                        : "Sélectionnez un opérateur",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const Gap(8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildOperatorTile(Operateur op, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOperateur = op;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.1),
            width: isSelected ? 2.2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.14)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Checkmark de sélection
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFF1F5F3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    isSelected ? Icons.check : Icons.circle_outlined,
                    size: isSelected ? 14 : 12,
                    color: isSelected
                        ? Colors.white
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOperatorLogo(op),
                  const Gap(10),
                  Text(
                    op.libelle ?? "Opérateur",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight:
                          isSelected ? FontWeight.w900 : FontWeight.w700,
                      color: isSelected
                          ? const Color(0xFF0F2620)
                          : Colors.grey.shade800,
                    ),
                  ),
                  const Gap(2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.secondary.withValues(alpha: 0.12)
                          : const Color(0xFFF3F7F5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Paiement direct",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.secondary
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorLogo(Operateur op) {
    final name = (op.libelle ?? op.code ?? '').toLowerCase();
    String? localAsset;

    if (name.contains('orange')) {
      localAsset = 'assets/images/orange.png';
    } else if (name.contains('mtn')) {
      localAsset = 'assets/images/mtn.jpeg';
    } else if (name.contains('moov')) {
      localAsset = 'assets/images/moov.png';
    } else if (name.contains('wave')) {
      localAsset = 'assets/images/wave.png';
    }

    Widget content;
    if (localAsset != null) {
      content = Image.asset(
        localAsset,
        width: 44,
        height: 44,
        fit: BoxFit.contain,
      );
    } else if (op.photo?.fullUrl != null && op.photo!.fullUrl!.isNotEmpty) {
      content = Image.network(
        op.photo!.fullUrl!,
        width: 44,
        height: 44,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => SvgPicture.asset(
          'assets/images/svg/mobile.svg',
          width: 28,
          colorFilter:
              const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
        ),
      );
    } else {
      content = SvgPicture.asset(
        'assets/images/svg/mobile.svg',
        width: 28,
        colorFilter:
            const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
      );
    }

    return Container(
      width: 52,
      height: 52,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: content,
        ),
      ),
    );
  }
}
