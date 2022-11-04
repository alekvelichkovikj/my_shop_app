import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:my_shop_app/widgets/two_button_alert_dialog.dart';
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
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: ((context) => TwoButtonAlertDialog(
                  content: 'Do you want to delete the whole item?',
                  firstButtonOnTap: () => Navigator.of(context).pop(true),
                  firstButtonText: 'Confirm',
                  secondButtonOnTap: () => Navigator.of(context).pop(false),
                  secondButtonText: 'Cancel',
                  title: 'Are you sure?',
                )));
      },
      onDismissed: (_) {
        cart.removeItem(productId);
      },
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
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(product.imageUrl),
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
