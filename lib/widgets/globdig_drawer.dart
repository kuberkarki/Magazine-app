import '../favourite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../downloaded.dart';
import '../login.dart';
import '../main.dart';

class GlobDigDrawer extends StatefulWidget {
  @override
  _GlobDigDrawerState createState() => _GlobDigDrawerState();
}

class _GlobDigDrawerState extends State<GlobDigDrawer> {
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
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("assets/logo.png"))),
              child: null,
            ),
            _createDrawerItem(
              icon: Icons.local_library,
              text: 'Magasiner',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => MainPage()));
              },
            ),
            _createDrawerItem(
              icon: Icons.event,
              text: 'Nedlastede magasiner',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => DownloadedPage()));
              },
            ),
            _createDrawerItem(
              icon: Icons.star,
              text: 'Favoritter',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => FavouritePage()));
              },
            ),
            _createDrawerItem(
              icon: Icons.person,
              text: 'Min profil',
            ),
            _createDrawerItem(
              icon: Icons.settings,
              text: 'Innstillinger',
            ),
            _createDrawerItem(
                icon: Icons.exit_to_app,
                text: 'Logg ut',
                onTap: () {
                  sharedPreferences.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      (Route<dynamic> route) => false);
                }),
          ],
        ),
      );
  }

  Widget _createDrawerItem(
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