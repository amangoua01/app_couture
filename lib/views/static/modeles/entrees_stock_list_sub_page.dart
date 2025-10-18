import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/extensions/types/datetime.dart';
import 'package:app_couture/tools/widgets/buttons/c_button.dart';
import 'package:app_couture/tools/widgets/inputs/c_date_form_field.dart';
import 'package:app_couture/tools/widgets/inputs/c_drop_down_form_field.dart';
import 'package:app_couture/tools/widgets/messages/c_bottom_sheet.dart';
import 'package:app_couture/tools/widgets/wrapper_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class EntreesStockListSubPage extends StatelessWidget {
  const EntreesStockListSubPage({super.key});

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
              const CDropDownFormField(labelText: 'Opérateur'),
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
              'assets/images/svg/box.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.yellow,
                BlendMode.srcIn,
              ),
            ),
          ),
          title: const Text('Hamed Ndiaye'),
          subtitle: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '+${i + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const TextSpan(text: ' • '),
                TextSpan(text: ' ${DateTime.now().toFrenchDateTime} '),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
