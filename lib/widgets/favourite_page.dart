// import '../providers/magazine_api_provider.dart';
import '../services/db_provider.dart';

import '../models/magazines.dart';
import 'package:flutter/material.dart';

import 'magazine_card.dart';

class FavouritePageWidget extends StatefulWidget {
  @override
  _FavouritePageWidgetState createState() => _FavouritePageWidgetState();
}

class _FavouritePageWidgetState extends State<FavouritePageWidget> {
  List<Magazine> mag, mag1;

  @override
  void initState() {
    super.initState();
    getMagaginData();
  }

  getMagaginData() async {
    mag1 = await DBProvider.db.getFavouriteMagazines();

    setState(() {
      mag = mag1;
    });
  }

  // Future<void> _launchInBrowser(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: false,
  //       forceWebView: false,
  //       headers: <String, String>{'my_header_key': 'my_header_value'},
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // Future<void> _launchInWebViewWithJavaScript(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(
  //       url,
  //       forceSafariVC: true,
  //       forceWebView: true,
  //       enableJavaScript: true,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: mag == null
          ? Container()
          : ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: mag.length,
              itemBuilder: (BuildContext context, int index) {
                return MagazineCard(mag: mag[index]);
              },
            ),
    );
  }
}
