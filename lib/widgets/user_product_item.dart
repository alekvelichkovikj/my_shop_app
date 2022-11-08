import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:my_shop_app/screens/edit_product_screen.dart';
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Product deleted',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } catch (_) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting failed',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
