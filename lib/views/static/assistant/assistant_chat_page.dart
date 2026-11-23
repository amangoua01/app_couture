import 'package:ateliya/tools/constants/app_colors.dart';
import 'package:ateliya/tools/constants/app_icons.dart';
import 'package:ateliya/views/controllers/assistant/assistant_chat_page_vctl.dart';
import 'package:ateliya/views/static/assistant/assistant_format.dart';
import 'package:ateliya/views/static/assistant/assistant_history_page.dart';
import 'package:ateliya/views/static/assistant/assistant_packs_page.dart';
import 'package:ateliya/views/static/assistant/widgets/assistant_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssistantChatPage extends StatelessWidget {
  final int? conversationId;
  const AssistantChatPage({super.key, this.conversationId});

  static const _suggestions = [
    "Quel est mon chiffre d'affaires ce mois-ci ?",
    "Quels articles sont presque en rupture de stock ?",
    "Où en sont mes commandes en cours ?",
    "Combien de nouveaux clients cette semaine ?",
    "Quelles ont été mes dépenses ce mois-ci ?",
    "Comment fonctionne l'abonnement annuel ?",
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssistantChatPageVctl>(
      init: AssistantChatPageVctl(openConversationId: conversationId),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: _appBar(ctl),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: _content(ctl)),
                if (ctl.failure != null) _failure(ctl),
                _composer(ctl),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(AssistantChatPageVctl ctl) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      title: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sika",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, height: 1.15, color: Colors.white),
          ),
          Text(
            "Assistante Ateliya",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, height: 1.2, color: Color(0xB3FFFFFF)),
          ),
        ],
      ),
      actions: [
        // Centrée et de hauteur fixe : sans cela, la puce s'étire sur toute la barre.
        Center(child: _balanceChip(ctl)),
        const SizedBox(width: 2),
        IconButton(
          tooltip: "Historique",
          icon: const Icon(AppIcons.clockCounterClockwise),
          onPressed: () async {
            final id = await Get.to<int>(() => const AssistantHistoryPage());
            if (id != null) ctl.openConversation(id);
          },
        ),
        IconButton(
          tooltip: "Nouvelle conversation",
          icon: const Icon(AppIcons.notePencil),
          onPressed: ctl.newConversation,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _balanceChip(AssistantChatPageVctl ctl) {
    final low = ctl.balanceLoaded && ctl.balance.messagesRestants == 0;
    return GestureDetector(
      onTap: () async {
        await Get.to(() => AssistantPacksPage(balance: ctl.balance));
        ctl.loadBalance();
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: low ? AppColors.danger : AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(AppIconsBold.sparkle, size: 13, color: low ? Colors.white : AppColors.primary),
            const SizedBox(width: 5),
            Text(
              ctl.balanceLoaded ? "${ctl.balance.soldeTotal}" : "...",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: low ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(AssistantChatPageVctl ctl) {
    if (ctl.isLoadingHistory) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (!ctl.hasMessages) {
      return _emptyState(ctl);
    }
    return ListView.builder(
      controller: ctl.scrollCtl,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      itemCount: ctl.messages.length + (ctl.isSending ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == ctl.messages.length) return const AssistantTypingBubble();
        final message = ctl.messages[i];
        return AssistantBubble(
          message,
          isSpeaking: ctl.speakingIndex == i,
          onSpeak: message.fromUser ? null : () => ctl.toggleSpeak(i),
        );
      },
    );
  }

  Widget _emptyState(AssistantChatPageVctl ctl) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(AppIconsBold.sparkle, color: AppColors.secondary, size: 30),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Bonjour, je suis Sika",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        const Text(
          "Je réponds à vos questions sur votre activité et sur l'application, à partir de vos données.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.5, height: 1.4, color: AppColors.textMuted),
        ),
        const SizedBox(height: 22),
        for (final s in _suggestions)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: ctl.isSending ? null : () => ctl.send(s),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          s,
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textDark),
                        ),
                      ),
                      const Icon(Icons.north_east_rounded, size: 16, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _failure(AssistantChatPageVctl ctl) {
    final failure = ctl.failure!;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  failure.message,
                  style: const TextStyle(fontSize: 13, height: 1.35, color: AppColors.textDark),
                ),
                const SizedBox(height: 8),
                if (failure.insufficientTokens)
                  _smallButton("Recharger des tokens", () async {
                    await Get.to(() => AssistantPacksPage(balance: ctl.balance));
                    ctl.loadBalance();
                  })
                else if (ctl.messages.isNotEmpty && ctl.messages.last.fromUser)
                  _smallButton("Réessayer", ctl.retry),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5),
        ),
      ),
    );
  }

  /// Micro : touche pour parler (la question part au silence), retouche pour
  /// arrêter et garder le texte dans le champ.
  Widget _micButton(AssistantChatPageVctl ctl) {
    final listening = ctl.isListening;
    return GestureDetector(
      onTap: ctl.isSending ? null : ctl.toggleMic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: listening ? AppColors.danger : AppColors.secondary.withValues(alpha: 0.22),
          shape: BoxShape.circle,
        ),
        child: Icon(
          listening ? Icons.stop_rounded : Icons.mic_rounded,
          color: listening ? Colors.white : (ctl.isSending ? AppColors.textMuted : AppColors.primary),
        ),
      ),
    );
  }

  Widget _composer(AssistantChatPageVctl ctl) {
    final hint = ctl.balanceLoaded
        ? "${ctl.balance.coutParMessage} tokens par message, ${ctl.balance.messagesRestants} message${ctl.balance.messagesRestants > 1 ? 's' : ''} restant${ctl.balance.messagesRestants > 1 ? 's' : ''}"
        : "";
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 10, 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: ctl.inputCtl,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: AssistantChatPageVctl.maxLength,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => ctl.update(),
                  decoration: InputDecoration(
                    hintText: ctl.isListening ? "Je vous écoute..." : "Posez votre question",
                    counterText: "",
                    filled: true,
                    fillColor: AppColors.scaffoldBg,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _micButton(ctl),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: ctl.canSend ? () => ctl.send() : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ctl.canSend ? AppColors.primary : AppColors.ligthGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    color: ctl.canSend ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          if (hint.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                ctl.balance.prochainRenouvellement != null && ctl.balance.soldeForfait > 0
                    ? "$hint. Quota du forfait remis à zéro le ${formatDate(ctl.balance.prochainRenouvellement!)}"
                    : hint,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
        ],
      ),
    );
  }
}
