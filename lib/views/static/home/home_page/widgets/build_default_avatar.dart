import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../data/models/user.dart';

class BuildDefaultAvatar extends StatelessWidget {
  final User user;
  const BuildDefaultAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final initials = (user.prenoms != null && user.prenoms!.isNotEmpty)
        ? user.prenoms!.substring(0, 1).toUpperCase()
        : (user.nom != null && user.nom!.isNotEmpty)
            ? user.nom!.substring(0, 1).toUpperCase()
            : "U";
    return Container(
      color: AppColors.primary,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: AppColors.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
