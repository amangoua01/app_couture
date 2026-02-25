import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/models/blue_device.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PrinterListTile extends StatelessWidget {
  final BlueDevice item;
  final Function()? onConnect;
  final Function()? onDelete;
  final bool isConnected;

  const PrinterListTile(
    this.item, {
    this.onConnect,
    this.onDelete,
    this.isConnected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onConnect,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isConnected
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : Colors.grey.shade100,
              width: isConnected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isConnected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icône imprimante
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isConnected ? AppColors.primary : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.print_rounded,
                  color: isConnected ? Colors.white : Colors.grey[500],
                  size: 22,
                ),
              ),
              const Gap(14),

              // Nom + adresse
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.isNotEmpty ? item.name : "Imprimante inconnue",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isConnected ? AppColors.primary : Colors.black87,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      item.address,
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    if (isConnected) ...[
                      const Gap(4),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Gap(5),
                          const Text(
                            "Connectée",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isConnected && onConnect != null)
                    TextButton(
                      onPressed: onConnect,
                      style: TextButton.styleFrom(
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Lier",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  if (onDelete != null) ...[
                    const Gap(8),
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Colors.red, size: 18),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
