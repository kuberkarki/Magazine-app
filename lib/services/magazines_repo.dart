import 'dart:convert';
import 'package:http/http.dart' as http;

import '../common/config.dart';
import '../models/magazines.dart';

class MagazinesRepo {
  static const String url = apiUrl + 'free-magazine-releases';

  static Future<List<Magazine>> getMagazines() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Magazines magazines = parseMagazines(response.body);
        return magazines.magazine;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Magazines parseMagazines(String responseBody) {
    final parsed = jsonDecode(responseBody);
    return Magazines.fromJson(parsed);
    // return parsed.map<Magazines>((json) => Magazines.fromJson(json)).toList();
  }
}
