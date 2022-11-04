import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:my_shop_app/screens/edit_product_screen.dart';
import 'package:my_shop_app/widgets/two_button_alert_dialog.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  const UserProductItem({
    Key key,
    @required this.imageUrl,
    @required this.title,
    @required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        // height: 300,
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: (() {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              }),
              icon: Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: (() {
                showDialog(
                    context: context,
                    builder: (context) => TwoButtonAlertDialog(
                          content: 'Do you want to delete this product?',
                          firstButtonOnTap: () {
                            Provider.of<Products>(context, listen: false)
                                .deleteProduct(id);
                            Navigator.of(context).pop();
                          },
                          firstButtonText: 'Confirm',
                          secondButtonOnTap: () {
                            Navigator.of(context).pop();
                          },
                          secondButtonText: 'Cancel',
                          title: 'Are you sure',
                        ));
              }),
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
