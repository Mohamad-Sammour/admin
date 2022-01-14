import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductsService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String table = "products";
  String getProductsNum;

  void createProduct(Map<String, dynamic> data) {
    var id = const Uuid();
    String productId = id.v1();
    data["id"] = productId;

    firestore.collection(table).doc(productId).set(data);
  }

  Future<List<DocumentSnapshot>> getProducts() =>
      firestore.collection(table).get().then((snaps) {
        getProductsNum = snaps.docs.length.toString();
        return snaps.docs;
      });
}
