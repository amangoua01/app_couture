import 'package:ateliya/api/facture_api.dart';
import 'package:ateliya/data/models/mesure.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/mode_paiement_enum.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PaiementDialog extends StatefulWidget {
  final Mesure mesure;
  const PaiementDialog({super.key, required this.mesure});

  @override
  State<PaiementDialog> createState() => _PaiementDialogState();
}

class _PaiementDialogState extends State<PaiementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _montantCtrl = TextEditingController();

  String _selectedMode = "Espèces";
  bool _isLoading = false;
  final api = FactureApi();

  @override
  void initState() {
    super.initState();
    // Pré-remplir avec le reste à payer par défaut
    if (widget.mesure.resteArgent > 0) {
      _montantCtrl.text = widget.mesure.resteArgent.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _montantCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final montant = double.tryParse(_montantCtrl.text) ?? 0;
    final ref = _selectedMode;

    final res = await api.ajouterPaiement(
      widget.mesure.id!,
      montant,
      ref,
      widget.mesure.succursale?.id ?? 0,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res.status) {
      Get.back(result: res.data); // Renvoie la Mesure mise à jour
      Get.snackbar(
        "Succès",
        "Paiement enregistré",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Erreur",
        res.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Row(
          children: [
            Icon(Icons.payment_rounded, color: Colors.white, size: 28),
            Gap(10),
            Text(
              "Nouveau paiement",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Commande #${widget.mesure.id}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                          "Client", widget.mesure.client?.fullName ?? "Inconnu",
                          icon: Icons.person_outline),
                      const Divider(height: 20),
                      _buildInfoRow("Montant total",
                          widget.mesure.montantTotal.toAmount(unit: "F"),
                          icon: Icons.receipt_long_outlined),
                      _buildInfoRow(
                          "Avance", widget.mesure.avance.toAmount(unit: "F"),
                          icon: Icons.arrow_forward_outlined),
                      const Divider(height: 20),
                      _buildInfoRow(
                        "Reste à payer",
                        widget.mesure.resteArgent.toAmount(unit: "F"),
                        icon: Icons.monetization_on_outlined,
                        valueColor: AppColors.primary,
                        isBold: true,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const Gap(25),
                TextFormField(
                  controller: _montantCtrl,
                  onChanged: (_) =>
                      setState(() {}), // Pour rafraîchir le "Reste après"
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  decoration: InputDecoration(
                    labelText: "Montant à verser",
                    hintText: "0",
                    suffixText: "FCFA",
                    prefixIcon: const Icon(Icons.attach_money,
                        color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.fieldBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.fieldBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Montant requis";
                    final montant = double.tryParse(v);
                    if (montant == null) return "Montant invalide";
                    if (montant <= 0)
                      return "Le montant doit être supérieur à 0";
                    if (montant > widget.mesure.resteArgent) {
                      return "Le montant ne peut pas dépasser ${widget.mesure.resteArgent.toAmount(unit: "F")}";
                    }
                    return null;
                  },
                ),
                const Gap(8),
                Builder(
                  builder: (context) {
                    final m = double.tryParse(_montantCtrl.text) ?? 0;
                    final reste = widget.mesure.resteArgent - m;

                    if (m == 0) return const SizedBox.shrink();

                    if (reste < 0) {
                      return Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.red, size: 16),
                          const Gap(6),
                          Expanded(
                            child: Text(
                              "Le montant dépasse le reste à payer de ${(-reste).toAmount(unit: "F")}",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      );
                    }

                    return Text(
                      "Nouveau reste à payer: ${reste.toAmount(unit: "F")}",
                      style: TextStyle(
                        color: reste == 0 ? Colors.green : Colors.grey[600],
                        fontSize: 12,
                        fontWeight:
                            reste == 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  },
                ),
                const Gap(16),
                CDropDownFormField<String>(
                  labelText: "Moyen de paiement",
                  hintText: "Sélectionner",
                  prefixIcon: const Icon(Icons.payment, color: Colors.grey),
                  selectedItem: _selectedMode,
                  items: (filter, props) =>
                      ModePaiementEnum.values.map((e) => e.label).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedMode = val ?? "Espèces";
                    });
                  },
                  require: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.fieldBorder),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(20),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child:
                    Text("Annuler", style: TextStyle(color: Colors.grey[700])),
              ),
            ),
            const Gap(12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text("Valider",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildInfoRow(String label, String value,
      {IconData? icon,
      Color? valueColor,
      bool isBold = false,
      double size = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[500]),
            const Gap(8),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? Colors.black87,
              fontSize: size,
            ),
          ),
        ],
      ),
    );
  }
}
