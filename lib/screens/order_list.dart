import 'package:on_baleh_admin/screens/order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Order list",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Column(
                  children: const [
                    Icon(
                      Icons.done,
                      color: Colors.blue,
                    ),
                    Text(
                      "Confirmed",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: const [
                    Icon(
                      Icons.directions_car,
                      color: Colors.green,
                    ),
                    Text(
                      "Delivered",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: const [
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    Text(
                      "Cancelled",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('order')
                    .where('status', isEqualTo: 'Confirmed')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        /*scrollDirection: Axis.horizontal,*/
                        children: snapshot.data.docs.map((doc) {
                          return InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderDetails(
                                          orderId: doc.id,
                                          showConfirmedButtons: true,
                                        ))),
                            child: Card(
                              elevation: 2.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Image.asset(
                                        'images/confirmed.jpg',
                                        width: 100.0,
                                        height: 100.0,
                                      )),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Text(
                                              doc['status'],
                                              style: TextStyle(
                                                  color: doc['status'] ==
                                                          'Cancelled'
                                                      ? Colors.red
                                                      : (doc['status'] ==
                                                              'Delivered'
                                                          ? Colors.green
                                                          : Colors.blue),
                                                  fontSize: 20.0),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Text(doc['username'].toString()),
                                            Text(doc['phone_number'].toString())
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                    title: Text(doc['address']),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(doc['create_time']
                                                .toString()
                                                .substring(0, 10)),
                                            Text('  |  ' +
                                                doc['create_time']
                                                    .toString()
                                                    .substring(11, 16)),
                                          ],
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                    leading: Text(
                                        '\$ ' +
                                            doc['total_price']
                                                .toStringAsFixed(2),
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('order')
                    .where('status', isEqualTo: 'Delivered')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        /*scrollDirection: Axis.horizontal,*/
                        children: snapshot.data.docs.map((doc) {
                          return InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderDetails(
                                          orderId: doc.id,
                                          showConfirmedButtons: false,
                                        ))),
                            child: Card(
                              elevation: 2.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Image.asset(
                                        'images/delivery.png',
                                        width: 100.0,
                                        height: 100.0,
                                      )),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Text(
                                              doc['status'],
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20.0),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Text(doc['username'].toString()),
                                            Text(doc['phone_number'].toString())
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                    title: Text(doc['address']),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(doc['create_time']
                                                .toString()
                                                .substring(0, 10)),
                                            Text('  |  ' +
                                                doc['create_time']
                                                    .toString()
                                                    .substring(11, 16)),
                                          ],
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                    leading: Text(
                                        '\$ ' +
                                            doc['total_price']
                                                .toStringAsFixed(2),
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('order')
                    .where('status', isEqualTo: 'Cancelled')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        /*scrollDirection: Axis.horizontal,*/
                        children: snapshot.data.docs.map((doc) {
                          return InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderDetails(
                                          orderId: doc.id,
                                          showConfirmedButtons: false,
                                        ))),
                            child: Card(
                              elevation: 2.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Image.asset(
                                        'images/cancel.png',
                                        width: 100.0,
                                        height: 100.0,
                                      )),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Text(
                                              doc['status'],
                                              style: TextStyle(
                                                  color: doc['status'] ==
                                                          'Cancelled'
                                                      ? Colors.red
                                                      : (doc['status'] ==
                                                              'Delivered'
                                                          ? Colors.green
                                                          : Colors.blue),
                                                  fontSize: 20.0),
                                            ),
                                            const Divider(
                                              color: Colors.black,
                                            ),
                                            Text(doc['username'].toString()),
                                            Text(doc['phone_number'].toString())
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListTile(
                                    title: Text(doc['address']),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(doc['create_time']
                                                .toString()
                                                .substring(0, 10)),
                                            Text('  |  ' +
                                                doc['create_time']
                                                    .toString()
                                                    .substring(11, 16)),
                                          ],
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    ),
                                    leading: Text(
                                        '\$ ' +
                                            doc['total_price']
                                                .toStringAsFixed(2),
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
