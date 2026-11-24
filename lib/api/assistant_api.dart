import 'dart:async';
import 'dart:convert';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/models/assistant/assistant_balance.dart';
import 'package:ateliya/data/models/assistant/assistant_conversation.dart';
import 'package:ateliya/data/models/assistant/assistant_message.dart';
import 'package:ateliya/data/models/assistant/token_pack.dart';
import 'package:ateliya/tools/models/data_response.dart';
import 'package:http/http.dart' as http;

/// Réponse de Sika à un message.
class AssistantReply {
  final int conversationId;
  final AssistantMessage message;
  final int soldeForfait;
  final int soldePacks;

  const AssistantReply({
    required this.conversationId,
    required this.message,
    required this.soldeForfait,
    required this.soldePacks,
  });
}

class AssistantApi extends WebController {
  @override
  String get module => "assistant";

  /// Une réponse de l'IA peut prendre plusieurs secondes (appel des outils
  /// puis génération) : on laisse de la marge avant d'abandonner.
  static const _chatTimeout = Duration(seconds: 90);
  static const _timeout = Duration(seconds: 20);

  Future<DataResponse<AssistantBalance>> balance() {
    return _call(
      () => client.get(urlBuilder(api: "balance"), headers: authHeaders),
      (data) => AssistantBalance.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<DataResponse<AssistantReply>> chat({
    required String message,
    int? conversationId,
  }) {
    return _call(
      () => client.post(
        urlBuilder(api: "chat"),
        headers: authHeaders,
        body: jsonEncode({
          "message": message,
          if (conversationId != null) "conversationId": conversationId,
        }),
      ),
      (data) {
        final json = data as Map<String, dynamic>;
        final solde = json['solde'] as Map<String, dynamic>? ?? const {};
        return AssistantReply(
          conversationId: json['conversationId'] as int,
          message: AssistantMessage(
            id: (json['message']['id'] as num?)?.toInt(),
            fromUser: false,
            contenu: json['message']['contenu'].toString(),
            tokensConsommes:
                (json['message']['tokensConsommes'] as num?)?.toInt() ?? 0,
            outils: ((json['message']['outils'] as List?) ?? const [])
                .map((e) => e.toString())
                .toList(),
            meta: json['meta'] is Map<String, dynamic>
                ? AssistantMeta.fromJson(json['meta'] as Map<String, dynamic>)
                : null,
          ),
          soldeForfait: (solde['forfait'] as num?)?.toInt() ?? 0,
          soldePacks: (solde['packs'] as num?)?.toInt() ?? 0,
        );
      },
      timeout: _chatTimeout,
    );
  }

  Future<DataResponse<List<AssistantConversation>>> conversations() {
    return _call(
      () => client.get(urlBuilder(api: "conversations"), headers: authHeaders),
      (data) => (data as List)
          .map((e) => AssistantConversation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<DataResponse<AssistantConversation>> renameConversation(int id, String titre) {
    return _call(
      () => client.patch(
        urlBuilder(api: "conversations/$id"),
        headers: authHeaders,
        body: jsonEncode({"titre": titre}),
      ),
      (data) => AssistantConversation.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<DataResponse<bool>> deleteConversation(int id) {
    return _call(
      () => client.delete(urlBuilder(api: "conversations/$id"), headers: authHeaders),
      (_) => true,
    );
  }

  Future<DataResponse<List<AssistantMessage>>> messages(int conversationId) {
    return _call(
      () => client.get(
        urlBuilder(api: "conversations/$conversationId/messages"),
        headers: authHeaders,
      ),
      (data) => (data as List)
          .map((e) => AssistantMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<DataResponse<List<TokenPack>>> packs() {
    return _call(
      () => client.get(urlBuilder(api: "packs"), headers: authHeaders),
      (data) => (data as List)
          .map((e) => TokenPack.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<DataResponse<TokenPurchase>> purchase({
    required int packId,
    required int operateurId,
    required String email,
    required String numero,
  }) {
    return _call(
      () => client.post(
        urlBuilder(api: "packs/$packId/purchase"),
        headers: authHeaders,
        body: jsonEncode({
          "operateur": operateurId,
          "email": email,
          "numero": numero,
          "returnURL": "https://redirectionurl.ateliya.com",
        }),
      ),
      (data) => TokenPurchase.fromJson(data as Map<String, dynamic>),
    );
  }

  /// État d'un achat : `pending`, `success` ou `failed`.
  Future<DataResponse<String>> purchaseStatus(String reference) {
    return _call(
      () => client.get(
        urlBuilder(api: "purchases/$reference"),
        headers: authHeaders,
      ),
      (data) => (data as Map<String, dynamic>)['status'].toString(),
    );
  }

  static dynamic _tryDecode(String raw) {
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }

  /// Envoie la requête, lit l'enveloppe `{success, data, message}` de l'API et
  /// garde le code HTTP dans l'erreur pour que l'écran sache quoi proposer.
  Future<DataResponse<T>> _call<T>(
    Future<http.Response> Function() send,
    T Function(dynamic data) parse, {
    Duration timeout = _timeout,
  }) async {
    try {
      final res = await send().timeout(timeout);
      final body = _tryDecode(res.body);
      // 404 sans l'enveloppe de notre API : le serveur n'a pas (encore) les
      // routes de l'assistant. (Un 404 de notre API porte toujours « success ».)
      if (res.statusCode == 404 && !(body is Map && body.containsKey('success'))) {
        return DataResponse.error(
          message: "L'assistant n'est pas encore disponible sur ce serveur.",
          statusCode: 404,
        );
      }
      if (res.statusCode >= 200 && res.statusCode < 300 &&
          body is Map && body['success'] == true) {
        return DataResponse.success(data: parse(body['data']));
      }
      return DataResponse.error(
        message: (body is Map ? body['message'] : null)?.toString() ??
            "Désolé, une erreur est survenue. Veuillez réessayer SVP.",
        statusCode: res.statusCode,
      );
    } on TimeoutException {
      return DataResponse.error(
        message: "La réponse prend trop de temps. Vérifiez votre connexion et réessayez.",
        statusCode: 408,
      );
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }
}
