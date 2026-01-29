import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/double.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/home/detail_boutique_item_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class VenteListSubPage extends StatelessWidget {
  final DetailBoutiqueItemPageVctl ctl;
  const VenteListSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => CBottomSheet.show(
          child: GetBuilder(
              init: ctl,
              builder: (_) {
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    CDateFormField(
                      labelText: 'Date début',
                      controller: ctl.filterVente.dateDebut,
                      withTime: true,
                      onClear: () {
                        ctl.filterVente.dateDebut.clear();
                        ctl.update();
                      },
                      onChange: (e) {
                        ctl.filterVente.dateDebut.dateTime = e;
                        ctl.update();
                      },
                    ),
                    CDateFormField(
                      labelText: "Date fin",
                      withTime: true,
                      controller: ctl.filterVente.dateFin,
                      onClear: () {
                        ctl.filterVente.dateDebut.clear();
                        ctl.update();
                      },
                      onChange: (e) {
                        ctl.filterVente.dateFin.dateTime = e;
                        ctl.update();
                      },
                    ),
                    CDropDownFormField(
                      labelText: 'Client',
                      items: (e, f) => ctl.modele.clients,
                      selectedItem: ctl.filterVente.client,
                      itemAsString: (e) => e.fullName,
                      onChanged: (e) {
                        ctl.filterVente.client = e;
                        ctl.update();
                      },
                    ),
                    const Gap(20),
                    CButton(onPressed: Get.back),
                  ],
                );
              }),
        ),
        child: SvgPicture.asset(
          'assets/images/svg/filter.svg',
          height: 30,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
      body: WrapperListview(
        items: ctl.modele.paiementBoutiqueLignes(ctl.filterVente),
        itemBuilder: (_, i) => ListTile(
          leading: CircleAvatar(
            child: SvgPicture.asset(
              'assets/images/svg/bag.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.yellow,
                BlendMode.srcIn,
              ),
            ),
          ),
          title: Text(
            "${ctl.modele.paiementBoutiqueLignes(ctl.filterVente).length.toAmount(unit: 'article(s)')} X ${ctl.modele.paiementBoutiqueLignes(ctl.filterVente)[i].montant.toAmount(unit: 'F')}",
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  '${ctl.modele.paiementBoutiqueLignes(ctl.filterVente)[i].total.toAmount(unit: 'F')} • ${ctl.modele.paiementBoutiqueLignes(ctl.filterVente)[i].paiementBoutique?.createdAt.toFrenchDateTime}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.green.withAlpha(180),
            child: IconButton(
              splashRadius: 20,
              icon: SvgPicture.asset(
                'assets/images/svg/client.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => CBottomSheet.show(child: Container()),
            ),
          ),
        ),
      ),
    );
  }
}
