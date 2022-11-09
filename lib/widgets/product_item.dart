import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:my_shop_app/providers/product.dart';
import 'package:my_shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    // final cartItems = cart.items;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              product.toggleFavorite();
            },
            icon: Icon(
              !product.isFavorite ? Icons.favorite_outline : Icons.favorite,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart'),
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: (() => cart.removeSingleCartItem(product.id)),
                ),
              ));
            },
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          title: Text(
            product.title,
            style: TextStyle(
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
