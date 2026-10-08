import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/body_list_view.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/views/controllers/personnels/personnels_list_page_vctl.dart';
import 'package:ateliya/views/static/personnels/edition_personnel_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            final isActive = item.isActive ?? true;
            final photo = item.photoProfil;
            final isToggling = ctl.togglingIds.contains(item.id);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: CardStyle.decoration(),
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.to(() => EditionPersonnelPage(item: item)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        photo != null && photo.isNotEmpty
                            ? CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(photo),
                            )
                            : CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  isActive
                                      ? AppColors.primary.withValues(
                                        alpha: 0.08,
                                      )
                                      : Colors.grey.shade200,
                              child: Icon(
                                Icons.person_rounded,
                                color:
                                    isActive ? AppColors.primary : Colors.grey,
                              ),
                            ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isMe
                                    ? "Vous-même"
                                    : (item.nom.value.isNotEmpty
                                        ? item.nom.value
                                        : "Sans nom"),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                  color: AppColors.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(2),
                              Text(
                                item.login ?? "Aucun email",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                        if (isToggling)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          CupertinoSwitch(
                            value: isActive,
                            activeTrackColor: AppColors.primary,
                            // On ne se désactive pas soi-même depuis cette
                            // liste : ça couperait l'accès de la personne en
                            // train de l'utiliser.
                            onChanged:
                                isMe
                                    ? null
                                    : (value) async {
                                      if (!value) {
                                        final confirmed =
                                            await CChoiceMessageDialog.show(
                                              message:
                                                  "Désactiver ${item.nom.value.isNotEmpty ? item.nom.value : 'ce membre'} ? Il ne pourra plus se connecter.",
                                            );
                                        if (confirmed != true) return;
                                      }
                                      ctl.toggleActive(item);
                                    },
                          ),
                      ],
                    ),
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
