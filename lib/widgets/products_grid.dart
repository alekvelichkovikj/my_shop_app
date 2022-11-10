import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:provider/provider.dart';

import 'package:my_shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;

  const ProductsGrid({this.showOnlyFavorites});

  @override
  Widget build(BuildContext context) {
    final products = showOnlyFavorites
        ? Provider.of<Products>(context).favoriteItems
        : Provider.of<Products>(context).items;

    return products.length == 0
        ? Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topCenter,
            child: Text(
              'You haven\'t added any products to your shop yet.',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: ((context, index) => ChangeNotifierProvider.value(
                  value: products[index],
                  child: ProductItem(),
                )),
          );
  }
}
