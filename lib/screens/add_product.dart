import 'dart:io';

import 'package:on_baleh_admin/database/brands.dart';
import 'package:on_baleh_admin/database/categories.dart';
import 'package:on_baleh_admin/database/products.dart';
import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool yellowColor = false;
  bool greenColor = false;
  bool blueColor = false;
  bool whiteColor = false;
  bool blackColor = false;
  bool redColor = false;

  bool xsSize = false;
  bool sSize = false;
  bool mSize = false;
  bool lSize = false;
  bool xlSize = false;
  bool xxlSize = false;
  bool f1Size = false;
  bool f2Size = false;
  bool f3Size = false;
  bool f4Size = false;
  bool f5Size = false;
  bool f6Size = false;
  bool f7Size = false;
  bool f8Size = false;


  bool switchSale = false;
  bool switchFeatured = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String categoryDropDownItem = "Selected category";
  String brandDropDownItem = "Selected brand";

  File _image;

  final CategoryService _categoryService = CategoryService();
  final BrandsService _brandsService = BrandsService();
  final ProductsService _productsService = ProductsService();

  List<String> brandsDropDownList = [];
  List<String> categoriesDropDownList = [];
  List<String> colorsSelected = [];
  List<String> sizesSelected = [];
  List<String> favoriteUsers = [];

  bool isLoading = false;

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      for (var snapshot in data) {
        categoriesDropDownList.add(snapshot['name']);
      }
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandsService.getBrands();
    setState(() {
      for (var snapshot in data) {
        brandsDropDownList.add(snapshot['name']);
      }
    });
  }

  void validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      if (_image != null) {
        if (colorsSelected.isNotEmpty) {
          if (sizesSelected.isNotEmpty) {
            if (categoryDropDownItem != "Selected category") {
              if (brandDropDownItem != "Selected brand") {
                setState(() => isLoading = true);
                String imageUrl1;
                double price=double.parse(priceController.text);
                int qty =  int.parse(qtyController.text);
                final FirebaseStorage storage = FirebaseStorage.instance;
                final String picture1 =
                    "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                final Future<void> task1 = storage
                    .ref()
                    .child(picture1)
                    .putFile(_image)
                    .then((p0) async {
                  imageUrl1 = await p0.ref.getDownloadURL();
                  _productsService.createProduct({
                    'name': productNameController.text,
                    'price': price,
                    'quantity':qty,
                    'picture': imageUrl1,
                    'brand': brandDropDownItem,
                    'category': categoryDropDownItem,
                    'sale': switchSale,
                    'featured': switchFeatured,
                    'colors': colorsSelected,
                    'sizes': sizesSelected,
                    'favorite': favoriteUsers
                  });
                });

                _formKey.currentState.reset();
                Fluttertoast.showToast(msg: "Product uploaded");
                Navigator.pop(context);
                /*  StorageTaskSnapshot snapshot1 =
                    await task1.onComplete.then((snapshot) => snapshot);*/

                /* task1.onComplete.then((snapshot3) async {
                  imageUrl1 = await snapshot1.ref.getDownloadURL();
                  _productsService.createProduct({
                    'name': productNameController.text,
                    'price': double.parse(priceController.text),
                    'quantity': int.parse(qtyController.text),
                    'picture': imageUrl1,
                    'brand': brandDropDownItem,
                    'category': categoryDropDownItem,
                    'sale': switchSale,
                    'featured': switchFeatured,
                    'colors': colorsSelected,
                    'sizes': sizesSelected,
                    'favorite': favoriteUsers
                  });

                  _formKey.currentState.reset();
                  Fluttertoast.showToast(msg: "Product uploaded");
                  Navigator.pop(context);
                });*/
                setState(() => isLoading = false);
              } else {
                Fluttertoast.showToast(msg: 'The brand must be selected');
              }
            } else {
              Fluttertoast.showToast(msg: 'The category must be selected');
            }
          } else {
            Fluttertoast.showToast(msg: 'At least one size must be chosen');
          }
        } else {
          Fluttertoast.showToast(msg: 'At least one color must be chosen');
        }
      } else {
        Fluttertoast.showToast(msg: 'The image must be provided');
      }
    }
  }

  Widget _displayImageOrIcon() {
    if (_image == null) {
      return const Icon(Icons.add);
    } else {
      return Image.file(_image, fit: BoxFit.cover);
    }
  }

  void _selectImage(Future<File> pickImage) async {
    File tempImg = await pickImage;
    setState(() => _image = tempImg);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
    _getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            "Add product",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ))
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: MaterialButton(
                              color: Colors.white.withOpacity(0.6),
                              child: _displayImageOrIcon(),
                              onPressed: () {
                                _selectImage(ImagePicker.pickImage(
                                    source: ImageSource.gallery));
                              },
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Available colors",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(14)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                value: yellowColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    yellowColor = value;
                                    if (value == true &&
                                        !colorsSelected.contains("yellow")) {
                                      colorsSelected.add("yellow");
                                    } else if (value == false &&
                                        colorsSelected.contains("yellow")) {
                                      colorsSelected.remove("yellow");
                                    }
                                    print(colorsSelected);
                                  });
                                },
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.yellow),
                                checkColor: Colors.black,
                              ),
                              Checkbox(
                                value: greenColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    greenColor = value;
                                    if (value == true &&
                                        !colorsSelected.contains("green")) {
                                      colorsSelected.add("green");
                                    } else if (value == false &&
                                        colorsSelected.contains("green")) {
                                      colorsSelected.remove("green");
                                    }
                                    print(colorsSelected);
                                  });
                                },
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.green),
                                checkColor: Colors.black,
                              ),
                              Checkbox(
                                value: redColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    redColor = value;
                                    if (value == true &&
                                        !colorsSelected.contains("red")) {
                                      colorsSelected.add("red");
                                    } else if (value == false &&
                                        colorsSelected.contains("red")) {
                                      colorsSelected.remove("red");
                                    }
                                    print(colorsSelected);
                                  });
                                },
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.red),
                                checkColor: Colors.black,
                              ),
                              Checkbox(
                                value: blackColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    blackColor = value;
                                    if (value == true &&
                                        !colorsSelected.contains("black")) {
                                      colorsSelected.add("black");
                                    } else if (value == false &&
                                        colorsSelected.contains("black")) {
                                      colorsSelected.remove("black");
                                    }
                                    print(colorsSelected);
                                  });
                                },
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.black),
                                checkColor: Colors.white,
                              ),
                              Checkbox(
                                value: blueColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    blueColor = value;
                                    if (value == true &&
                                        !colorsSelected.contains("blue")) {
                                      colorsSelected.add("blue");
                                    } else if (value == false &&
                                        colorsSelected.contains("blue")) {
                                      colorsSelected.remove("blue");
                                    }
                                    print(colorsSelected);
                                  });
                                },
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.blue),
                                checkColor: Colors.black,
                              ),
                              Checkbox(
                                value: whiteColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    whiteColor = value;
                                    if (value == true &&
                                        !colorsSelected.contains("white")) {
                                      colorsSelected.add("white");
                                    } else if (value == false &&
                                        colorsSelected.contains("white")) {
                                      colorsSelected.remove("white");
                                    }
                                    print(colorsSelected);
                                  });
                                },
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.white),
                                checkColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Available sizes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      const Text("XS"),
                                      Checkbox(
                                        value: xsSize,
                                        onChanged: (bool value) {
                                          setState(() {
                                            xsSize = value;
                                            if (value == true &&
                                                !sizesSelected.contains("XS")) {
                                              sizesSelected.add("XS");
                                            } else if (value == false &&
                                                sizesSelected.contains("XS")) {
                                              sizesSelected.remove("XS");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("S"),
                                      Checkbox(
                                        value: sSize,
                                        onChanged: (bool value) {
                                          setState(() {
                                            sSize = value;
                                            if (value == true &&
                                                !sizesSelected.contains("S")) {
                                              sizesSelected.add("S");
                                            } else if (value == false &&
                                                sizesSelected.contains("S")) {
                                              sizesSelected.remove("S");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("M"),
                                      Checkbox(
                                        value: mSize,
                                        onChanged: (bool value) {
                                          setState(() {
                                            mSize = value;
                                            if (value == true &&
                                                !sizesSelected.contains("M")) {
                                              sizesSelected.add("M");
                                            } else if (value == false &&
                                                sizesSelected.contains("M")) {
                                              sizesSelected.remove("M");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      const Text("L"),
                                      Checkbox(
                                        value: lSize,
                                        onChanged: (bool value) {
                                          setState(() {
                                            lSize = value;
                                            if (value == true &&
                                                !sizesSelected.contains("L")) {
                                              sizesSelected.add("L");
                                            } else if (value == false &&
                                                sizesSelected.contains("L")) {
                                              sizesSelected.remove("L");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("XL"),
                                      Checkbox(
                                        value: xlSize,
                                        onChanged: (bool value) {
                                          setState(() {
                                            xlSize = value;
                                            if (value == true &&
                                                !sizesSelected.contains("XL")) {
                                              sizesSelected.add("XL");
                                            } else if (value == false &&
                                                sizesSelected.contains("XL")) {
                                              sizesSelected.remove("XL");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("XXL"),
                                      Checkbox(
                                        value: xxlSize,
                                        onChanged: (bool value) {
                                          setState(() {
                                            xxlSize = value;
                                            if (value == true &&
                                                !sizesSelected
                                                    .contains("XXL")) {
                                              sizesSelected.add("XXL");
                                            } else if (value == false &&
                                                sizesSelected.contains("XXL")) {
                                              sizesSelected.remove("XXL");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      const Text("36"),
                                      Checkbox(
                                        value: f1Size,
                                        onChanged: (bool value) {
                                          setState(() {
                                            f1Size = value;
                                            if (value == true &&
                                                !sizesSelected.contains("36")) {
                                              sizesSelected.add("36");
                                            } else if (value == false &&
                                                sizesSelected.contains("36")) {
                                              sizesSelected.remove("36");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("37"),
                                      Checkbox(
                                        value: f2Size,
                                        onChanged: (bool value) {
                                          setState(() {
                                            f2Size = value;
                                            if (value == true &&
                                                !sizesSelected.contains("37")) {
                                              sizesSelected.add("37");
                                            } else if (value == false &&
                                                sizesSelected.contains("37")) {
                                              sizesSelected.remove("37");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("38"),
                                      Checkbox(
                                        value: f3Size,
                                        onChanged: (bool value) {
                                          setState(() {
                                            f3Size = value;
                                            if (value == true &&
                                                !sizesSelected.contains("38")) {
                                              sizesSelected.add("38");
                                            } else if (value == false &&
                                                sizesSelected.contains("38")) {
                                              sizesSelected.remove("38");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("39"),
                                      Checkbox(
                                        value: f4Size,
                                        onChanged: (bool value) {
                                          setState(() {
                                            f4Size = value;
                                            if (value == true &&
                                                !sizesSelected
                                                    .contains("39")) {
                                              sizesSelected.add("39");
                                            } else if (value == false &&
                                                sizesSelected.contains("39")) {
                                              sizesSelected.remove("39");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      const Text("40"),
                                      Checkbox(
                                        value: f5Size,
                                        onChanged: (bool value) {
                                          setState(() {
                                            f5Size = value;
                                            if (value == true &&
                                                !sizesSelected.contains("40")) {
                                              sizesSelected.add("40");
                                            } else if (value == false &&
                                                sizesSelected.contains("40")) {
                                              sizesSelected.remove("40");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("41"),
                                      Checkbox(
                                        value: f6Size,
                                        onChanged: (bool value) {
                                          setState(() {
                                            f6Size = value;
                                            if (value == true &&
                                                !sizesSelected.contains("41")) {
                                              sizesSelected.add("41");
                                            } else if (value == false &&
                                                sizesSelected.contains("41")) {
                                              sizesSelected.remove("41");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("42"),
                                      Checkbox(
                                        value: f7Size,
                                        onChanged: (bool value) {
                                          setState(() {
                                            f7Size = value;
                                            if (value == true &&
                                                !sizesSelected.contains("42")) {
                                              sizesSelected.add("42");
                                            } else if (value == false &&
                                                sizesSelected.contains("42")) {
                                              sizesSelected.remove("42");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("43"),
                                      Checkbox(
                                        value: f8Size,
                                        onChanged: (bool value) {
                                          setState(() {
                                            f8Size = value;
                                            if (value == true &&
                                                !sizesSelected
                                                    .contains("43")) {
                                              sizesSelected.add("43");
                                            } else if (value == false &&
                                                sizesSelected.contains("43")) {
                                              sizesSelected.remove("43");
                                            }
                                            print(sizesSelected);
                                          });
                                        },
                                        fillColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                        checkColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sale",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    activeColor: Colors.white,
                                      value: switchSale,
                                      onChanged: (bool value) {
                                        setState(() {
                                          switchSale = value;
                                        });
                                      }),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Featured",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    activeColor: Colors.white,
                                      value: switchFeatured,
                                      onChanged: (bool value) {
                                        setState(() {
                                          switchFeatured = value;
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Enter a product name with 15 characters at maximum',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 13,fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: productNameController,
                          decoration:
                              const InputDecoration(hintText: "Product name",),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'You must enter the product name';
                            } else if (value.length > 15) {
                              return 'Product name cant have more than 15 letters';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AwesomeDropDown(
                          dropDownList: categoriesDropDownList,
                          dropDownIcon: const Icon(Icons.category),
                          numOfListItemToShow: categoriesDropDownList.length,
                          selectedItem: categoryDropDownItem,
                          onDropDownItemClick: (clicked) {
                            setState(() {
                              categoryDropDownItem = clicked;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AwesomeDropDown(
                          dropDownList: brandsDropDownList,
                          dropDownIcon: const Icon(Icons.branding_watermark),
                          numOfListItemToShow: brandsDropDownList.length,
                          selectedItem: brandDropDownItem,
                          onDropDownItemClick: (clicked) {
                            setState(() {
                              brandDropDownItem = clicked;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: qtyController,
                          decoration:
                              const InputDecoration(hintText: "Quantity"),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) return 'You must enter quantity';
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(hintText: "Price"),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) return 'You must enter price';
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            validateAndUpload();
                          },
                          child: const Text(
                            "Add Product",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.deepOrange,
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
