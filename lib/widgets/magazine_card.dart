import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';

import '../common/config.dart';
// import '../helpers/dio_helper.dart';
import '../models/magazines.dart';
import '../services/db_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';

import 'package:archive/archive.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../web_view.dart';
import '../web_view_downloaded.dart';

class MagazineCard extends StatefulWidget {
  final Magazine mag;

  const MagazineCard({Key key, this.mag}) : super(key: key);
  @override
  _MagazineCardState createState() => _MagazineCardState(this.mag);
}

class _MagazineCardState extends State<MagazineCard> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final Magazine mag;
  String _dir;

  _MagazineCardState(this.mag);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
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
                      width: MediaQuery.of(context).size.width * 0.28,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Flexible(
                    // width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mag.name,
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          mag.article,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () async {
                            // print(mag.toJson());
                            // var dbp= DBProvider;
                            int change = mag.isLiked == 1 ? 0 : 1;
                            await DBProvider.db.createLiked(mag.id, change);
                            setState(() {
                              mag.isLiked = change;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                      mag.isLiked == 1
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 20),
                                ),
                                TextSpan(
                                  text: mag.isLiked == 1
                                      ? "Fjerne fra favoritten"
                                      : "Marker som favoritt",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 160,
                          child: FlatButton.icon(
                            color: mag.isDownloaded == 1
                                ? Colors.grey[800]
                                : Colors.grey[500],
                            icon: Icon(
                              Icons.cloud_download,
                              color: Colors.white,
                            ),
                            label: Text(
                              mag.isDownloaded == 1
                                  ? 'ÅPNE LASTET'
                                  : 'LAST NED',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              // print(mag.toJson());
                              final String url = mag.zipFile;
                              final int id = mag.id;
                              final folder = id.toString();
                              _dir = (await getApplicationDocumentsDirectory())
                                  .path;
                              String html = (_dir + '/$folder/index.html');
                              // print(html);
                              if (!await _hasToDownloadAssets(html)) {
                                if (await checkInternet() == false) {
                                  Fluttertoast.showToast(
                                    msg: "Sjekk Internettforbindelse",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                  return;
                                }
                                print('Start Dowwnloading...');
                                Dialogs.showLoadingDialog(context, _keyLoader);
                                await _downloadAssets(url, id);
                                print('End Download');

                                await DBProvider.db.createDownloaded(mag.id, 1);
                                Navigator.of(_keyLoader.currentContext,
                                        rootNavigator: true)
                                    .pop();
                                setState(() {
                                  mag.isDownloaded = 1;
                                });
                              } else {
                                await DBProvider.db.createDownloaded(mag.id, 1);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebViewDownloaded(
                                            selectedUrl: 'file://' + html,
                                            title: mag.name,
                                          )),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: FlatButton.icon(
                              color: Colors.grey[800],
                              icon: Icon(
                                Icons.language,
                                color: Colors.white,
                              ),
                              label: Text(
                                'LES ONLINE',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async{
                                if (await checkInternet() == false) {
                                  Fluttertoast.showToast(
                                    msg: "Sjekk Internettforbindelse",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebView(
                                            selectedUrl: Uri.encodeFull(
                                                mag.extractedFile +
                                                    '?token=kuberkarki1'),
                                            title: mag.name,
                                          )),
                                );
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
    // print('here');
    File zippedFile = await _downloadFile(zipUrl, '$id.zip', _dir);

    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);

    for (var file in archive) {
      var filename = '$_dir/$id/${file.name}';
      if (file.isFile) {
        var outFile = File(filename);
        // print(filename);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
    File('$_dir/$id.zip').delete();
  }

  Future<bool> _hasToDownloadAssets(String url) async {
    var file = File('$url');
    return (await file.exists());
  }

  Future<File> _downloadFile(String url, String filename, String dir) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$dir/$filename');
    return file.writeAsBytes(req.bodyBytes);
  }

  Future<File> _downloadFileWithPercentage(
      String url, String filename, String dir) async {
    var httpClient = http.Client();
    var request = new http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);

    List<List<int>> chunks = new List();
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        // Display percentage of completion
        debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

        // Save the file
        File file = new File('$dir/$filename');
        final Uint8List bytes = Uint8List(r.contentLength);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);
        return file;
      });
    });
    return null;
  }
}
