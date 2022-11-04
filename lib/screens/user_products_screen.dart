import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:my_shop_app/screens/edit_product_screen.dart';
import 'package:my_shop_app/widgets/app_drawer.dart';
import 'package:my_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: (() {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: ((_, index) => Column(
                children: [
                  UserProductItem(
                    id: products.items[index].id,
                    imageUrl: products.items[index].imageUrl,
                    title: products.items[index].title,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              )),
          itemCount: products.items.length,
        ),
      ),
    );
  }
}
