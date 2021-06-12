import 'package:brbr/models/brbr_user.dart';
import 'package:brbr/services/brbr_service.dart';
import 'package:brbr/services/requests/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final int userId;
  final String name;
  RegisterPage(this.userId, this.name);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();

  @override
  initState() {
    super.initState();
    _nameFieldController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원 가입')),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameFieldController,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                MaterialButton(
                  child: Text('확인'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Response response = await BRBRService.register(widget.userId, _nameFieldController.text);
                      if (response.statusCode == 200) {
                        BRBRUser? user = await BRBRService.getUserInfo();
                        if (user != null) {
                          context.read<BRBRUser>().updateUserInfo(user);
                        }
                        Navigator.popUntil(context, (route) => route.isFirst);
                      } else {
                        print(response.content());
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
