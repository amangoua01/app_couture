import 'package:ateliya/data/dto/mesure/ligne_mesure_dto.dart';
import 'package:ateliya/data/dto/mesure/mensuration_dto.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/mesure/edition_mesure_page_vctl.dart';
import 'package:ateliya/views/static/mesure/edition_mensuration_page.dart';
import 'package:ateliya/views/static/mesure/edition_piece_couture_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ListPieceSubPage extends StatelessWidget {
  final EditionMesurePageVctl ctl;
  const ListPieceSubPage(this.ctl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Get.to(
            () => const EditionPieceCouturePage(),
          );
          if (res is LigneMesureDto) {
            ctl.mesure.lignesMesures.add(res);
            ctl.update();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: WrapperListview(
        items: ctl.mesure.lignesMesures,
        padding: const EdgeInsets.all(20),
        itemBuilder: (e, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.withAlpha(100),
              child: IconButton(
                color: Colors.red,
                onPressed: () async {
                  final rep = await CChoiceMessageDialog.show(
                    message: "Voulez-vous vraiment"
                        " supprimer cette pièce ?",
                  );
                  if (rep == true) {
                    ctl.mesure.lignesMesures.remove(e);
                    ctl.update();
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ),
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              e.libelle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(e.getCalcul),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: CircleAvatar(
                    child: SvgPicture.asset(
                      "assets/images/svg/measure_meter.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  onTap: () async {
                    final res = await Get.to(
                      () => EditionMensurationPage(e),
                    );
                    if (res is List<MensurationDto>) {
                      e.typeMesureDto!.mensurations = res;
                      ctl.update();
                    }
                  },
                ),
                const Gap(20),
                const Icon(Icons.arrow_forward_ios, size: 20)
              ],
            ),
            onTap: () async {
              final res = await Get.to(
                () => EditionPieceCouturePage(ligne: e),
              );
              if (res is LigneMesureDto) {
                ctl.mesure.lignesMesures[index] = res;
                ctl.update();
              }
            },
          );
        },
      ),
    );
  }
}
