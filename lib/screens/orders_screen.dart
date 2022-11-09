import 'package:flutter/material.dart';
import 'package:my_shop_app/widgets/app_drawer.dart';
import 'package:my_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/providers/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshOrders(BuildContext context) async {
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      print('Refresh Orders Screen');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: FutureBuilder(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                return Center(child: Text('You have an error'));
              } else {
                return Consumer<Orders>(
                  builder: ((context, orderData, child) {
                    return orderData.orders.length == 0
                        ? Container(
                            padding: EdgeInsets.all(20),
                            alignment: Alignment.topCenter,
                            child: Text(
                              'You have no orders at the moment!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: ((context, index) => OrderItem(
                                  order: orderData.orders[index],
                                  orderId: orderData.orders[index].id,
                                )),
                            itemCount: orderData.orders.length,
                          );
                  }),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
