import 'package:flutter/material.dart';
import 'package:my_shop_app/widgets/app_drawer.dart';
import 'package:my_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';
import 'package:my_shop_app/providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
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
                              )),
                          itemCount: orderData.orders.length,
                        );
                }),
              );
            }
          }
        },
      ),
    );
  }
}
