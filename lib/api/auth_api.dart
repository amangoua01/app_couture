import 'dart:convert';

import 'package:app_couture/api/abstract/web_controller.dart';
import 'package:app_couture/data/models/user.dart';
import 'package:app_couture/tools/components/session_manager_view_controller.dart';
import 'package:app_couture/tools/extensions/types/map.dart';
import 'package:app_couture/tools/models/data_response.dart';

class AuthApi extends WebController {
  @override
  String get module => "auth";

  @override
  Future<DataResponse<User>> login(
      {required String email, required String password}) async {
    final response = await client.post(
      urlBuilder(api: "login"),
      headers: headers,
      body: {"email": email, "password": password}.parseToJson(),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final user = User().fromJson(json["user"]);
      final token = json["token"] as String;

      SessionManagerViewController.jwt = token;

      return DataResponse<User>.success(data: user);
    } else {
      return DataResponse<User>.error(
          message: "Login failed with status code ${response.statusCode}");
    }
  }

  Future<DataResponse<User>> register(
    User user,
    String password,
  ) async {
    try {
      final response = await client.post(
        urlBuilder(api: "register"),
        headers: headers,
        body: user.toJson().parseToJson(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final user = User().fromJson(json["user"]);
        final token = json["token"] as String;

        SessionManagerViewController.jwt = token;

        return DataResponse<User>.success(data: user);
      } else {
        return DataResponse<User>.error(
            message:
                "Registration failed with status code ${response.statusCode}");
      }
    } catch (e) {
      return DataResponse<User>.error(message: "Registration failed: $e");
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
