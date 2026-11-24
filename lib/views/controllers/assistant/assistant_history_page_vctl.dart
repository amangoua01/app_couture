import 'package:ateliya/api/assistant_api.dart';
import 'package:ateliya/data/models/assistant/assistant_conversation.dart';
import 'package:ateliya/tools/widgets/messages/c_message_dialog.dart';
import 'package:get/get.dart';

class AssistantHistoryPageVctl extends GetxController {
  /// Prévenu quand une conversation est supprimée (le chat en cours peut être concerné).
  final void Function(int id)? onDeleted;

  AssistantHistoryPageVctl({this.onDeleted});

  final api = AssistantApi();
  List<AssistantConversation> conversations = [];
  bool isLoading = true;
  String? error;

  @override
  void onReady() {
    load();
    super.onReady();
  }

  Future<void> load() async {
    isLoading = true;
    error = null;
    update();
    final res = await api.conversations();
    isLoading = false;
    if (res.status) {
      conversations = res.data!;
    } else {
      error = res.message;
    }
    update();
  }

  Future<bool> rename(AssistantConversation c, String titre) async {
    final res = await api.renameConversation(c.id, titre.trim());
    if (!res.status) {
      CMessageDialog.show(message: res.message);
      return false;
    }
    final i = conversations.indexWhere((e) => e.id == c.id);
    if (i >= 0) conversations[i] = res.data!;
    // La plus récemment modifiée remonte en tête.
    conversations.sort((a, b) => (b.misAJourLe ?? DateTime(0)).compareTo(a.misAJourLe ?? DateTime(0)));
    update();
    return true;
  }

  Future<bool> remove(AssistantConversation c) async {
    final res = await api.deleteConversation(c.id);
    if (!res.status) {
      CMessageDialog.show(message: res.message);
      return false;
    }
    conversations.removeWhere((e) => e.id == c.id);
    onDeleted?.call(c.id);
    update();
    return true;
  }
}
