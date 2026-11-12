import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Un onglet : libellé, icône facultative et compteur facultatif.
class AppTabItem {
  final String label;
  final IconData? icon;
  final int? count;
  const AppTabItem(this.label, {this.icon, this.count});
}

/// Barre d'onglets commune à l'application.
///
/// - le trait doré, aux extrémités arrondies, suit le doigt pendant qu'on
///   glisse d'un onglet à l'autre ;
/// - le libellé actif passe en gras et en vert foncé, les autres restent
///   discrets ;
/// - un compteur (pastille) peut accompagner un onglet ;
/// - un léger retour haptique confirme le changement d'onglet.
///
/// À utiliser avec un [TabController] ou un `DefaultTabController` parent.
class AppTabBar extends StatefulWidget {
  final List<AppTabItem> tabs;
  final TabController? controller;
  final bool isScrollable;
  final ValueChanged<int>? onTap;
  final EdgeInsetsGeometry margin;
  final Widget? trailing;

  const AppTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.onTap,
    this.margin = EdgeInsets.zero,
    this.trailing,
  });

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> {
  TabController? _ctl;
  int _last = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = widget.controller ?? DefaultTabController.maybeOf(context);
    if (next != _ctl) {
      _ctl?.removeListener(_haptique);
      _ctl = next;
      _last = next?.index ?? -1;
      _ctl?.addListener(_haptique);
    }
  }

  void _haptique() {
    final c = _ctl;
    if (c == null || c.indexIsChanging) return;
    if (c.index != _last) {
      _last = c.index;
      HapticFeedback.selectionClick();
    }
  }

  @override
  void dispose() {
    _ctl?.removeListener(_haptique);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bar = TabBar(
      controller: widget.controller,
      isScrollable: widget.isScrollable,
      tabAlignment: widget.isScrollable ? TabAlignment.start : null,
      padding: EdgeInsets.zero,
      labelPadding: widget.isScrollable
          ? const EdgeInsets.symmetric(horizontal: 18)
          : null,
      labelColor: Colors.white,
      unselectedLabelColor: AppColors.primary,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      // La pastille glisse avec le doigt quand on balaie l'écran.
      indicator: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: widget.onTap,
      tabs: [
        for (final t in widget.tabs)
          Tab(
            height: 38,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (t.icon != null) ...[
                  Icon(t.icon, size: 18),
                  const SizedBox(width: 6),
                ],
                Text(t.label),
                if (t.count != null) ...[
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${t.count}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );

    final capsule = Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(30),
      ),
      child: bar,
    );

    return Padding(
      padding: widget.margin == EdgeInsets.zero
          ? const EdgeInsets.fromLTRB(16, 6, 16, 10)
          : widget.margin,
      child: widget.trailing == null
          ? capsule
          : Row(
              children: [
                Expanded(child: capsule),
                const SizedBox(width: 10),
                widget.trailing!,
              ],
            ),
    );
  }
}
