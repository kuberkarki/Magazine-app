import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';



const api =
    'https://firebasestorage.googleapis.com/v0/b/playground-a753d.appspot.com/o';

enum AppTheme { candy, cocktail }


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(AppTheme.candy),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final AppTheme theme;

  MyHomePage(this.theme);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppTheme _theme;
  String _dir;

  @override
  void initState() {
    super.initState();
    _theme = widget.theme;
    // _images = 'magazines';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.style),
        onPressed: () async {
          if (_theme == AppTheme.candy) {
            await _downloadAssets('cocktail');
          }
          setState(() {
            // _theme =
            //     _theme == AppTheme.candy ? AppTheme.cocktail : AppTheme.candy;
            // _images = data[_theme];
          });
        },
      ),
      body: Container(
          ),
    );
  }

  String _getHtml(int id, String dir) {
   
      // String file = _getLocalHtmlFile(id.toString(), dir);

   
      return '$dir/$id.toString()/index.html';
    
  }

  // String _getLocalHtmlFile(String name, String dir) => Sriing('$dir/$name/index.html');

  Future<void> _downloadAssets(String name) async {
    if (_dir == null) {
      _dir = (await getApplicationDocumentsDirectory()).path;
    }

    if (!await _hasToDownloadAssets(name, _dir)) {
      return;
    }
    var zippedFile = await _downloadFile(
        '$api/$name.zip?alt=media&token=7442d067-a656-492f-9791-63e8fc082379',
        '$name.zip',
        _dir);

    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);

    for (var file in archive) {
      var filename = '$_dir/${file.name}';
      if (file.isFile) {
        var outFile = File(filename);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
  }

  Future<bool> _hasToDownloadAssets(String name, String dir) async {
    var file = File('$dir/$name.zip');
    return !(await file.exists());
  }

  Future<File> _downloadFile(String url, String filename, String dir) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$dir/$filename');
    return file.writeAsBytes(req.bodyBytes);
  }
}