import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/extensions/types/datetime.dart';
import 'package:ateliya/tools/extensions/types/int.dart';
import 'package:ateliya/tools/extensions/types/string.dart';
import 'package:ateliya/tools/widgets/buttons/c_button.dart';
import 'package:ateliya/tools/widgets/inputs/c_date_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class VenteListSubPage extends StatelessWidget {
  const VenteListSubPage({super.key});

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
        items: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
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
            "${2.toAmount(unit: 'article')} X ${'2000'.toAmount(unit: 'Fcfa')}",
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  '${'4000'.toAmount(unit: 'Fcfa')} • ${DateTime.now().toFrenchDateTime}',
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
