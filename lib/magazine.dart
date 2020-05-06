import 'package:flutter/material.dart';

import 'common/config.dart';
import 'widgets/globdig_drawer.dart';
import 'widgets/magazine_page.dart';

class MyMagazinePage extends StatefulWidget {
  MyMagazinePage({Key key}) : super(key: key);

  @override
  _MyMagazinePageState createState() => _MyMagazinePageState();
}

class _MyMagazinePageState extends State<MyMagazinePage> {
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
