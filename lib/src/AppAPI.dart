import 'package:kiilib_core/kiilib_core.dart';

abstract class AppAPI {
  Future<KiiUser> login(String identifier, String password);
  Future<KiiUser> loginAsAdmin(String clientId, String clientSecret);
  Future<KiiUser> signUp(Map<String, dynamic> userInfo, String password);
}
