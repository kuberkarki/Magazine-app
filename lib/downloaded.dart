
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/downloaded_page.dart';

import 'widgets/globdig_drawer.dart';
import 'models/magazines.dart';
import 'login.dart';

class DownloadedPage extends StatefulWidget {
  @override
  _DownloadedPageState createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
  SharedPreferences sharedPreferences;
  List<Magazine> mag, mag1;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Nedlastede magasiner",
            style: TextStyle(color: Colors.black), textAlign: TextAlign.right),
      ),
      body: DownloadedPageWidget(),
      drawer: GlobDigDrawer(),
    );
  }
}
