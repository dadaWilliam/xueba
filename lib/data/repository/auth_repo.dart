import 'package:flutter/widgets.dart';
import 'package:xueba/data/api/api_client.dart';
import 'package:xueba/models/sign_in_body.dart';

import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(SignInBody signInBody) async {
    // This will be sent as form data in the post requst
    // var map = new Map<String, dynamic>();
    // map['username'] = signInBody.username;
    // map['pwd'] = signInBody.pwd;
    String username = signInBody.username;
    String pwd = signInBody.pwd;
    String body = "username=$username&pwd=$pwd";
    //print(body);
    return await apiClient.postData("/api/auth/", body);
  }

  // Future<Response> getNotice(
  //   int code,
  //   // ignore: non_constant_identifier_names
  //   int user_id,
  // ) async {
  //   return await apiClient.getNotice("/api/notification/$code/$user_id");
  // }

  Future<Response> check() async {
    return await apiClient.check(
      "/api-check/",
    );
  }

  // ignore: non_constant_identifier_names

  Future saveUserToken(String token) async {
    apiClient.token = token;
    //print(token);
    //AppConstants.Token = token;
    //print(AppConstants.Token);
    return await sharedPreferences.setString("TOKEN", token);
  }

  Future saveUserUsed() async {
    // apiClient.token = token;
    //print(token);
    //AppConstants.Token = token;
    //print(AppConstants.Token);
    return await sharedPreferences.setString("USED", 'YES');
  }

  Future saveUserID(
    int id,
  ) async {
    debugPrint(id.toString());

    return await sharedPreferences.setInt("USER_ID", id);
  }

  Future saveUserName(String name) async {
    return await sharedPreferences.setString("USER_NAME", name);
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey("TOKEN");
  }

  bool userUsed() {
    return sharedPreferences.containsKey("USED");
  }

  String getUserToken() {
    apiClient.token = sharedPreferences.getString("TOKEN") ?? "None";

    return apiClient.token;
  }

  int getUserId() {
    return sharedPreferences.getInt("USER_ID") ?? -1;
  }

  String getUserName() {
    return sharedPreferences.getString("USER_NAME") ?? '';
  }

  bool clearSharedData() {
    sharedPreferences.remove("TOKEN");
    sharedPreferences.remove("USER_ID");
    sharedPreferences.remove("USER_NAME");
    apiClient.token = '';

    return true;
  }
}
