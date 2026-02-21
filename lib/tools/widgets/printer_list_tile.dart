import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/models/blue_device.dart';
import 'package:flutter/material.dart';

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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      selected: isConnected,
      selectedColor: AppColors.primary,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isConnected ? AppColors.primary : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.print,
            color: isConnected ? Colors.white : Colors.grey[600], size: 20),
      ),
      title: Text(
        item.name.isNotEmpty ? item.name : "Imprimante inconnue",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(item.address),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isConnected)
            const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          // Bouton connecter si pas connecté et pas de delete (mode liste recherche)
          if (!isConnected && onDelete == null && onConnect != null)
            ElevatedButton(
              onPressed: onConnect,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(60, 30)),
              child: const Text("Lier"),
            )
        ],
      ),
      onTap: onConnect, // Tap global fonctionne aussi
    );
  }
}
