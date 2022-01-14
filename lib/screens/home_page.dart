import 'package:on_baleh_admin/database/brands.dart';
import 'package:on_baleh_admin/database/categories.dart';
import 'package:on_baleh_admin/screens/add_product.dart';
import 'package:on_baleh_admin/screens/brand_list.dart';
import 'package:on_baleh_admin/screens/categories_list.dart';
import 'package:on_baleh_admin/screens/order_list.dart';
import 'package:on_baleh_admin/screens/products_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _brandDialog() {
    var dialog = AlertDialog(
      content: TextField(
        controller: brandController,
        decoration: const InputDecoration(hintText: "Add brand"),
      ),
      actions: [
        MaterialButton(
          child: const Text("Add"),
          onPressed: () {
            if (brandController.text == "") {
              Fluttertoast.showToast(msg: "You must enter the brand name");
            } else {
              _brandsService.createBrands(brandController.text);
              Fluttertoast.showToast(msg: 'Brand added');
              Navigator.pop(context);
            }
          },
        ),
        MaterialButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  void _categoryDialog() {
    var dialog = AlertDialog(
      content: TextField(
        controller: categoryController,
        decoration: const InputDecoration(hintText: "Add category"),
      ),
      actions: [
        MaterialButton(
          child: const Text("Add"),
          onPressed: () {
            if (categoryController.text == "") {
              Fluttertoast.showToast(msg: "You must enter the category name");
            } else {
              //insert database
              _categoryService.createCategories(categoryController.text);

              Fluttertoast.showToast(msg: 'category added');
              Navigator.pop(context);
            }
          },
        ),
        MaterialButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  final CategoryService _categoryService = CategoryService();
  final BrandsService _brandsService = BrandsService();
  double total = 0.0;
  int totalCancelled = 0;
  int totalDelivered = 0;
  int numOfProducts = 0;
  int numOfOrders = 0;
  int numOfCategories = 0;
  int numOfBrands = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.dashboard,
                        color: Colors.red,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Dashboard",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Manage",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
            indicatorColor: Colors.red,
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                ListTile(
                  title: const Text(
                    "Revenue",
                    style: TextStyle(fontSize: 24.0, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    "\$ ${getTotalPrice().toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    children: [
                      Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.branding_watermark,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Brands"),
                              )
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              getNumOfBrands().toString(),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 60.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BrandsList()));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.category,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Categories"),
                              )
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              getNumOfCategories().toString(),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 60.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CategoriesList()));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.track_changes,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Products"),
                              )
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              getNumOfProduct().toString(),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 60.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductsList()));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.shopping_cart_rounded,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Orders"),
                              )
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              getNumOfOrdersConfirmed().toString(),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 60.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderList()));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.directions_car,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Delivered"),
                              )
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              getNumOfOrdersDelivered().toString(),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 60.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderList()));
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Cancelled"),
                              )
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              getNumOfOrdersCancelled().toString(),
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 60.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderList()));
                          },
                        ),
                      ),
                    ],
                    padding: const EdgeInsets.all(20.0),
                  ),
                )
              ],
            ),
            ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.add,color: Colors.white,),
                  title: const Text("Add Product",style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddProduct()));
                  },
                ),
                const Divider(color: Colors.white,height: 15,),
                ListTile(
                  leading: const Icon(Icons.change_history,color: Colors.white,),
                  title: const Text("Products list",style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductsList()));
                  },
                ),
                const Divider(color: Colors.white,height: 15,),
                ListTile(
                  leading: const Icon(Icons.add_circle,color: Colors.white,),
                  title: const Text("Add category",style: TextStyle(color: Colors.white),),
                  onTap: () {
                    _categoryDialog();
                  },
                ),
                const Divider(color: Colors.white,height: 15,),
                ListTile(
                  leading: const Icon(Icons.category,color: Colors.white,),
                  title: const Text("Categories list",style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoriesList()));
                  },
                ),
                const Divider(color: Colors.white,height: 15,),
                ListTile(
                  leading: const Icon(Icons.add_circle_outline,color: Colors.white,),
                  title: const Text("Add brand",style: TextStyle(color: Colors.white),),
                  onTap: () {
                    _brandDialog();
                  },
                ),
                const Divider(color: Colors.white,height: 15,),
                ListTile(
                  leading: const Icon(Icons.branding_watermark,color: Colors.white,),
                  title: const Text("Brand list",style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BrandsList()));
                  },
                ),
                const Divider(color: Colors.white,height: 15,),
                ListTile(
                  leading: const Icon(Icons.library_books,color: Colors.white,),
                  title: const Text("Orders list",style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrderList()));
                  },
                ),
                const Divider(color: Colors.white,height: 15,),
              ],
            )
          ],
        ),
      ),
    );
  }

  int getNumOfProduct() {
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + 1);
      setState(() {
        numOfProducts = tempTotal;
      });
    });
    return numOfProducts;
  }

  int getNumOfCategories() {
    FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + 1);
      setState(() {
        numOfCategories = tempTotal;
      });
    });
    return numOfCategories;
  }

  int getNumOfBrands() {
    FirebaseFirestore.instance
        .collection('brands')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + 1);
      setState(() {
        numOfBrands = tempTotal;
      });
    });
    return numOfBrands;
  }

  int getNumOfOrdersConfirmed() {
    FirebaseFirestore.instance
        .collection('order')
        .where('status', isEqualTo: 'Confirmed')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + 1);
      setState(() {
        numOfOrders = tempTotal;
      });
    });
    return numOfOrders;
  }

  int getNumOfOrdersDelivered() {
    FirebaseFirestore.instance
        .collection('order')
        .where('status', isEqualTo: 'Delivered')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + 1);
      setState(() {
        totalDelivered = tempTotal;
      });
      /*debugPrint(total.toString());*/
    });
    return totalDelivered;
  }

  int getNumOfOrdersCancelled() {
    FirebaseFirestore.instance
        .collection('order')
        .where('status', isEqualTo: 'Cancelled')
        .snapshots()
        .listen((snapshot) {
      int tempTotal = snapshot.docs.fold(0, (tot, doc) => tot + 1);
      setState(() {
        totalCancelled = tempTotal;
      });
      /*debugPrint(total.toString());*/
    });
    return totalCancelled;
  }

  double getTotalPrice() {
    FirebaseFirestore.instance
        .collection('order')
        .where('status', isEqualTo: 'Delivered')
        .snapshots()
        .listen((snapshot) {
      double tempTotal =
          snapshot.docs.fold(0, (tot, doc) => tot + doc['total_price']);
      setState(() {
        total = tempTotal;
      });
      /*debugPrint(total.toString());*/
    });
    return total;
  }
}
