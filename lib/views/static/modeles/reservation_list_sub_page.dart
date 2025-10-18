import 'dart:math';

import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/extensions/types/datetime.dart';
import 'package:app_couture/tools/extensions/types/string.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_date_form_field.dart';
import 'package:app_couture/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:app_couture/tools/widgets/inputs/c_text_form_field.dart';
import 'package:app_couture/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:app_couture/tools/widgets/wrapper_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class ReservationListSubPage extends StatelessWidget {
  const ReservationListSubPage({super.key});

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
        items: const [1, 2],
        itemBuilder: (_, i) => Container(
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
                title: const Text('Moustapha Cyrill'),
                subtitle: Row(
                  children: [
                    Text(
                      'Quantité : 2 • ${DateTime.now().toFrenchDateTime}',
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
              const Text(
                'Avance : 50%',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
              const Gap(5),
              LinearProgressIndicator(
                minHeight: 8,
                value: Random().nextDouble(),
                color: AppColors.yellow,
                backgroundColor: AppColors.green.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(child: Text('5000'.toAmount(unit: 'Fcfa'))),
                  Text('10000'.toAmount(unit: 'Fcfa')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
