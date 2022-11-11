import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/auth.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:my_shop_app/providers/orders.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:my_shop_app/screens/auth_screen.dart';
import 'package:my_shop_app/screens/cart_screen.dart';
import 'package:my_shop_app/screens/edit_product_screen.dart';
import 'package:my_shop_app/screens/orders_screen.dart';
import 'package:my_shop_app/screens/user_products_screen.dart';
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
            create: ((context) => Auth()),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', []),
            update: (context, auth, previous) =>
                Products(auth.token, previous.items),
          ),
          ChangeNotifierProvider(
            create: ((context) => Cart()),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: ((_) => Orders('', [])),
            update: (context, auth, previous) =>
                Orders(auth.token, previous.orders),
          ),
        ],
        child: Consumer<Auth>(
            builder: ((context, auth, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'MyShop',
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                            .copyWith(secondary: Colors.amber),
                    fontFamily: 'Lato',
                  ),
                  home: auth.isAuthenticated
                      ? ProductsOverviewScreen()
                      : AuthScreen(),
                  routes: {
                    ProductDetailScreen.routeName: (context) =>
                        ProductDetailScreen(),
                    CartScreen.routeName: ((context) => CartScreen()),
                    OrdersScreen.routeName: ((context) => OrdersScreen()),
                    UserProductsScreen.routeName: ((context) =>
                        UserProductsScreen()),
                    EditProductScreen.routeName: ((context) =>
                        EditProductScreen()),
                    // ProductsOverviewScreen.routeName: ((context) => ProductsOverviewScreen()),
                  },
                ))));
  }
}
