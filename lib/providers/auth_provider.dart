import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  bool isLoading = true;

  final String storageKey = "auth";

  // LOGIN
  Future<void> login(Map<String, dynamic> data) async {
    UserModel userData = mapLoginResponse(data);

    _user = userData;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(storageKey, jsonEncode(userData.toJson()));

    notifyListeners();
  }

  // LOGOUT

  Future<void> logout() async {
    _user = null;

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(storageKey);

    notifyListeners();
  }

  // recuperar sesión al abrir app

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    String? stored = prefs.getString(storageKey);

    if (stored != null) {
      final json = jsonDecode(stored);

      String? token = json["token"];

      if (token != null && JwtDecoder.isExpired(token)) {
        await logout();
      } else {
        _user = UserModel.fromJson(json);
      }
    }

    isLoading = false;

    notifyListeners();
  }

  UserModel mapLoginResponse(Map<String, dynamic> data) {
  var rawRole;
 
  if (data["roles"] is List) {
    rawRole = data["roles"][0];
  } else {
    rawRole = data["roles"];
  }
 
  return UserModel(
    id:       data["id"]      ?? "",
    username: data["correo"]  ?? "", // el backend manda "correo"
    nombre:   data["nombre"]  ?? "",
    apellido: data["apellido"],      // ← nuevo campo
    token:    data["token"],
    role:     normalizeRole(rawRole),
    mustChangePassword: data["mustChangePassword"] ?? false,
  );
}
 

  String? normalizeRole(dynamic raw) {
    if (raw == null) return null;

    String value = "";

    if (raw is String) {
      value = raw;
    } else if (raw is Map) {
      value = raw["nombre"] ?? "";
    }

    Map roles = {
      "ROL_CLIENTE": "cliente",

      "ROL_RESTAURANTE": "restaurante",

      "ROL_CHEF": "chef",

      "ROL_MESERO": "mesero",

      "ROL_ADMIN": "admin",
    };

    if (roles[value] != null) {
      return roles[value];
    }

    return value.toLowerCase();
  }
}
