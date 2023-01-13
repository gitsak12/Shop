import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageTextController = TextEditingController();
  final imageFocusNode = FocusNode();
  final form = GlobalKey<FormState>();
  var editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  // gives us a way to interact with the widget in our
  @override
  void initState() {
    imageFocusNode.addListener(updateListner);
    super.initState();
  }

  bool isInit = true;
  var isLoading = false;

  var initVaues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    var productId = ModalRoute.of(context)?.settings.arguments;
    if (isInit) {
      if (productId != null) {
        editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        initVaues = {
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price.toString(),
          'imageUrl': '',
        };
        imageTextController.text = editedProduct.imageUrl;
      }
    }

    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    priceFocusNode.dispose();
    descriptionFocusNode.dispose(); // to avoid memory leaks
    imageTextController.dispose();
    imageFocusNode.dispose();
    imageFocusNode.removeListener(updateListner);
    super.dispose();
  }

  void updateListner() {
    if (!imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    setState(() {
      isLoading = true;
    });
    final valid = form.currentState!.validate();
    if (!valid) {
      return;
    }
    form.currentState!.save();
    if (editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Color.fromARGB(225, 159, 121, 224),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                title: Text('Error'),
                content: Text('Something went wrong'),
                actions: [
                  TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close')),
                ],
              );
            });
      }

    }

    // allows you to store it in a global map ,, abb jo bhi text field mai gya woh sbb de deta yeh onSaved ko
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: saveForm,
              icon: const Icon(
                Icons.save,
                color: Colors.black,
              )),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : Form(
              key: form,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initVaues['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            priceFocusNode); // this tells when the users next or submit field
                        // then it will go to which textfield
                      },
                      validator: (value) {
                        /******/
                        if (value!.isEmpty) {
                          return 'Please Provide a value';
                        }
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            isFavourite: editedProduct.isFavourite,
                            id: editedProduct.id,
                            title: value!,
                            description: editedProduct.description,
                            price: editedProduct.price,
                            imageUrl: editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: initVaues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid Price';
                        }
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            isFavourite: editedProduct.isFavourite,
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            price: double.parse(value!),
                            imageUrl: editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: initVaues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      focusNode: descriptionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(imageFocusNode);
                      },
                      validator: (value) {
                        /******/
                        if (value!.isEmpty) {
                          return 'Please Provide Description';
                        }
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            isFavourite: editedProduct.isFavourite,
                            id: editedProduct.id,
                            title: editedProduct.title,
                            description: value!,
                            price: editedProduct.price,
                            imageUrl: editedProduct.imageUrl);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 80,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: imageTextController.text.isEmpty
                              ? Center(child: Text('Enter A Url'))
                              : FittedBox(
                                  child:
                                      Image.network(imageTextController.text),
                                  fit: BoxFit.fill,
                                ),
                        ),
                        Expanded(
                          // takes the given width,
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: imageTextController,
                            focusNode: imageFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              saveForm();
                            },
                            onSaved: (value) {
                              editedProduct = Product(
                                isFavourite: editedProduct.isFavourite,
                                id: editedProduct.id,
                                title: editedProduct.title,
                                description: editedProduct.description,
                                price: editedProduct.price,
                                imageUrl: value!,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
