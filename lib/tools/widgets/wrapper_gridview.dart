import 'package:app_couture/tools/constants/app_colors.dart';
import 'package:app_couture/tools/widgets/empty_data_widget.dart';
import 'package:app_couture/tools/widgets/placeholder_builder.dart';
import 'package:app_couture/tools/widgets/shimmer_gridtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WrapperGridview<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final bool isLoading;
  final bool isLoadingMore;
  final EdgeInsetsGeometry? padding;
  final Future<void> Function()? onRefresh;
  final ScrollPhysics? physics;
  final Widget? emptyWidget;
  final Widget shimmerWidget;
  final ScrollController? controller;
  final SliverGridDelegate gridDelegate;
  const WrapperGridview({
    this.controller,
    required this.gridDelegate,
    this.isLoadingMore = false,
    this.emptyWidget,
    this.shimmerWidget = const ShimmerGridtile(),
    this.padding,
    this.physics,
    this.isLoading = false,
    this.onRefresh,
    this.items = const [],
    required this.itemBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlaceholderBuilder(
      condition: !isLoading,
      placeholder: GridView.builder(
        itemCount: 20,
        padding: padding,
        gridDelegate: gridDelegate,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => shimmerWidget,
      ),
      builder: () => PlaceholderBuilder(
        condition: items.isNotEmpty,
        placeholder: PlaceholderBuilder(
          condition: emptyWidget != null,
          builder: () => emptyWidget!,
          placeholder: EmptyDataWidget(onRefresh: onRefresh),
        ),
        builder: () {
          final widget = GridView.builder(
            controller: controller,
            itemCount: items.length,
            gridDelegate: gridDelegate,
            padding: padding,
            physics: physics,
            itemBuilder: (context, index) => itemBuilder(items[index], index),
          );
          final loaderWidget = Visibility(
            visible: isLoadingMore,
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
          );
          if (onRefresh != null) {
            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: onRefresh!,
                    child: widget,
                  ),
                ),
                loaderWidget,
              ],
            );
          }
          return Column(
            children: [
              Expanded(child: widget),
              loaderWidget,
            ],
          );
        },
      ),
    );
  }
}
