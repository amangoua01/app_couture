import 'package:ateliya/data/models/mall_statut.dart';
import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/widgets/inputs/c_image_picker_field.dart';
import 'package:ateliya/tools/widgets/inputs/c_text_form_field.dart';
import 'package:ateliya/tools/widgets/messages/c_choice_message_dialog.dart';
import 'package:ateliya/views/controllers/mall_ya/mall_status_vctl.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

const _kColor = Color(0xFF00695C);

class MallStatusPage extends StatelessWidget {
  const MallStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return GetBuilder(
      init: MallStatusVctl(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 150,
                backgroundColor: const Color(0xFF062A22),
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF062A22),
                          AppColors.primary,
                          Color(0xFF0D5040),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(32)),
                    ),
                    padding: EdgeInsets.fromLTRB(16, topPadding + 56, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(12),
                        const Text(
                          'Statuts boutique',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          'Publiez des statuts visibles par vos clients.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 17),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              if (ctl.statuts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _kColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.circle_outlined,
                              color: _kColor, size: 36),
                        ),
                        const Gap(16),
                        const Text(
                          'Aucun statut actif',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: Color(0xFF062A22),
                          ),
                        ),
                        const Gap(6),
                        const Text(
                          'Appuyez sur + pour publier\nvotre premier statut.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Section titre style WA ──
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Mes statuts récents',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        // ── Bulles horizontales style WA ──
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: ctl.statuts.length,
                            separatorBuilder: (_, __) => const Gap(16),
                            itemBuilder: (_, i) => _StatusBubble(
                              statut: ctl.statuts[i],
                              onTap: () =>
                                  _openViewer(context, ctl.statuts, i, ctl),
                            ),
                          ),
                        ),
                        const Gap(24),
                        // ── Liste détaillée ──
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            'Tous les statuts',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        ...ctl.statuts.map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _StatutRow(
                                statut: s,
                                onTap: () => _openViewer(context, ctl.statuts,
                                    ctl.statuts.indexOf(s), ctl),
                                onDelete: () => _confirmDelete(ctl, s),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: _Fab(
            onTap: () => _showForm(context, ctl),
          ),
        );
      },
    );
  }

  void _openViewer(BuildContext context, List<MallStatut> statuts, int index,
      MallStatusVctl ctl) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) =>
            _StatusViewer(statuts: statuts, initialIndex: index, ctl: ctl),
      ),
    );
  }

  Future<void> _confirmDelete(MallStatusVctl ctl, MallStatut statut) async {
    final confirm = await CChoiceMessageDialog.show(
      message: 'Supprimer ce statut ?',
      validText: 'Supprimer',
      cancelText: 'Annuler',
      secondaryColor: Colors.red,
    );
    if (confirm == true) ctl.deleteStatut(statut.id);
  }

  void _showForm(BuildContext context, MallStatusVctl ctl) {
    ctl.clearForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _StatutFormSheet(ctl: ctl),
    );
  }
}

// ── Bulle style WA ────────────────────────────────────────────────────────────

class _StatusBubble extends StatelessWidget {
  final MallStatut statut;
  final VoidCallback onTap;

  const _StatusBubble({required this.statut, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [_kColor, Color(0xFF26A69A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: _kColor, width: 2.5),
            ),
            child: ClipOval(
              child: statut.fullUrl != null
                  ? Image.network(statut.fullUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _textIcon())
                  : _textIcon(),
            ),
          ),
          const Gap(5),
          SizedBox(
            width: 58,
            child: Text(
              _timeAgo(statut.createdAt),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textIcon() => Container(
        color: _kColor.withValues(alpha: 0.3),
        child: Center(
          child: Icon(
            statut.type == 'TEXTE'
                ? Icons.text_fields_rounded
                : Icons.image_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      );

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes}min';
      if (diff.inHours < 24) return 'il y a ${diff.inHours}h';
      return 'il y a ${diff.inDays}j';
    } catch (_) {
      return '';
    }
  }
}

// ── Ligne liste style WA ──────────────────────────────────────────────────────

class _StatutRow extends StatelessWidget {
  final MallStatut statut;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _StatutRow(
      {required this.statut, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Miniature
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _kColor, width: 2),
              ),
              child: ClipOval(
                child: statut.fullUrl != null
                    ? Image.network(statut.fullUrl!,
                        fit: BoxFit.cover, errorBuilder: (_, __, ___) => _ph())
                    : _ph(),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statut.contenu?.isNotEmpty == true
                        ? statut.contenu!
                        : statut.type,
                    style: const TextStyle(
                      color: Color(0xFF062A22),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(3),
                  Row(
                    children: [
                      const Icon(Icons.visibility_rounded,
                          size: 11, color: Colors.grey),
                      const Gap(3),
                      Text(
                        '${statut.vues} vue${statut.vues > 1 ? 's' : ''}',
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const Gap(8),
                      if (statut.expiresAt != null)
                        Text(
                          'Expire ${_timeLeft(statut.expiresAt!)}',
                          style:
                              const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_rounded,
                    color: Colors.red, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ph() => Container(
        color: _kColor.withValues(alpha: 0.3),
        child: const Icon(Icons.text_fields_rounded,
            color: Colors.white, size: 20),
      );

  String _timeLeft(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final diff = dt.difference(DateTime.now());
      if (diff.isNegative) return 'expiré';
      if (diff.inHours < 1) return 'dans ${diff.inMinutes}min';
      return 'dans ${diff.inHours}h';
    } catch (_) {
      return '';
    }
  }
}

// ── Viewer plein écran style WA ───────────────────────────────────────────────

class _StatusViewer extends StatefulWidget {
  final List<MallStatut> statuts;
  final int initialIndex;
  final MallStatusVctl ctl;

  const _StatusViewer(
      {required this.statuts, required this.initialIndex, required this.ctl});

  @override
  State<_StatusViewer> createState() => _StatusViewerState();
}

class _StatusViewerState extends State<_StatusViewer>
    with SingleTickerProviderStateMixin {
  late int _current;
  late AnimationController _progressCtrl;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) _next();
      });
    // Précacher toutes les images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final s in widget.statuts) {
        if (s.fullUrl != null) {
          precacheImage(NetworkImage(s.fullUrl!), context);
        }
      }
    });
    _startProgress();
    widget.ctl.incrementVues(widget.statuts[_current].id);
  }

