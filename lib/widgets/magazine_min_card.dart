import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../common/config.dart';
import '../models/magazines.dart';
import '../services/db_provider.dart';

class MagazineMinCard extends StatefulWidget {
  final Magazine mag;

  const MagazineMinCard({Key key, this.mag}) : super(key: key);
  @override
  _MagazineMinCardState createState() => _MagazineMinCardState(this.mag);
}

class _MagazineMinCardState extends State<MagazineMinCard> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  SharedPreferences sharedPreferences;
  final Magazine mag;
  String _dir;
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  _MagazineMinCardState(this.mag);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: mag.isDownloaded == 0
            ? Container(child: Text('Slettet'))
            : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Material(
                          elevation: 18.0,
                          child: CachedNetworkImage(
                            imageUrl: mag.image,
                            width: MediaQuery.of(context).size.width * 0.18,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05),
                        Flexible(
                          // width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mag.name,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 180,
                                child: FlatButton.icon(
                                  color: mag.isDownloaded == 1
                                      ? Colors.grey[800]
                                      : Colors.grey[500],
                                  icon: Icon(
                                    Icons.cloud_download,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Ny nedlasting',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    // print(mag.toJson());
                                    final String url = mag.zipFile;
                                    final int id = mag.id;
                                    // final folder = id.toString();
                                    _dir =
                                        (await getApplicationDocumentsDirectory())
                                            .path;
                                    // String html = (_dir + '/$folder/');
                                    // print(html);
                                    if (await checkInternet() == false) {
                                      Fluttertoast.showToast(
                                        msg: "Sjekk Internettforbindelse",
                                        toastLength: Toast.LENGTH_LONG,
                                      );
                                      return;
                                    }
                                    print('Start Dowwnloading...');
                                    Dialogs.showLoadingDialog(
                                        context, _keyLoader);
                                    await _downloadAssets(url, id);
                                    print('End Download');

                                    await DBProvider.db
                                        .createDownloaded(mag.id, 1);
                                    Navigator.of(_keyLoader.currentContext,
                                            rootNavigator: true)
                                        .pop();
                                    setState(() {
                                      mag.isDownloaded = 1;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 180,
                                child: FlatButton.icon(
                                    color: Colors.grey[600],
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Slett nedlasting  ',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      final int id = mag.id;
                                      final folder = id.toString();
                                      _dir =
                                          (await getApplicationDocumentsDirectory())
                                              .path;
                                      String html = (_dir + '/$folder/');
                                      final dir = Directory(html);
                                      dir.deleteSync(recursive: true);
                                      await DBProvider.db
                                          .createDownloaded(mag.id, 0);
                                      setState(() {
                                        mag.isDownloaded = 0;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _downloadAssets(String zipUrl, int id) async {
    if (_dir == null) {
      _dir = (await getApplicationDocumentsDirectory()).path;
    }

    // if (!await _hasToDownloadAssets(name, _dir)) {
    //   return;
    // }
    File zippedFile = await _downloadFile(zipUrl, '$id.zip', _dir);

    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);

    for (var file in archive) {
      var filename = '$_dir/$id/${file.name}';
      if (file.isFile) {
        var outFile = File(filename);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
    File('$_dir/$id.zip').delete();
  }

  Future<File> _downloadFile(String url, String filename, String dir) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$dir/$filename');
    return file.writeAsBytes(req.bodyBytes);
  }
}
