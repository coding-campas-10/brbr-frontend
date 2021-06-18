import 'dart:convert';
import 'package:brbr/services/brbr_service.dart';
import 'package:brbr/services/requests/requests.dart';
import 'package:flutter/material.dart';

class BRBRUser extends ChangeNotifier {
  int? _userId;
  String? _name;
  DateTime? _connectedAt;

  BRBRUser.config(int userId, String name, DateTime connectedAt) {
    _userId = userId;
    _name = name;
    _connectedAt = connectedAt;
  }

  BRBRUser.fromJson(String src) {
    Map<String, dynamic> srcMap = jsonDecode(src);
    _userId = srcMap['user_id'];
    _name = srcMap['name'];
    _connectedAt = DateTime.parse(srcMap['connected_at']);
  }

  BRBRUser();

  int? get userId => _userId;

  String? get name => _name;
  set name(String? name) {
    _name = name;
    notifyListeners();
  }

  DateTime? get connectedAt => _connectedAt;

  Future<void> login() async {
    BRBRUser? loginResult = await BRBRService.login();
    if (loginResult != null) {
      updateUserInfo(loginResult);
    }
  }

  Future<void> logout() async {
    await BRBRService.logout();
    updateUserInfo(BRBRUser());
  }

  Future<void> leave() async {
    Response response = await BRBRService.leave();
    if (response.statusCode == 204) {
      updateUserInfo(BRBRUser());
    }
  }

  void updateUserInfo(BRBRUser user) {
    _userId = user.userId;
    _name = user.name;
    _connectedAt = user.connectedAt;
    notifyListeners();
  }
}
