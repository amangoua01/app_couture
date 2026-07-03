import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/views/controllers/home/boutique_page_vctl.dart';
import 'package:flutter/material.dart';

class SearchBarPart extends StatelessWidget {
  final BoutiquePageVctl ctl;
  const SearchBarPart({super.key, required this.ctl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAF9),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: ctl.searchCtl,
                onChanged: ctl.onSearch,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Rechercher un modèle, taille, prix...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary.withValues(alpha: 0.35),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppColors.secondary,
                      size: 22,
                    ),
                  ),
                  suffixIcon: ctl.hasQuery
                      ? GestureDetector(
                          onTap: ctl.clearSearch,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.primary,
                              size: 14,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
