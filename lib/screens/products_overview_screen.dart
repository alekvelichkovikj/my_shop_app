import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart.dart';
import 'package:my_shop_app/providers/products.dart';
import 'package:my_shop_app/screens/cart_screen.dart';
import 'package:my_shop_app/widgets/app_drawer.dart';
import 'package:my_shop_app/widgets/badge.dart';
import 'package:my_shop_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshProducts(BuildContext context) async {
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
      print('Refresh Products Overview Screen');
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: ((_, cart, child) => Badge(
                    color: Theme.of(context).colorScheme.error,
                    child: child,
                    value: cart.itemCount.toString(),
                  )),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CartScreen.routeName,
                  );
                },
                icon: Icon(Icons.shopping_cart),
              ),
            )
          ],
          title: Text('MyShop'),
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ProductsGrid(
                  showOnlyFavorites: _showOnlyFavorites,
                ),
        ));
  }
}
