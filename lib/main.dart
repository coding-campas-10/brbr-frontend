import 'package:brbr/constants/colors.dart';
import 'package:brbr/models/brbr_receipt.dart';
import 'package:brbr/models/brbr_user.dart';
import 'package:brbr/models/location_provider.dart';
import 'package:brbr/pages/login.dart';
import 'package:brbr/pages/wrapper.dart';
import 'package:brbr/services/brbr_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BRBRApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
}

class BRBRApp extends StatelessWidget {
  Widget _loadingPage() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: BRBRColors.highlight,
        ),
      ),
    );
  }

  Future<Widget> _loginSequence(BuildContext context) async {
    if (context.select<BRBRUser, int?>((user) => user.userId) != null) {
      return BRBRWrapper();
    }
    bool isLoggedIn = await BRBRService.isLoggedIn();
    if (isLoggedIn) {
      BRBRUser? user = await BRBRService.getUserInfo();
      if (user != null) {
        context.read<BRBRReceiptInfos>().update();
        context.read<BRBRUser>().updateUserInfo(user);
      }
      return _loadingPage();
    }
    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BRBRUser(),
        ),
        ChangeNotifierProvider(
          create: (context) => BRBRReceiptInfos(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
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
        home: Builder(
          builder: (context) {
            return FutureBuilder(
              future: _loginSequence(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data as Widget;
                } else {
                  return _loadingPage();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
