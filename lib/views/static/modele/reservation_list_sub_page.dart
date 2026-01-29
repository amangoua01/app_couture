import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/home/detail_boutique_item_page_vctl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class ReservationListSubPage extends StatelessWidget {
  final DetailBoutiqueItemPageVctl ctl;
  const ReservationListSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => CBottomSheet.show(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CDateFormField(
                labelText: 'Date début',
                onChange: (e) {},
              ),
              CDateFormField(
                labelText: "Date fin",
                onChange: (e) {},
              ),
              const CDropDownFormField(labelText: 'Client'),
              const CTextFormField(labelText: "Numéro du client"),
              const Gap(20),
              const CButton(),
            ],
          ),
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
        padding: const EdgeInsets.all(10),
        items: ctl.modele.ligneReservations(ctl.filterVente),
        itemBuilder: (e, i) => Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: SvgPicture.asset(
                    'assets/images/svg/calendar.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.yellow,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                title: Text(
                  e.reservation?.client?.fullName ?? 'Client inconnu',
                ),
                subtitle: Row(
                  children: [
                    Text(
                      '${e.quantite} unité(s) • ${e.reservation?.createdAt.toFrenchDateTime}',
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.smartphone,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Text(
                'Avance : ${(e.reservation!.evolution * 100).toStringAsFixed(0)}%',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
              const Gap(5),
              LinearProgressIndicator(
                minHeight: 8,
                value: e.reservation!.evolution,
                color: AppColors.yellow,
                backgroundColor: AppColors.green.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: Text(e.reservation!.avance.toAmount(unit: 'F')),
                  ),
                  Text(e.reservation!.montant.toAmount(unit: 'F')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
