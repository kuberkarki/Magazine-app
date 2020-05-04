import 'dart:io';


import '../models/magazines.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// import 'magazines_repo.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'magazine8_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Magazine('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'image TEXT,'
          'zip_file TEXT,'
          'identifier TEXT,'
          'extracted_file TEXT,'
          'introduction TEXT,'
          'is_free TEXT,'
          'article TEXT,'
          'is_flipper TEXT,'
          'issued_date TEXT,'
          'update_time TEXT,'
          'content TEXT,'
          'version INTEGER'
          ')');

      await db.execute('CREATE TABLE MagazineDetail('
          'id INTEGER PRIMARY KEY,'
          'isLiked int,'
          'isDownloaded int'
          ')');
    });
  }

  // LikeUnlike Magazine on database
  createLiked(int id, var isLiked) async {
    final db = await database;
    var res;
    var magDetail = <String, dynamic>{
      'id': id,
      'isLiked': isLiked == 1 ? 1 : 0
    };
    // print(magDetail);
    List<Map> maps = await db.query('MagazineDetail',
        columns: ['id'], where: 'id = ?', whereArgs: [id]);
    print(maps.length);
    if (maps.length > 0) {
      res = await db.update('MagazineDetail', magDetail,
          where: 'id = ?', whereArgs: [id]);
    } else {
      res = await db.insert('MagazineDetail', magDetail);
    }

    return res;
  }

   // LikeUnlike Magazine on database
  createDownloaded(int id, int isDownloaded) async {
    // await deleteAllMagazines();
    final db = await database;
    var res;
    var magDetail = <String, dynamic>{
      'id': id,
      'isDownloaded': isDownloaded == 1 ? 1 : 0
    };
    List<Map> maps = await db.query('MagazineDetail',
        columns: ['id'], where: 'id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      res = await db.update('MagazineDetail', magDetail,
          where: 'id = ?', whereArgs: [id]);
    } else {
      res = await db.insert('MagazineDetail', magDetail);
    }

    return res;
  }

  // Insert Magazine on database
  createMagazine(Magazine newMagazine) async {
    await deleteAllMagazines();
    // print();
    // if(newMagazine.toJson()['id']==null)
    //   return null;
    // await deleteAllMagazines();
    final db = await database;
    var json=newMagazine.toJson();
    // json.removeWhere((key, value) => key == "isLiked");
    // json.removeWhere((key, value) => key == "isDownloaded");
    final res = await db.insert('Magazine', json);

    return res;
  }

  // Delete all Magazine
  Future<int> deleteAllMagazines() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Magazine WHERE 1');

    return res;
  }

  Future<List<Magazine>> getAllMagazines() async {
    final db = await database;
    var res = await db.rawQuery("SELECT Magazine.id,Magazine.name,Magazine.image,Magazine.zip_file,Magazine.extracted_file,MagazineDetail.isLiked as isLiked,MagazineDetail.isDownloaded as isDownloaded,Magazine.article FROM Magazine LEFT JOIN MagazineDetail ON Magazine.id=MagazineDetail.id ORDER BY Magazine.id DESC");
    print(res.length);
    if(res.length==0){ // TODO:Don't know why it didn't show while I just insert so I called it again
      res = await db.rawQuery("SELECT Magazine.id,Magazine.name,Magazine.image,Magazine.zip_file,Magazine.extracted_file,MagazineDetail.isLiked as isLiked,MagazineDetail.isDownloaded as isDownloaded,Magazine.article FROM Magazine LEFT JOIN MagazineDetail ON Magazine.id=MagazineDetail.id ORDER BY Magazine.id DESC");

    }
    // List<Magazine> list = res.isNotEmpty ? await MagazinesRepo.getMagazines() : [];
    List<Magazine> list = res.isNotEmpty ?res.map((c) => Magazine.fromJsonWithDetal(c)).toList() : [];
    

    return list;
  }

  Future<List<Magazine>> getFavouriteMagazines() async {
    final db = await database;
    final res = await db.rawQuery("SELECT Magazine.id,Magazine.name,Magazine.image,Magazine.zip_file,Magazine.extracted_file,MagazineDetail.isLiked,MagazineDetail.isDownloaded,Magazine.article FROM Magazine JOIN MagazineDetail ON Magazine.id=MagazineDetail.id AND isLiked=1 ORDER BY Magazine.id DESC");

       List<Magazine> list = res.isNotEmpty ?res.map((c) => Magazine.fromJsonWithDetal(c)).toList() : [];


    return list;
  }

  Future<List<Magazine>> getDownloadedMagazines() async {
    final db = await database;
    final res = await db.rawQuery("SELECT Magazine.id,Magazine.name,Magazine.image,Magazine.zip_file,Magazine.extracted_file,MagazineDetail.isLiked,MagazineDetail.isDownloaded,Magazine.article FROM Magazine JOIN MagazineDetail ON Magazine.id=MagazineDetail.id AND isDownloaded=1 ORDER BY Magazine.id DESC");

    List<Magazine> list = res.isNotEmpty ?res.map((c) => Magazine.fromJsonWithDetal(c)).toList() : [];

    return list;
  }
}
