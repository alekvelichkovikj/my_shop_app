import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shop_app/providers/product.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlControler = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final String dummyImage =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2BQuCIVTcP_tjmlUTdFFQSWRii-U4p3X4oQ&usqp=CAU';

  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      print(productId);
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlControler.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlControler.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    setState(() {
      isLoading = true;
    });
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return setState(() {
        isLoading = false;
      });
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: ((context) => AlertDialog(
                title: Text('An error occured'),
                content: Text('Someting went wrong'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Okay'),
                  )
                ],
              )),
        );
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  void previewImage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedProduct.id == null ? 'Add Product' : 'Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: newValue,
                          );
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater then 0';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
                          ),
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) => newValue.copyWith(
                              text: newValue.text.replaceAll(',', '.'),
                            ),
                          ),
                        ],
                        focusNode: _priceFocusNode,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(newValue),
                            title: _editedProduct.title,
                          );
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a short description';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long';
                          }
                          return null;
                        },
                        minLines: 1,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            description: newValue,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: _editedProduct.title,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 20, right: 25),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlControler.text.isEmpty
                                ? FittedBox(
                                    child: Image.network(
                                      dummyImage,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlControler.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a URL to your image';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Provide a valid URL please';
                                }

                                return null;
                              },
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlControler,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  description: _editedProduct.description,
                                  imageUrl: newValue,
                                  price: _editedProduct.price,
                                  title: _editedProduct.title,
                                );
                              },
                              onEditingComplete: () => previewImage(),
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.zero,
                            onPressed: previewImage,
                            icon: Icon(
                              Icons.preview,
                              size: 28,
                              color: Color.fromRGBO(142, 194, 112, 1),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
