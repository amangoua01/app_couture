import 'dart:convert';

import 'package:app_couture/api/abstract/web_controller.dart';
import 'package:app_couture/data/dto/user_register_dto.dart';
import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/tools/components/session_manager_view_controller.dart';
import 'package:app_couture/tools/extensions/types/map.dart';
import 'package:app_couture/tools/models/data_response.dart';

class AuthApi extends WebController {
  @override
  String get module => "auth";

  Future<DataResponse<User>> login(
      {required String login, required String password}) async {
    final response = await client.post(
      urlBuilder(module: "", api: "login"),
      headers: headers,
      body: {"login": login, "password": password}.parseToJson(),
    );

    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = json["data"];
      final user = User.fromJson(data["user"]);
      final token = data["token"] as String;

      SessionManagerViewController.jwt = token;

      return DataResponse<User>.success(data: user);
    } else {
      return DataResponse<User>.error(message: json["error"]);
    }
  }

  Future<DataResponse<User>> register(UserRegisterDto user) async {
    try {
      final response = await client.post(
        urlBuilder(api: "create", module: 'user'),
        headers: headers,
        body: user.toJson().parseToJson(),
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final user = User().fromJson(json["data"]);
        SessionManagerViewController.jwt = json["token"];
        return DataResponse.success(data: user);
      } else {
        return DataResponse.error(message: json["message"]);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, systemtraceError: st);
    }
  }

  Future<DataResponse<bool>> logout() async {
    try {
      final response = await client.post(
        urlBuilder(api: "logout"),
        headers: authHeaders,
      );

      if (response.statusCode == 200) {
        SessionManagerViewController.jwt = "";
        return DataResponse.success(data: true);
      } else {
        return DataResponse<bool>.error(
            message: "Logout failed with status code ${response.statusCode}");
      }
    } catch (e) {
      return DataResponse<bool>.error(message: "Logout failed: $e");
    }
  }

  Future<DataResponse<bool>> resetPassword(String email) async {
    try {
      final response = await client.post(
        urlBuilder(api: "reset-password"),
        headers: headers,
        body: {"email": email}.parseToJson(),
      );

      if (response.statusCode == 200) {
        return DataResponse<bool>.success(data: true);
      } else {
        return DataResponse<bool>.error(
            message:
                "Password reset failed with status code ${response.statusCode}");
      }
    } catch (e) {
      return DataResponse<bool>.error(message: "Password reset failed: $e");
    }
  }
}
