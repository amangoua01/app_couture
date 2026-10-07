import 'package:ateliya/data/models/abstract/model_json.dart';
import 'package:ateliya/tools/components/card_style.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/placeholder_builder.dart';
import 'package:ateliya/tools/widgets/shimmer_listtile.dart';
import 'package:ateliya/views/controllers/abstract/list_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Le trait qui sépare deux lignes à l'intérieur d'une même carte ; décalé
/// pour ne pas passer sous l'avatar de la ligne.
Widget _rowDivider(BuildContext context, int index) =>
    Divider(height: 1, indent: 70, color: Colors.grey[150]);

/// Habille une liste en une seule carte continue (plutôt que des cartes
/// isolées par ligne), pour un rendu dense et structuré.
class _ListSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;

  const _ListSurface({
    required this.child,
    this.margin = const EdgeInsets.fromLTRB(12, 10, 12, 20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: CardStyle.decoration(),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class WrapperListviewFromViewController<M extends ModelJson>
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
      placeholder: _ListSurface(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          separatorBuilder: _rowDivider,
          itemBuilder: (context, index) => const ShimmerListtile(),
        ),
      ),
      builder:
          () => PlaceholderBuilder(
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
            builder:
                () => PlaceholderBuilder(
                  condition: ctl.selected == null,
                  placeholder: _ListSurface(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: ctl.scrollCtl,
                      itemCount: ctl.data.length,
                      separatorBuilder: _rowDivider,
                      itemBuilder: itemBuilder,
                    ),
                  ),
                  builder: () {
                    return RefreshIndicator(
                      onRefresh: ctl.getList,
                      child: Column(
                        children: [
                          Expanded(
                            child: _ListSurface(
                              margin: const EdgeInsets.fromLTRB(
                                12,
                                10,
                                12,
                                100,
                              ),
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: ctl.scrollCtl,
                                itemCount: ctl.data.length,
                                separatorBuilder: _rowDivider,
                                itemBuilder: itemBuilder,
                              ),
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
