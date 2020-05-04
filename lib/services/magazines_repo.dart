import 'dart:convert';
import '../common/config.dart';
import 'package:http/http.dart' as http;
import '../models/magazines.dart';

 
class MagazinesRepo {
  static const String url = apiUrl+'free-magazine-releases';
 
  static Future<List<Magazine>> getMagazines() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Magazines magazines = parseMagazines(response.body);
        // print(magazines.magazine);
        // List<Magazine> list =magazines.magazine;
      //  print(magazines.magazine);
        return magazines.magazine;
        // return magazines.magazine.toList();
        // return list.data;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
 
  static Magazines parseMagazines(String responseBody) {
    final parsed = jsonDecode(responseBody);
    // print(parsed);
    // return null;
    return Magazines.fromJson(parsed);
    // return parsed.map<Magazines>((json) => Magazines.fromJson(json)).toList();
  }
}