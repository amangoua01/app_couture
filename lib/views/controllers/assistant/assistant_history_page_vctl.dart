import 'package:ateliya/api/assistant_api.dart';
import 'package:ateliya/data/models/assistant/assistant_conversation.dart';
import 'package:get/get.dart';

class AssistantHistoryPageVctl extends GetxController {
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
}
