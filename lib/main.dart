import 'package:LEDERNYTT/magazine.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/config.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: APPNAME,
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.black,
        ));
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;
  bool _loggedin = false;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      setState(() {
        _loggedin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loggedin ? MyMagazinePage() : LoginPage();
  }
}
