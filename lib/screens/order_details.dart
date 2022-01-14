import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {

  final bool showConfirmedButtons;


  final String orderId;

  const OrderDetails({Key key, this.showConfirmedButtons, this.orderId}) : super(key: key);


  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Order details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('order_items')
            .where('order_id', isEqualTo: widget.orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data.docs.map((doc) {
                  return Card(
                    color: Colors.blueGrey.withOpacity(0.7),
                    elevation: 2.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Image.network(
                                  doc['picture'],
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                )),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Qty :  ' +
                                        (doc['quantity'].toString()),
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ListTile(
                          title: Text(doc['name']),
                          subtitle: Row(
                            children: <Widget>[
                              const Text('Size :'),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(doc['size'],
                                  style: const TextStyle(color: Colors.red)),
                              const SizedBox(
                                width: 40.0,
                              ),
                              const Text('Color :'),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(doc['color'],
                                  style: const TextStyle(color: Colors.red))
                            ],
                          ),
                          leading: Text(
                              '\$' + doc['price_qty'].toStringAsFixed(2),
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),

      bottomNavigationBar: widget.showConfirmedButtons == true ?  Row(
        children: [
          Expanded(
            child: MaterialButton(onPressed: (){
              _updateOrderStatusDelivered();
            },
            child: const Text("Delivered", style: TextStyle(fontSize: 16, color: Colors.white),),
              color: Colors.green,
            ),
          ),
          Expanded(
            child: MaterialButton(onPressed: (){
              _updateOrderStatusCancelled();
            },
              child: const Text("Cancelled", style: TextStyle(fontSize: 16, color: Colors.white),),
              color: Colors.red,
            ),
          ),
        ],
      )  : const SizedBox(),
    );
  }

  void _updateOrderStatusDelivered() {
    var alert = AlertDialog(
      content: const Form(
        child: Text('Are you sure you delivered the order ?',
            style: TextStyle(color: Colors.green)),
        autovalidateMode: AutovalidateMode.always,
      ),
      actions: <Widget>[
        Expanded(
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            color: Colors.red,
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: () {
              setState(() {
                FirebaseFirestore.instance
                    .collection('order')
                    .doc(widget.orderId)
                    .update({'status': 'Delivered'});
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            child: const Icon(
              Icons.done,
              color: Colors.white,
            ),
            color: Colors.green,
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 60.0),
      backgroundColor: Colors.white,
      elevation: 20.0,
    );

    showDialog(context: context, builder: (context) => alert);
  }

  void _updateOrderStatusCancelled() {
    var alert = AlertDialog(
      content: const Form(
        child: Text('Do you really want to cancel the order?',
            style: TextStyle(color: Colors.red)),
        autovalidateMode: AutovalidateMode.always,
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.cancel,
            color: Colors.white,
          ),
          color: Colors.red,
        ),
        MaterialButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('order')
                .doc(widget.orderId)
                .update({'status': 'Cancelled'});
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.done,
            color: Colors.white,
          ),
          color: Colors.green,
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 20.0,
    );

    showDialog(context: context, builder: (context) => alert);
  }
}
