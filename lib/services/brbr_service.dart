import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:brbr/constants/kakao_app_key.dart';
import 'package:brbr/models/brbr_receipt.dart';
import 'package:brbr/models/brbr_station.dart';
import 'package:brbr/models/brbr_user.dart';
import 'package:brbr/pages/announce.dart';
import 'package:brbr/pages/barcode.dart';
import 'package:brbr/services/requests/requests.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';

class NoSuchUserException implements Exception {
  String message;
  KakaoAccountResult kakaoUser;
  NoSuchUserException(this.message, this.kakaoUser);
}

class BRBRService {
  static final FlutterKakaoLogin _kakaoAuth = FlutterKakaoLogin();
  static AsyncMemoizer _initMemo = AsyncMemoizer();
  static bool _isInintialized = false;
  BRBRService._();

  static Future<void> _init() async {
    await _initMemo.runOnce(
      () async {
        await _kakaoAuth.init(kakaoNativeAppkey);
        _isInintialized = true;
      },
    );
  }

  static String get _hostname {
    String url = 'http://api.asdf.land';
    return Requests.getHostname(url);
  }

  static Future<bool> isLoggedIn() async {
    Map<String, String> cookies = await Requests.getStoredCookies(_hostname);
    return cookies['connect.sid'] != null;
  }

  static Future<Response> register(int userId, String name) async {
    Response response = await Requests.post(
      'http://api.asdf.land/auth/register',
      json: jsonEncode(
        <String, dynamic>{
          'user_id': userId,
          'name': name,
          'connected_at': DateTime.now().toString(),
        },
      ),
    );
    print('BRBR서버에 /auth/register 요청');
    return response;
  }

  static Future<Response> logout() async {
    Response response = await Requests.get('http://api.asdf.land/auth/logout');
    print('BRBR서버에 /auth/logout 요청');
    Requests.clearStoredCookies(_hostname);
    if (response.statusCode == 204) {
      print('로그아웃 됨');
    }
    return response;
  }

  static Future<BRBRUser?> login() async {
    KakaoAccountResult? kakaoResult = await _loginWithKakao();
    if (kakaoResult != null) {
      print('${kakaoResult.userID} 카카오 로그인 성공');
      Response brbrLoginResponse = await _brbrLogin(int.parse(kakaoResult.userID!));
      if (brbrLoginResponse.statusCode == 200) {
        BRBRUser user = BRBRUser.fromJson(brbrLoginResponse.content());
        print('${user.name} 버려버려 로그인 성공');
        return user;
      } else if (brbrLoginResponse.statusCode == 401) {
        Requests.clearStoredCookies(_hostname);
        throw NoSuchUserException(brbrLoginResponse.content(), kakaoResult);
      }
    }
  }

  static Future<Response> leave() async {
    Response response = await Requests.delete('http://api.asdf.land/auth/leave');
    print('BRBR서버에 /auth/leave 요청');
    if (response.statusCode == 204) {
      print('회훤 탈퇴 성공');
      Requests.clearStoredCookies(_hostname);
    }
    return response;
  }

  static Future<Response> _brbrLogin(int userId) async {
    Response response = await Requests.post(
      'http://api.asdf.land/auth/login',
      json: jsonEncode(
        <String, dynamic>{
          'user_id': userId,
        },
      ),
    );
    print('BRBR서버에 /auth/login 요청');
    return response;
  }

  static Future<KakaoAccountResult?> _loginWithKakao() async {
    if (!_isInintialized) {
      await _init();
    }
    await _kakaoAuth.logIn();
    return (await _kakaoAuth.getUserMe()).account;
  }

  static Future<BRBRUser?> getUserInfo() async {
    Response response = await Requests.get('http://api.asdf.land/auth/info');
    print('BRBR서버에 /auth/info 요청');
    if (response.statusCode == 200) {
      BRBRUser user = BRBRUser.fromJson(response.content());
      print('${user.name}의 정보를 받아옴');
      return user;
    } else {
      Requests.clearStoredCookies(_hostname);
    }
  }

  static Future<BRBRBarcode?> getBarcodeOTP() async {
    Response response = await Requests.get('http://api.asdf.land/otp');
    print('BRBR서버에 /otp 요청');
    if (response.statusCode == 200) {
      BRBRBarcode barcode = BRBRBarcode.fromJson(response.content());
      print('바코드를 성공적으로 불러옴(OTP : ${barcode.otp})');
      return barcode;
    }
  }

  static Future<List<BRBRAnnounce>?> getAnnounce() async {
    Response response = await Requests.get('http://api.asdf.land/announce/all');
    print('BRBR서버에 /announce/all 요청');
    if (response.statusCode == 200) {
      List<dynamic> datas = jsonDecode(response.content())['announce'];
      List<BRBRAnnounce> announces = datas.map((e) => BRBRAnnounce.fromMap(e as Map<String, dynamic>)).toList();
      print('공지를 성공적으로 불러옴');
      return announces;
    }
  }

  static Future<List<BRBRReceipt>?> getAllReceipt() async {
    Response response = await Requests.get('http://api.asdf.land/wallet');
    print('BRBR서버에 wallet/wallet 요청');
    if (response.statusCode == 200) {
      List datas = jsonDecode(response.content());
      List<BRBRReceipt> receipts = datas.map((e) => BRBRReceipt.fromMap(e)).toList();
      print('사용 내역을 성공적으로 불러옴');
      return receipts;
    }
  }

  static Future<Response> getMostVisitedStation() async {
    Response response = await Requests.get('http://api.asdf.land/wallet/most-visited');
    print('BRBR서버에 /most-visited 요청');
    if (response.statusCode == 200) {
      print('가장 많이 방문한 스테이션을 성공적으로 불러옴');
    }
    return response;
  }

  static Future<List<StationLocation>?> getAllStations() async {
    Response response = await Requests.get('http://api.asdf.land/stations');
    print('BRBR서버에 stations 요청');
    if (response.statusCode == 200) {
      List datats = jsonDecode(response.content())['stations'];
      List<StationLocation> stationLocations = datats.map((e) => StationLocation.fromMap(e)).toList();
      print('모든 스테이션의 위치를 성공적으로 불러옴');
      return stationLocations;
    }
  }

  static Future<Station?> getDetailStation(int stationId) async {
    Response response = await Requests.get('http://api.asdf.land/stations/$stationId');
    print('BRBR서버에 stations/$stationId 요청');
    if (response.statusCode == 200) {
      print('id $stationId번의 스테이션 정보를 성공적으로 불러옴');
      return Station.fromMap(jsonDecode(response.content()));
    }
  }

  static Future<Station?> getNearestStation(double lon, double lat) async {
    Response response = await Requests.post(
      'http://api.asdf.land/stations/near',
      json: jsonEncode(
        <String, dynamic>{
          "location": {
            "lat": lat,
            "lng": lon,
          }
        },
      ),
    );
    print('BRBR서버에 stations/near 요청');
    if (response.statusCode == 200) {
      print('가장 가까운 스테이션을 성공적으로 불러옴');
      return Station.fromMap(jsonDecode(response.content()));
    }
  }
}
