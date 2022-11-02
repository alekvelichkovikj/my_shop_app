import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:my_shop_app/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import 'package:my_shop_app/screens/product_detail_screen.dart';
import 'package:my_shop_app/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: ((context) => Cart()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: Colors.amber),
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: ((context) => CartScreen())
        },
      ),
    );
  }
}
