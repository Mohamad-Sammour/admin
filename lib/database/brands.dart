import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String table = "brands";
  String getBrandsNum;

  void createBrands(String name) {
    var id = const Uuid();
    String brandId = id.v1();

    firestore.collection(table).doc(brandId).set({'name': name});
  }

  // Select all barnds
  Future<List<DocumentSnapshot>> getBrands() =>
      firestore.collection(table).get().then((snaps) {
        getBrandsNum = snaps.docs.length.toString();
        return snaps.docs;
      });
}
