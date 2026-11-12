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
      labelColor: AppColors.textDark,
      unselectedLabelColor: AppColors.textMuted,
      labelStyle: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
      ),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.secondary, width: 3.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
        insets: EdgeInsets.symmetric(horizontal: 4),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: widget.onTap,
      tabs: [
        for (final t in widget.tabs)
          Tab(
            height: 48,
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
                      horizontal: 6,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${t.count}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );

    return Container(
      margin: widget.margin,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDDE3DF))),
      ),
      child: widget.trailing == null
          ? bar
          : Row(
              children: [
                Expanded(child: bar),
                widget.trailing!,
              ],
            ),
    );
  }
}
