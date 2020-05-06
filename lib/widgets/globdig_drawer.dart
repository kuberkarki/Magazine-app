import 'package:flutter/material.dart';

import '../downloaded.dart';
import '../main.dart';
import '../settings.dart';
import '../favourite.dart';
import '../widgets/profile_page.dart';

class GlobDigDrawer extends StatefulWidget {
  @override
  _GlobDigDrawerState createState() => _GlobDigDrawerState();
}

class _GlobDigDrawerState extends State<GlobDigDrawer> {
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
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePage()));
            },
          ),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Innstillinger',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            },
          ),
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
