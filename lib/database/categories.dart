import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String table = "categories";
  String getCategoriesNum = "0";

  void createCategories(String name) {
    var id = const Uuid();
    String categoryId = id.v1();
    firestore.collection(table).doc(categoryId).set({'name': name});
  }

  // Select all categories
  Future<List<DocumentSnapshot>> getCategories() =>
      firestore.collection(table).get().then((snaps) {
        getCategoriesNum = snaps.docs.length.toString();
        return snaps.docs;
      });
}
