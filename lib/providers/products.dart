import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Lamp',
      description: 'Light up any room you want.',
      price: 39.90,
      imageUrl:
          'https://media.istockphoto.com/photos/red-table-lamp-isolated-on-white-picture-id1060750934?k=20&m=1060750934&s=612x612&w=0&h=yAXYVNkIn1XzKtpPBXf1SW6AX7Q07kqd76QSqhg9sdo=',
    ),
    Product(
      id: 'p6',
      title: 'Lap-Top',
      description: 'Electrify your productivity with the new M1 Proccessor!',
      price: 999.59,
      imageUrl:
          'https://techcrunch.com/wp-content/uploads/2020/11/2020-11-16-074520097.jpg',
    ),
    Product(
      id: 'p7',
      title: 'Sunglasses',
      description: 'No sun will ever hurt your eyes again!',
      price: 139.19,
      imageUrl:
          'https://images.ray-ban.com/is/image/RayBan/805289154587__STD__shad__qt.png?impolicy=RB_Product&width=1024&bgc=%23f2f2f2',
    ),
    Product(
      id: 'p8',
      title: 'Trucker Hat',
      description: 'Cool and stylish!',
      price: 40.50,
      imageUrl:
          'https://www.alpinaction.it/9582-atmn_large/patagonia-fitz-roy-horizons-trucker-hat.jpg',
    ),
  ];

  // MOVING FILTERING LOGIC TO A WIDGET INSTEAD OF STATE WIDE PROVIDER
  // var _showFavoritesOnly = false;

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void addProduct() {
    notifyListeners();
  }
}
