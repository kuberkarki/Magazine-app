import 'dart:async';

import '../common/config.dart';
import '../providers/magazine_api_provider.dart';
import '../services/db_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/magazines.dart';
import 'package:flutter/material.dart';

import 'magazine_card.dart';

class MagazinePage extends StatefulWidget {
  @override
  _MagazinePageState createState() => _MagazinePageState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _MagazinePageState extends State<MagazinePage> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Magazine> mag, mag1, filteredmag;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if (await checkInternet() == false) {
      Fluttertoast.showToast(
        msg: "Sjekk Internettforbindelse",
        toastLength: Toast.LENGTH_LONG,
      );
      _refreshController.refreshCompleted();
      return;
    }
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    var apiProvider = MagazineApiProvider(); // Load to DB
    await apiProvider.getAllMagazines();
    mag1 = await DBProvider.db.getAllMagazines();
    if (mounted)
      setState(() {
        mag = mag1;
        filteredmag = mag;
      });
    _refreshController.refreshCompleted();
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    getMagaginData();
    // MagazinesRepo.getMagazines().then((magsFromServer) {
    //   setState(() {
    //     mag = magsFromServer;
    //   });
    // });
  }

  getMagaginData() async {
    mag1 = await DBProvider.db.getAllMagazines(); //From DB
    if (mag1.length < 1) {
      var apiProvider = MagazineApiProvider(); // Load to DB
      await apiProvider.getAllMagazines();
      mag1 = await DBProvider.db.getAllMagazines();
      filteredmag = mag1;
    }

    setState(() {
      mag = mag1;
      filteredmag = mag;
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
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(Icons.search, color: Colors.black),
            hintText: 'Soke...',
          ),
          onChanged: (string) {
            print(string);
            _debouncer.run(() {
              setState(() {
                filteredmag = mag
                    .where((u) =>
                        (u.name.toLowerCase().contains(string.toLowerCase()) ||
                            u.article
                                .toLowerCase()
                                .contains(string.toLowerCase())
                        //  || ( u.content.toLowerCase().contains(string.toLowerCase()))
                        ))
                    .toList();
              });
            });
          },
        ),
        Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            header: WaterDropHeader(),
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: mag == null
                ? Center(child: Text('Wait...'))
                : ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: filteredmag.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MagazineCard(mag: filteredmag[index]);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
