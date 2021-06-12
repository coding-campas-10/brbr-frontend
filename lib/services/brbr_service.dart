import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:brbr/constants/kakao_app_key.dart';
// import 'package:brbr/models/brbr_receipt.dart';
import 'package:brbr/models/brbr_user.dart';
import 'package:brbr/pages/announce.dart';
import 'package:brbr/pages/barcode.dart';
import 'package:brbr/services/requests/requests.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';

// enum LoginStatus { loggedIn, loggedOut }

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
      print('로그아웃');
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

  // static Future<List<BRBRReceipt>?> getAllReceipt() async {
  //   Response response = await Requests.get('http://api.asdf.land/wallet/wallet');
  //   print('BRBR서버에 wallet/wallet 요청');
  //   if (response.statusCode == 200) {
  //     List<dynamic> datas = jsonDecode(response.content());
  //     List<BRBRReceipt> receipts = datas.map((e) => BRBRReceipt.fromMap(e as Map<String, dynamic>)).toList();
  //     print('사용 내역을 성공적으로 불러옴');
  //     return receipts;
  //   }
  // }

  static Future<Response> getMostVisitedStation() async {
    Response response = await Requests.get('http://api.asdf.land/wallet/most-visited');
    print('BRBR서버에 /most-visited 요청');
    if (response.statusCode == 200) {
      print('가장 많이 방문한 스테이션을 성공적으로 불러옴');
    }
    return response;
  }
}

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   static final FlutterKakaoLogin kakaoSignIn = FlutterKakaoLogin();

//   String _loginMessage = 'Current Not Logined :(';
//   String _accessToken = '';
//   String _refreshToken = '';
//   String _accountInfo = '';
//   bool _isLogined = false;

//   final List<Map<String, String>> _listItems = [
//     {'key': 'login', 'title': 'Login', 'subtitle': ''},
//     {'key': 'logout', 'title': 'Logout', 'subtitle': ''},
//     {'key': 'unlink', 'title': 'Unlink', 'subtitle': ''},
//     {'key': 'account', 'title': 'Get AccountInfo', 'subtitle': ''},
//     {'key': 'accessToken', 'title': 'Get AccessToken', 'subtitle': ''},
//     {'key': 'refreshToken', 'title': 'Get RefreshToken', 'subtitle': ''}
//   ];

//   @override
//   void initState() {
//     super.initState();
//     load();
//   }

//   void load() async {
//     // Kakao SDK Init (Set NATIVE_APP_KEY)
//     await kakaoSignIn.init('b8b366d2aa75c7f76654feecc21473e9');

//     // For Android
//     final hashKey = await kakaoSignIn.hashKey;
//     print('hashKey: $hashKey');
//   }

//   Future<Null> _login() async {
//     try {
//       final result = await kakaoSignIn.logIn();
//       _processLoginResult(result);
//     } on PlatformException catch (e) {
//       _updateLoginMessage('${e.code} ${e.message}');
//     }
//   }

//   Future<Null> _logOut() async {
//     try {
//       final result = await kakaoSignIn.logOut();
//       _processLoginResult(result);
//       _processAccountResult(null);
//     } on PlatformException catch (e) {
//       _updateLoginMessage('${e.code} ${e.message}');
//     }
//   }

//   Future<Null> _unlink() async {
//     try {
//       final result = await kakaoSignIn.unlink();
//       _processLoginResult(result);
//     } on PlatformException catch (e) {
//       _updateLoginMessage('${e.code} ${e.message}');
//     }
//   }

//   Future<Null> _getAccountInfo() async {
//     try {
//       final result = await kakaoSignIn.getUserMe();
//       final account = result.account;
//       _processAccountResult(account);
//     } on PlatformException catch (e) {
//       _updateLoginMessage('${e.code} ${e.message}');
//     }
//   }

//   Future<Null> _getAccessToken() async {
//     final token = await kakaoSignIn.currentToken;
//     final accessToken = token?.accessToken;
//     if (accessToken != null) {
//       _updateAccessToken('AccessToken\n' + accessToken);
//     } else {
//       _updateAccessToken('');
//     }
//   }

//   Future<Null> _getRefreshToken() async {
//     final token = await kakaoSignIn.currentToken;
//     final refreshToken = token?.refreshToken;
//     if (refreshToken != null) {
//       _updateRefreshToken('RefreshToken\n' + refreshToken);
//     } else {
//       _updateRefreshToken('');
//     }
//   }

//   void _updateLoginMessage(String message) {
//     setState(() {
//       _loginMessage = message;
//     });
//   }

//   void _updateStateLogin(bool logined) {
//     setState(() {
//       _isLogined = logined;
//     });
//     if (!logined) {
//       _updateAccessToken('');
//       _updateRefreshToken('');
//       _updateAccountMessage('');
//     }
//   }

//   void _updateAccessToken(String accessToken) {
//     setState(() {
//       _accessToken = accessToken;
//     });
//   }

//   void _updateRefreshToken(String refreshToken) {
//     setState(() {
//       _refreshToken = refreshToken;
//     });
//   }

//   void _updateAccountMessage(String message) {
//     setState(() {
//       _accountInfo = message;
//     });
//   }

