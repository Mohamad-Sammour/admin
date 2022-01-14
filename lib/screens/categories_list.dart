import 'package:on_baleh_admin/database/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  final CategoryService _categoryService = CategoryService();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
    });
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          "Categories list",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
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
                            await _categoryService.firestore
                                .collection("categories")
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
            },
            stream:
                _categoryService.firestore.collection('categories').snapshots(),
          ),
        ],
      ),
    );
  }
}
