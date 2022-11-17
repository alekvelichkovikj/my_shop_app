import 'package:flutter/material.dart';
import 'package:my_shop_app/helpers/custom_route.dart';
import 'package:my_shop_app/providers/auth.dart';
import 'package:my_shop_app/screens/orders_screen.dart';
import 'package:my_shop_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = Provider.of<Auth>(context, listen: false).email;
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              AppBar(
                title: FittedBox(
                  child: Text(
                    'Hello $email',
                  ),
                ),
                automaticallyImplyLeading: false,
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.shop,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text('Shop'),
                onTap: () => Navigator.of(context).pushReplacementNamed('/'),
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(
                  Icons.payment,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text('Orders'),
                onTap: () =>
                    // Navigator.of(context)
                    //     .pushReplacementNamed(OrdersScreen.routeName),
                    Navigator.of(context).pushReplacement(CustomRoute(
                  builder: (context) => OrdersScreen(),
                )),
              ),
              Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text('Manage Products'),
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
