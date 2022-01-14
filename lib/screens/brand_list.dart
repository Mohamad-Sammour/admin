import 'package:on_baleh_admin/database/brands.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BrandsList extends StatefulWidget {
  const BrandsList({Key key}) : super(key: key);

  @override
  _BrandsListState createState() => _BrandsListState();
}

class _BrandsListState extends State<BrandsList> {
  final BrandsService _brandsService = BrandsService();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandsService.getBrands();

    setState(() {
      brands = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          "Brands list",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _brandsService.firestore.collection("brands").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.docs.map((doc) {
                      return Card(
                        child: ListTile(
                          title: Text(doc['name']),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await _brandsService.firestore
                                  .collection("brands")
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
              })
        ],
      ),
    );
  }
}
