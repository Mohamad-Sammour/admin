import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {

  final String id;

  const ProductDetails({Key key, this.id}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          "Product details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc(id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Loading");
            }
            var productDocument = snapshot.data;
            return Center(
              child: ListView(
                children: <Widget>[
                  Card(
                    child: Image.network(
                      snapshot.data['picture']
                     /* productDocument['picture']*/,
                      width: MediaQuery.of(context).size.width,
                      height: 400.0,
                      fit: BoxFit.cover,
                    ),
                    color: Colors.grey.shade700,
                  ),
                  Card(
                    color: Colors.grey.withOpacity(0.5),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.track_changes,
                            color: Colors.white,
                          ),
                          title: const Text('Product Name :',
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            productDocument['name'],
                            style:
                                const TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.branding_watermark,
                            color: Colors.white,
                          ),
                          title: const Text('Brand :',
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            productDocument['brand'],
                            style:
                                const TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.category,
                            color: Colors.white,
                          ),
                          title: const Text('Category :',
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            productDocument['category'],
                            style:
                                const TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.color_lens,
                            color: Colors.white,
                          ),
                          title: const Text('Colors :',
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            productDocument['colors'].toString(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 11.0),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.featured_play_list,
                            color: Colors.white,
                          ),
                          title: const Text('Featured :',
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            productDocument['featured'].toString(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.white,
                          ),
                          title: const Text('Sale :',
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            productDocument['sale'].toString(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.equalizer,
                            color: Colors.white,
                          ),
                          title: const Text('Qty :',
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            productDocument['quantity'].toString(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.supervisor_account,
                            color: Colors.white,
                          ),
                          title: const Text('Sizes :',
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            productDocument['sizes'].toString(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                          ),
                          title: const Text('Price :',
                              style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            '\$ ' + productDocument['price'].toString(),
                            style:
                                const TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
            );
          }),
    );
  }
}
