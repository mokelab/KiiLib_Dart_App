import 'package:kiilib_app/kiilib_app.dart';
import 'package:kiilib_core/kiilib_core.dart';
import 'dart:convert';

class AppAPIImpl extends AppAPI {
  final KiiContext context;

  AppAPIImpl(this.context);

  @override
  Future<KiiUser> login(String identifier, String password) {
    var body = {
      "username": identifier,
      "password": password,
    };
    return this._execLogin(body);
  }

  @override
  Future<KiiUser> loginAsAdmin(String clientId, String clientSecret) {
    var body = {
      "client_id": clientId,
      "client_secret": clientSecret,
    };
    return this._execLogin(body);
  }

  @override
  Future<KiiUser> signUp(Map<String, dynamic> userInfo, String password) async {
    userInfo["password"] = password;

    var url = "${this.context.baseURL}/apps/${this.context.appID}/users";
    var headers = {"Content-Type": "application/json"};

    var response =
        await this.context.client.sendJson(Method.POST, url, headers, userInfo);
    if (response.status != 201) {
      print(response.body);
      throw Exception("Error");
    }

    var bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
    var userID = bodyJson["userID"] as String;
    return KiiUser(userID);
  }

  Future<KiiUser> _execLogin(Map<String, dynamic> body) async {
    var url = "${this.context.baseURL}/oauth2/token";
    var headers = {"Content-Type": "application/json"};

    var response =
        await this.context.client.sendJson(Method.POST, url, headers, body);
    if (response.status != 200) {
      throw Exception("Error");
    }

    var bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
    var token = bodyJson["access_token"] as String;
    var userID = bodyJson["id"] as String;
    // set acccess token
    this.context.token = token;
    return KiiUser(userID);
  }
}
