import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/ternary_fn.dart';
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

class EntreesStockListSubPage extends StatelessWidget {
  final DetailBoutiqueItemPageVctl ctl;
  const EntreesStockListSubPage(this.ctl, {super.key});

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
              CDropDownFormField(
                labelText: 'Opérateur',
                items: (e, f) => ctl.modele.operateurs,
                itemAsString: (e) => e.fullName,
              ),
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
        items: ctl.modele.ligneEntres(ctl.entreStockFilter),
        itemBuilder: (e, i) => ListTile(
          leading: CircleAvatar(
            child: SvgPicture.asset(
              'assets/images/svg/box.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.yellow,
                BlendMode.srcIn,
              ),
            ),
          ),
          title: Text(e.entreStock?.creator?.fullName ?? ''),
          subtitle: Row(
            children: [
              Image.asset(
                ternaryFn(
                  condition: e.entreStock?.isEntree == false,
                  ifTrue: "assets/images/svg/entrant.png",
                  ifFalse: "assets/images/svg/sortant.png",
                ),
                height: 15,
                color: ternaryFn(
                  condition: e.entreStock?.isEntree == true,
                  ifTrue: Colors.green,
                  ifFalse: Colors.red,
                ),
              ),
              const Gap(5),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${e.entreStock?.isEntree == true ? '+' : '-'}${e.quantite} ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ternaryFn(
                            condition: e.entreStock?.isEntree == true,
                            ifTrue: Colors.green,
                            ifFalse: Colors.red,
                          ),
                        ),
                      ),
                      const TextSpan(text: ' • '),
                      TextSpan(
                          text: ' ${e.entreStock?.date.toFrenchDateTime} '),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
