import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:hex/hex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class Common {
  const Common();
  static late SharedPreferences _sharedPreferences;
  static AsyncMemoizer _initMemo = AsyncMemoizer();
  static bool _isInitialized = false;

  static Future<void> _init() async {
    await _initMemo.runOnce(
      () async {
        _sharedPreferences = await SharedPreferences.getInstance();
        _isInitialized = true;
      },
    );
  }

  static Future<void> storageSet(String key, String value) async {
    if (!_isInitialized) {
      await _init();
    }
    await _sharedPreferences.setString(key, value);
  }

  static Future<String?> storageGet(String key) async {
    if (!_isInitialized) {
      await _init();
    }
    return _sharedPreferences.getString(key);
  }

  static Future<bool> storageRemove(String key) async {
    if (!_isInitialized) {
      await _init();
    }
    return await _sharedPreferences.remove(key);
  }

  static bool equalsIgnoreCase(String? string1, String? string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  static String toJson(dynamic object) {
    var encoder = JsonEncoder.withIndent('     ');
    return encoder.convert(object);
  }

  static dynamic fromJson(String? jsonString) {
    if (jsonString == null) {
      return null;
    }
    return json.decode(jsonString);
  }

  static bool hasKeyIgnoreCase(Map map, String key) {
    return map.keys.any((x) => equalsIgnoreCase(x, key));
  }

  static String toHexString(List<int> data) {
    return HEX.encode(data);
  }

  static List fromHexString(String hexString) {
    return HEX.decode(hexString);
  }

  static String hashStringSHA256(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return toHexString(digest.bytes);
  }

  static String encodeMap(Map data) {
    return data.keys.map((key) {
      var k = Uri.encodeComponent(key.toString());
      var v = Uri.encodeComponent(data[key].toString());
      return '$k=$v';
    }).join('&');
  }

  static List<String> split(String string, String separator, {int max = 0}) {
    var result = <String>[];

    if (separator.isEmpty) {
      result.add(string);
      return result;
    }

    while (true) {
      var index = string.indexOf(separator, 0);
      if (index == -1 || (max > 0 && result.length >= max)) {
        result.add(string);
        break;
      }

      result.add(string.substring(0, index));
      string = string.substring(index + separator.length);
    }

    return result;
  }
}
