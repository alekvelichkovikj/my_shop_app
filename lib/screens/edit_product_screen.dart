import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shop_app/providers/product.dart';

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

  @override
  // void initState() {
  //   _imageUrlControler.addListener(_updateImageUrl);
  //   super.initState();
  // }

  @override
  void dispose() {
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlControler.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.title);
    print(_editedProduct.price);
    _form.currentState.reset();
    _imageUrlControler.clear();
    setState(() {});
  }

  void previewImage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
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
                      id: null,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      title: newValue,
                    );
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                ),
                TextFormField(
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
                      id: null,
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
                      id: null,
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
                        decoration: InputDecoration(labelText: 'Image URL'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a URL to your image';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Provide a valid URL please';
                          }
                          if (!value.endsWith('.jpg') &&
                              !value.endsWith('.png') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter a valid Image URL';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlControler,
                        focusNode: _imageUrlFocusNode,
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            id: null,
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
