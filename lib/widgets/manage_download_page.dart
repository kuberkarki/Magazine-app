
import 'package:LEDERNYTT/services/db_provider.dart';

// import 'downloaded_page.dart';
import '../widgets/globdig_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/magazines.dart';
import '../login.dart';
import 'magazine_min_card.dart';

class ManageDownloadPage extends StatefulWidget {
  @override
  _ManageDownloadPageState createState() => _ManageDownloadPageState();
}

class _ManageDownloadPageState extends State<ManageDownloadPage> {
  SharedPreferences sharedPreferences;
  List<Magazine> mag, mag1;

  @override
  void initState() {
    super.initState();
     checkLoginStatus();
    getMagaginData();
  }

  getMagaginData() async {
    mag1 = await DBProvider.db.getDownloadedMagazines();

    setState(() {
      mag = mag1;
    });
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
      body: Center(
      child: mag == null
          ? Container()
          : ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: mag.length,
              itemBuilder: (BuildContext context, int index) {
                return MagazineMinCard(mag: mag[index]);
              },
            ),
    ),
      drawer: GlobDigDrawer(),
    );
  }
}
