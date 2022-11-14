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
    Future<void> _refreshProducts(BuildContext context) async {
      await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(true);
      print('Refresh User Products Screen');
    }

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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (context, productsData, _) => Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemBuilder: ((_, index) => Column(
                            children: [
                              UserProductItem(
                                id: productsData.items[index].id,
                                imageUrl: productsData.items[index].imageUrl,
                                title: productsData.items[index].title,
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                            ],
                          )),
                      itemCount: productsData.items.length,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