//   void _processLoginResult(KakaoLoginResult result) {
//     switch (result.status) {
//       case KakaoLoginStatus.loggedIn:
//         _updateLoginMessage('LoggedIn by the user.');
//         _updateStateLogin(true);
//         break;
//       case KakaoLoginStatus.loggedOut:
//         _updateLoginMessage('LoggedOut by the user.');
//         _updateStateLogin(false);
//         break;
//       case KakaoLoginStatus.unlinked:
//         _updateLoginMessage('Unlinked by the user.');
//         _updateStateLogin(false);
//         break;
//     }
//   }

//   void _processAccountResult(KakaoAccountResult account) {
//     if (account == null) {
//       _updateAccountMessage('');
//     } else {
//       final userID = (account.userID == null) ? 'None' : account.userID;
//       final userEmail = (account.userEmail == null) ? 'None' : account.userEmail;
//       final userPhoneNumber = (account.userPhoneNumber == null) ? 'None' : account.userPhoneNumber;
//       final userDisplayID = (account.userDisplayID == null) ? 'None' : account.userDisplayID;
//       final userNickname = (account.userNickname == null) ? 'None' : account.userNickname;
//       final userGender = (account.userGender == null) ? 'None' : account.userGender;
//       final userAgeRange = (account.userAgeRange == null) ? 'None' : account.userAgeRange;
//       final userBirthyear = (account.userBirthyear == null) ? 'None' : account.userBirthyear;
//       final userBirthday = (account.userBirthday == null) ? 'None' : account.userBirthday;
//       final userProfileImagePath = (account.userProfileImagePath == null) ? 'None' : account.userProfileImagePath;
//       final userThumbnailImagePath = (account.userThumbnailImagePath == null) ? 'None' : account.userThumbnailImagePath;

//       _updateAccountMessage('- ID is $userID\n'
//           '- Email is $userEmail\n'
//           '- PhoneNumber is $userPhoneNumber\n'
//           '- DisplayID is $userDisplayID\n'
//           '- Nickname is $userNickname\n'
//           '- Gender is $userGender\n'
//           '- Age is $userAgeRange\n'
//           '- Birthyear is $userBirthyear\n'
//           '- Birthday is $userBirthday\n'
//           '- ProfileImagePath is $userProfileImagePath\n'
//           '- ThumbnailImagePath is $userThumbnailImagePath');
//     }
//   }

//   void _showAlert(BuildContext context, String value) {
//     if (value.isEmpty) return;

//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: Text('OK'),
//               )
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Kakao Login Plugin app'),
//       ),
//       body: SafeArea(
//         child: ListView.builder(
//           itemCount: _listItems.length + 1,
//           itemBuilder: (BuildContext context, int index) {
//             if (index == 0) {
//               return KakaoInfo(
//                 loginMessage: _loginMessage,
//                 accessToken: _accessToken,
//                 refreshToken: _refreshToken,
//                 accountInfo: _accountInfo,
//               );
//             }

//             final actionIndex = index - 1;
//             final title = _listItems[actionIndex]['title'] ?? '';
//             final subtitle = _listItems[actionIndex]['subtitle'] ?? '';
//             final key = _listItems[actionIndex]['key'];

//             return ListTile(
//               title: Text(title),
//               subtitle: Text(subtitle),
//               onTap: () {
//                 switch (key) {
//                   case 'login':
//                     if (!_isLogined) {
//                       _login();
//                     }
//                     break;
//                   case 'logout':
//                     if (_isLogined) {
//                       _logOut();
//                     }
//                     break;
//                   case 'unlink':
//                     if (_isLogined) {
//                       _unlink();
//                     }
//                     break;
//                   case 'account':
//                     if (!_isLogined) {
//                       _showAlert(context, 'Login is required.');
//                     } else {
//                       _getAccountInfo();
//                     }
//                     break;
//                   case 'accessToken':
//                     if (!_isLogined) {
//                       _showAlert(context, 'Login is required.');
//                     } else {
//                       _getAccessToken();
//                     }
//                     break;
//                   case 'refreshToken':
//                     if (!_isLogined) {
//                       _showAlert(context, 'Login is required.');
//                     } else {
//                       _getRefreshToken();
//                     }
//                     break;
//                 }
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// /////////////////////////////////////////////////////////////////////////////
// class KakaoInfo extends StatelessWidget {
//   final String loginMessage;
//   final String accessToken;
//   final String refreshToken;
//   final String accountInfo;

//   KakaoInfo({
//     this.loginMessage = '',
//     this.accessToken = '',
//     this.refreshToken = '',
//     this.accountInfo = '',
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(18, 25, 18, 25),
//       color: Colors.grey[300],
//       child: Column(
//         children: [
//           Text(loginMessage),
//           accountInfo != '' ? SizedBox(height: 25) : Container(),
//           accountInfo != '' ? Text(accountInfo) : Container(),
//           accessToken != '' ? SizedBox(height: 10) : Container(),
//           accessToken != '' ? Text(accessToken) : Container(),
//           refreshToken != '' ? SizedBox(height: 10) : Container(),
//           refreshToken != '' ? Text(refreshToken) : Container(),
//         ],
//       ),
//     );
//   }
// }
