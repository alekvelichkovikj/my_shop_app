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

    return GridView.builder(
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
