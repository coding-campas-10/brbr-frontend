import 'package:brbr/pages/wrapper.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '로그인',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '아이디',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '아이디를 입력하세요';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '비밀번호',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력하세요';
                            }
                            return null;
                          },
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BRBRWrapper(),
                                ),
                              );
                            }
                          },
                          child: Text('로그인'),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          height: 56,
                          color: Color.fromRGBO(0, 227, 147, 1),
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      print('아이디 찾기');
                    },
                    child: Text('아이디 찾기'),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('비밀번호 재발급');
                    },
                    child: Text('비밀번호 재발급'),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('회원가입');
                    },
                    child: Text('회원가입'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
