import 'package:app_couture/data/models/abstract/model.dart';
import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/placeholder_builder.dart';
import 'package:app_couture/tools/widgets/shimmer_listtile.dart';
import 'package:app_couture/views/controllers/abstract/list_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WrapperListviewFromViewController<M extends Model>
    extends StatelessWidget {
  final Widget? Function(BuildContext, int) itemBuilder;
  final ListViewController ctl;

  const WrapperListviewFromViewController({
    required this.ctl,
    required this.itemBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlaceholderBuilder(
      condition: !ctl.isLoading,
      placeholder: ListView.builder(
        itemCount: 20,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const ShimmerListtile(),
      ),
      builder: () => PlaceholderBuilder(
        condition: ctl.data.isNotEmpty,
        placeholder: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/deco3.png", width: 200),
              ListTile(
                title: Text(
                  "Aucune données trouvées",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () => ctl.getList(search: ctl.search),
                child: const Text("Réessayer"),
              ),
            ],
          ),
        ),
        builder: () => PlaceholderBuilder(
          condition: ctl.selected == null,
          placeholder: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: ctl.scrollCtl,
            itemCount: ctl.data.length,
            itemBuilder: itemBuilder,
          ),
          builder: () {
            return RefreshIndicator(
              onRefresh: ctl.getList,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 150),
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: ctl.scrollCtl,
                      itemCount: ctl.data.length,
                      itemBuilder: itemBuilder,
                    ),
                  ),
                  Visibility(
                    visible: ctl.isMoreLoading,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: const SpinKitWave(
                        color: AppColors.primary,
                        size: 25.0,
                        type: SpinKitWaveType.center,
                      ).animate().slide(
                            duration: 200.ms,
                            curve: Curves.decelerate,
                            begin: const Offset(0, 2),
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
