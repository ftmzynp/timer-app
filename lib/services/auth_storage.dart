import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/models/user_model.dart';

class AuthStorage {
  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';
  static final _secure = const FlutterSecureStorage();

  // TOKEN
  static Future<void> saveToken(String token) => _secure.write(key: _kToken, value: token);
  static Future<String?> getToken() => _secure.read(key: _kToken);
  static Future<void> clearToken() => _secure.delete(key: _kToken);

  // USER (SharedPreferences yeterli)
  static Future<void> saveUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUser, jsonEncode(user.toJson()));
  }

  static Future<AppUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUser);
    if (raw == null) return null;
    return AppUser.fromJson(jsonDecode(raw));
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUser);
  }

  static Future<void> clearAll() async {
    await clearToken();
    await clearUser();
  }
}