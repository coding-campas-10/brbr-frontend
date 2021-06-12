import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> login(int userId) async {
  http.Response request = await http.post(
    Uri.parse('http://api.asdf.land/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, dynamic>{
        'user_id': userId,
      },
    ),
  );
  print(request.body);
  print(request.headers);

  if (request.statusCode == 200) {
    print('brbr 로그인 성공!');
  }
}

Future<void> register(int userId, String nickname) async {
  http.Response request = await http.post(
    Uri.parse('http://api.asdf.land/auth/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, dynamic>{
        'user_id': userId,
        'name': nickname,
        'connected_at': DateTime.now().toString(),
      },
    ),
  );
  print(request.body);
  print(request.headers);

  if (request.statusCode == 200) {
    print('brbr 회원가입 성공!');
  }
}

Future<void> main() async {
  await login(1234);
  // await register(1234, '테스트');

  // String url = 'http://api.asdf.land';
  // var uri = Uri.parse(url);
  // print('${uri.host}:${uri.port}');
  // String hostname = Requests.getHostname(url);
  // print(hostname);
}
