import './common/config.dart';
import './widgets/globdig_drawer.dart';
import './widgets/magazine_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './models/magazines.dart';
// import './providers/magazine_api_provider.dart';
// import './services/db_provider.dart';
import './login.dart';

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

          // Define the default font family.
          fontFamily: 'Roboto',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          // textTheme: TextTheme(
          //   headline: TextStyle(
          //       fontSize: 72.0,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black),
          //   title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //   body1: TextStyle(fontSize: 14.0, fontFamily: 'Georgia'),
          // ),
        ));
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;
  List<Magazine> mag, mag1;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    // getMagaginData();
    // MagazinesRepo.getMagazines().then((magsFromServer) {
    //   setState(() {
    //     mag = magsFromServer;
    //   });
    // });
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
        title: Text(APPNAME,
            style: TextStyle(color: Colors.black), textAlign: TextAlign.right),
        // actions: <Widget>[
        //   FlatButton(
        //     onPressed: () async {
        //       var apiProvider = MagazineApiProvider();
        //       await apiProvider.getAllMagazines();
        //       // var mag1 = await DBProvider.db.getAllMagazines();
        //       mag1 = await DBProvider.db.getAllMagazines();
        //       setState(() {
        //         mag = mag1;
        //       });
        //     },
        //     child: Text("Refresh", style: TextStyle(color: Colors.black)),
        //   ),
        // ],
      ),
      body: MagazinePage(),
      drawer: GlobDigDrawer(),
    );
  }
}

