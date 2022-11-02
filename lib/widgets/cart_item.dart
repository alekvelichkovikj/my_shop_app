import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final double price;
  final int quantity;
  final String title;

  const CartItem({
    @required this.productId,
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Products>(context).findById(productId);
    // print(productImageUrl);

    return Dismissible(
      onDismissed: (_) => cart.removeItem(productId),
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.error,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        elevation: 6,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.fitWidth,
                // width: 60,
              ),
            ),
            title: Text(title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price: € ${(price).toStringAsFixed(2)}',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                Text('Total: € ${(price * quantity).toStringAsFixed(2)}'),
              ],
            ),
            trailing: Container(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: (quantity > 1)
                      ? () => {
                            Provider.of<Cart>(context, listen: false)
                                .addOrRemoveQuantity(productId, false)
                          }
                      : () => {
                            Provider.of<Cart>(context, listen: false)
                                .removeItem(productId)
                          },
                  icon: Icon(
                    Icons.remove_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(quantity.toString()),
                IconButton(
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .addOrRemoveQuantity(productId, true);
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
