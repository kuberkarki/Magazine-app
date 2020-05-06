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
      ),
      body: MagazinePage(),
      drawer: GlobDigDrawer(),
    );
  }
}
