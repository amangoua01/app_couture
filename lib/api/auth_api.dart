import 'dart:convert';
import 'dart:io';

import 'package:ateliya/api/abstract/web_controller.dart';
import 'package:ateliya/data/dto/update_profil_dto.dart';
import 'package:ateliya/data/dto/user_register_dto.dart';
import 'package:ateliya/data/models/user.dart';
import 'package:ateliya/tools/components/session_manager_view_controller.dart';
import 'package:ateliya/tools/extensions/types/map.dart';
import 'package:ateliya/tools/models/data_response.dart';

class AuthApi extends WebController {
  @override
  String get module => "auth";

  Future<DataResponse<User>> login(
      {required String login, required String password}) async {
    final response = await client.post(
      urlBuilder(module: "", api: "login"),
      headers: headers,
      body: {
        "login": login,
        "password": password,
        "device": Platform.operatingSystem,
      }.parseToJson(),
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
        final data = json["data"];
        final user = User.fromJson(data["user"]);
        SessionManagerViewController.jwt = data["token"];
        return DataResponse.success(data: user);
      } else {
        return DataResponse.error(message: json["message"]);
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<bool>> logout() async {
    try {
      final response = await client.post(
        urlBuilder(api: "logout", module: ''),
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

  Future<DataResponse<bool>> initResetPassword(String email) async {
    try {
      final response = await client.post(
        urlBuilder(api: "reset-password/request", module: ''),
        headers: headers,
        body: {"email": email}.parseToJson(),
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return DataResponse.success(data: true);
      } else {
        return DataResponse.error(message: json["message"] ?? "Unknown error");
      }
    } catch (e, st) {
      return DataResponse<bool>.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<bool>> checkOTPResetPassword(
      {required String email, required String otp}) async {
    try {
      final response = await client.post(
        urlBuilder(api: "reset-password/verify-token-expired", module: ''),
        headers: headers,
        body: {"email": email, "token": otp}.parseToJson(),
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        bool expired = json['expired'];
        if (!expired) {
          return DataResponse.success(data: true);
        } else {
          return DataResponse.error(message: "Le code OTP a expiré.");
        }
      } else {
        return DataResponse.error(message: json["message"] ?? "Unknown error");
      }
    } catch (e, st) {
      return DataResponse<bool>.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<bool>> finalizeResetPassword(
      {required String email,
      required String otp,
      required String newPassword}) async {
    try {
      final response = await client.post(
        urlBuilder(api: "reset-password/reset", module: ''),
        headers: headers,
        body: {
          "email": email,
          "token": otp,
          "newPassword": newPassword,
        }.parseToJson(),
      );
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return DataResponse.success(data: true);
      } else {
        return DataResponse.error(message: json["message"] ?? "Unknown error");
      }
    } catch (e, st) {
      return DataResponse.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<User>> updateProfile(UpdateProfilDto data) async {
    try {
      final response = await client.post(
        urlBuilder(api: "update/profil/${data.id}", module: 'user'),
        body: data.toJson().parseToJson(),
        headers: authHeaders,
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final user = User.fromJson(json["data"]);
        return DataResponse<User>.success(data: user);
      } else {
        return DataResponse<User>.error(message: json["message"]);
      }
    } catch (e, st) {
      return DataResponse<User>.error(systemError: e, stackTrace: st);
    }
  }

  Future<DataResponse<int>> updateFcmToken(
      {required String fcmToken, required String login}) async {
    try {
      final response = await client.post(
        urlBuilder(api: "device-token", module: ""),
        body: {"login": login, "token": fcmToken}.parseToJson(),
        headers: authHeaders,
      );

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return DataResponse<int>.success(data: json["user_id"]);
      } else {
        return DataResponse<int>.error(message: json["message"]);
      }
    } catch (e, st) {
      return DataResponse<int>.error(systemError: e, stackTrace: st);
    }
  }
}
