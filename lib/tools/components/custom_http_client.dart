import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CustomHttpClient extends http.BaseClient {
  final http.Client _inner;

  CustomHttpClient({http.Client? inner}) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (kDebugMode) {
      // Logs de l'URL, des headers et du body
      print("🚀 Method: ${request.method}");
      print("🌍 URL: ${request.url}");
      print("🔼 Headers: ${request.headers}");

      if (request is http.Request) {
        print("📦 Body: ${request.body}");
      }
    }

    // Envoyer la requête
    final response = await _inner.send(request);

    // Lire et afficher la réponse
    final responseBody = await response.stream.bytesToString();

    if (kDebugMode) {
      print("⬇️ Status: ${response.statusCode}");
      print("📥 Response: $responseBody");
    }

    // Retourner la réponse avec le body recréé
    return http.StreamedResponse(
      Stream.value(utf8.encode(responseBody)),
      response.statusCode,
      headers: response.headers,
    );
  }

  Future<http.Response> multiPart(
    Uri url, {
    Map<String, String> body = const {},
    Map<String, String> headers = const {},
    List<http.MultipartFile> files = const [],
  }) async {
    return _sendMultipart('POST', url, body: body, headers: headers, files: files);
  }

  Future<http.Response> multiPartPut(
    Uri url, {
    Map<String, String> body = const {},
    Map<String, String> headers = const {},
    List<http.MultipartFile> files = const [],
  }) async {
    return _sendMultipart('PUT', url, body: body, headers: headers, files: files);
  }

  Future<http.Response> _sendMultipart(
    String method,
    Uri url, {
    Map<String, String> body = const {},
    Map<String, String> headers = const {},
    List<http.MultipartFile> files = const [],
  }) async {
    final request = http.MultipartRequest(method, url);
    if (body.isNotEmpty) request.fields.addAll(body);
    if (files.isNotEmpty) request.files.addAll(files);
    if (headers.isNotEmpty) request.headers.addAll(headers);
    final response = await _inner.send(request);
    if (kDebugMode) {
      print("🚀 Method: ${request.method}");
      print("🌍 URL: ${request.url}");
      print("🔼 Headers: ${request.headers}");
      print("📦 Body: $body");
      print("📁 Files: ${files.length}");
      for (int i = 0; i < files.length; i++) {
        print("📁 -> File #$i: ${files[i].field} | ${files[i].filename}");
      }
    }
    final res = await http.Response.fromStream(response);
    if (kDebugMode) {
      print("⬇️ Status: ${response.statusCode}");
      print("📥 Response: ${res.body}");
    }
    return res;
  }
}