  void _startProgress() {
    _progressCtrl.reset();
    _progressCtrl.forward();
  }

  void _next() {
    if (_current < widget.statuts.length - 1) {
      setState(() => _current++);
      _startProgress();
      widget.ctl.incrementVues(widget.statuts[_current].id);
    } else {
      Navigator.pop(context);
    }
  }

  void _prev() {
    if (_current > 0) {
      setState(() => _current--);
      _startProgress();
    }
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statut = widget.statuts[_current];
    final imageUrl = statut.fullUrl;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background ──
          if (imageUrl != null)
            Image.network(imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _textBg(statut))
          else
            _textBg(statut),

          // ── Gradient top ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Progress bars ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: AnimatedBuilder(
              animation: _progressCtrl,
              builder: (_, __) => Row(
                children: List.generate(widget.statuts.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: i < _current
                              ? 1.0
                              : i == _current
                                  ? _progressCtrl.value
                                  : 0.0,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                          minHeight: 3,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── Header ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _kColor, width: 2),
                    color: _kColor.withValues(alpha: 0.3),
                  ),
                  child: const Icon(Icons.storefront_rounded,
                      color: Colors.white, size: 18),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ma boutique',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                      Text(
                        _timeAgo(statut.createdAt),
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 11),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 24),
                ),
              ],
            ),
          ),

          // ── Tap zones prev/next ──
          Row(
            children: [
              Expanded(child: GestureDetector(onTap: _prev)),
              Expanded(child: GestureDetector(onTap: _next)),
            ],
          ),

          // ── Caption (IMAGE/VIDEO seulement) ──
          if (statut.type != 'TEXTE' &&
              statut.contenu != null &&
              statut.contenu!.isNotEmpty)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statut.contenu!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // ── Vues ──
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 80,
            right: 16,
            child: Row(
              children: [
                const Icon(Icons.visibility_rounded,
                    color: Colors.white, size: 14),
                const Gap(4),
                Text('${statut.vues}',
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textBg(MallStatut s) => Container(
        color: const Color(0xFF1A2C25),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              s.contenu ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'il y a ${diff.inHours}h';
      return 'il y a ${diff.inDays}j';
    } catch (_) {
      return '';
    }
  }
}

// ── Form bottom sheet ─────────────────────────────────────────────────────────

class _StatutFormSheet extends StatelessWidget {
  final MallStatusVctl ctl;

  const _StatutFormSheet({required this.ctl});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: GetBuilder<MallStatusVctl>(
          builder: (c) => ListView(
            controller: scrollCtrl,
            padding: EdgeInsets.fromLTRB(
                20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 32),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _kColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.circle_outlined,
                        color: _kColor, size: 18),
                  ),
                  const Gap(10),
                  const Text(
                    'Nouveau statut',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF062A22)),
                  ),
                ],
              ),
              const Gap(20),
              Row(
                children: ['TEXTE', 'IMAGE', 'VIDEO'].map((t) {
                  final selected = c.selectedType == t;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => c.setType(t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? _kColor
                                : _kColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              t,
                              style: TextStyle(
                                color: selected ? Colors.white : _kColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Gap(16),
              CTextFormField(
                externalLabel: c.selectedType == 'TEXTE'
                    ? 'Texte du statut'
                    : 'Légende (optionnel)',
                controller: c.contenuCtl,
                maxLines: c.selectedType == 'TEXTE' ? 4 : 2,
                textCapitalization: TextCapitalization.sentences,
                require: c.selectedType == 'TEXTE',
              ),
              if (c.selectedType != 'TEXTE') ...[
                const Gap(4),
                SizedBox(
                  height: 160,
                  child: CImagePickerField(
                    label: c.selectedType == 'VIDEO' ? 'Vidéo' : 'Image',
                    path: c.fichier?.path,
                    onChanged: c.setFichier,
                    onDelete: c.removeFichier,
                  ),
                ),
              ],
              const Gap(24),
              GestureDetector(
                onTap: () => c.createStatut(() => Navigator.pop(context)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: _kColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      Gap(8),
                      Text(
                        'Publier',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── FAB ───────────────────────────────────────────────────────────────────────

class _Fab extends StatelessWidget {
  final VoidCallback onTap;

  const _Fab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: _kColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _kColor.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
