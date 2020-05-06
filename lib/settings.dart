import 'package:LEDERNYTT/widgets/send_epost.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'widgets/change_password_page.dart';
import 'widgets/globdig_drawer.dart';
import 'widgets/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences sharedPreferences ;
   @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Innstillinger",
            style: TextStyle(color: Colors.black), textAlign: TextAlign.right),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: ListView(
          children:[
            _createSettingsItem(
                icon: Icons.message,
                text: 'Send oss epost',
                onTap: () {
                  
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => SendEpostPage()));
                }),
                _createSettingsItem(
                icon: Icons.person,
                text: 'Profil',
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => ProfilePage()));
                }),
                _createSettingsItem(
                icon: Icons.lock,
                text: 'Endre passord',
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => ChangePasswordPage()));
                }),
             _createSettingsItem(
                icon: Icons.exit_to_app,
                text: 'Logg ut',
                onTap: () {

                  sharedPreferences.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      (Route<dynamic> route) => false);
                }),
          ]
        ),
      ),
      drawer: GlobDigDrawer(),
    );
  }

    Widget _createSettingsItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
}
