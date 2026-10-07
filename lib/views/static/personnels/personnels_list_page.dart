import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/list_item.dart';
import 'package:ateliya/tools/widgets/messages/c_snackbar.dart';
import 'package:ateliya/views/controllers/personnels/personnels_list_page_vctl.dart';
import 'package:ateliya/views/static/personnels/edition_personnel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PersonnelListPage extends StatelessWidget {
  const PersonnelListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: PersonnelsListPageVctl(),
      builder: (ctl) {
        return BodyListView(
          ctl,
          title: "Personnel",
          createPage: const EditionPersonnelPage(),
          itemBuilder: (_, i, selected) {
                final item = ctl.data.items[i];
                final isMe = ctl.user.id == item.id;
                final photo = item.photoProfil;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppColors.primary.withOpacity(0.15), width: 1.5),
                  ),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () => Get.to(() => EditionPersonnelPage(item: item)),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
                            ),
                            child: photo != null && photo.isNotEmpty
                                ? CircleAvatar(radius: 22, backgroundImage: NetworkImage(photo))
                                : const CircleAvatar(radius: 22, backgroundColor: Color(0xFFF1F5F9), child: Icon(Icons.person_rounded, color: AppColors.primary)),
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isMe ? "Vous-même" : (item.nom.value.isNotEmpty ? item.nom.value : "Sans nom"),
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF0F231F)),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                                const Gap(4),
                                Text(
                                  item.login ?? "Aucun email",
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          if (item.isActive == true)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: const Text("Actif", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: const Text("Inactif", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
        );
      },
    );
  }
}
