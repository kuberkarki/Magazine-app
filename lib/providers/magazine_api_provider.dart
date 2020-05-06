import '../services/db_provider.dart';
import '../services/magazines_repo.dart';
import '../models/Magazines.dart';

class MagazineApiProvider {
  Future<List<Magazine>> getAllMagazines() async {
    
    
   List mags = await MagazinesRepo.getMagazines();
   

    return mags.map((mag) {
      print('Inserting $Magazine');
      // print(mag.id);
      DBProvider.db.createMagazine(mag);
    }).toList();
  }
}