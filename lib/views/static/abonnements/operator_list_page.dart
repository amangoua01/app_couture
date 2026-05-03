import 'package:ateliya/data/models/module_abonnement.dart';
import 'package:ateliya/data/models/operateur.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/wrapper_listview.dart';
import 'package:ateliya/views/controllers/abonnements/operator_list_page_vctl.dart';
import 'package:ateliya/views/static/abonnements/abonnement_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OperatorListPage extends StatelessWidget {
  final ModuleAbonnement forfait;
  const OperatorListPage(this.forfait, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: OperatorListPageVctl(),
      builder: (ctl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Opérateurs"),
          ),
          body: WrapperListview<Operateur>(
            padding: const EdgeInsets.all(20),
            isLoading: ctl.isLoading,
            onRefresh: ctl.getOperateurs,
            items: ctl.operateurs,
            itemBuilder: (e, index) => Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                onTap: () => Get.to(() => AbonnementPaymentPage(
                      forfait: forfait,
                      operateur: e,
                    )),
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SvgPicture.asset(
                      "assets/images/svg/mobile.svg",
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    // child: PlaceholderBuilder(
                    //   condition: e.photo?.fullUrl != null,
                    //   builder: () {
                    //     return Image.network(
                    //       e.photo!.fullUrl!,
                    //       fit: BoxFit.cover,
                    //     );
                    //   },
                    // ),
                  ),
                ),
                title: Text(
                  e.libelle ?? "Opérateur",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // subtitle: Text(
                //   e.code ?? "",
                //   style: TextStyle(
                //     color: Colors.grey[600],
                //     fontSize: 13,
                //   ),
                // ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}
