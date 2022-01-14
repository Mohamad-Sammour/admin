import 'package:on_baleh_admin/database/products.dart';
import 'package:on_baleh_admin/screens/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key key}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final ProductsService _productService = ProductsService();
  List<DocumentSnapshot> products = <DocumentSnapshot>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            "Products list",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(12.0),
          children: <Widget>[
            const SizedBox(height: 20.0),
            StreamBuilder<QuerySnapshot>(
                stream: _productService.firestore
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.docs.map((doc) {
                        return Card(
                          elevation: 3.0,
                          child: ListTile(
                            title: Text(doc['name']),
                            leading: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.green.shade300,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetails(id: doc.id)));
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await _productService.firestore
                                    .collection('products')
                                    .doc(doc.id)
                                    .delete();
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ],
        ));
  }

  _getProducts() async {
    List<DocumentSnapshot> data = await _productService.getProducts();
    setState(() {
      products = data;
    });
  }
}
