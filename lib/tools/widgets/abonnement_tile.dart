import 'package:ateliya/data/models/abonnement.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/models/abn_tile_item.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ticket_widget/ticket_widget.dart';

class AbonnementTile extends StatelessWidget {
  final Abonnement item;
  const AbonnementTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return TicketWidget(
      color: AppColors.primary,
      width: double.maxFinite,
      height: 175,
      isCornerRounded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => CBottomSheet.show(
                  child: ListView.separated(
                    itemCount: item.modules.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) => ListTile(
                      leading: CircleAvatar(
                        child: SvgPicture.asset(
                          'assets/images/svg/piece.svg',
                          width: 20,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      title: Text(item.modules[i].libelle.value),
                      subtitle: Text(item.modules[i].description.value),
                      trailing: Text(
                        item.modules[i].quantite.toAmount(unit: ""),
                      ),
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/svg/list.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const Gap(5),
                      const Text(
                        'Voir les avantages',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 20,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.etat.value.capitalize(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    item.type.value.capitalize(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    item.montant.toAmount(unit: "Fcfa"),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    AbnTileItem(
                      title: 'Date début',
                      date: item.dateDebut.value,
                    ),
                    AbnTileItem(
                      title: 'Date fin',
                      date: item.dateFin.value,
                    ),
                  ]
                      .map(
                        (e) => Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                e.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  e.date.toFrenchDateTime,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
