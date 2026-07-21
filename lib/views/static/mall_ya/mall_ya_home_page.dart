import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/c_menu_card.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_ya_home_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MallYaHomePage extends StatelessWidget {
  const MallYaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return GetBuilder(
      init: MallYaHomeVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF062A22),
                          AppColors.primary,
                          Color(0xFF0D5040)
                        ],
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(32)),
                    ),
                    padding: EdgeInsets.fromLTRB(16, topPadding + 56, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(12),
                        const Text(
                          'Votre espace boutique',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          'Gérez tout depuis un seul endroit',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 17),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.storefront_rounded,
                              color: Colors.white, size: 16),
                          Gap(6),
                          Text(
                            'Mall Ya',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = ctl.menuItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CMenuCard(
                          icon: item.icon,
                          label: item.label,
                          subtitle: item.subtitle,
                          gradient: item.gradient,
                          accentColor: item.accentColor,
                          onTap: item.onTap,
                        ),
                      );
                    },
                    childCount: ctl.menuItems.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
