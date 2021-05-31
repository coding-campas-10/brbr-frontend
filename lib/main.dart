import 'package:brbr/pages/login.dart';
import 'package:brbr/pages/wrapper.dart';
import 'package:brbr/utils/services/brbr_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BRBRApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
}

class BRBRApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BRBRAuth.getInstance()),
      ],
      child: MaterialApp(
        title: '버려버려',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backwardsCompatibility: false,
            backgroundColor: Colors.white,
            centerTitle: true,
            titleTextStyle: TextStyle(color: Colors.black),
            actionsIconTheme: IconThemeData(color: Colors.black),
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Consumer<BRBRAuth>(
          builder: (context, value, child) {
            if (value.isLoaded) {
              if (value.loginStatus == LoginStatus.loggedOut) {
                return LoginPage();
              } else {
                return BRBRWrapper();
              }
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
