import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:my_shop_app/providers/orders.dart' as ord;
import 'package:provider/provider.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  final String orderId;

  const OrderItem({
    @required this.order,
    @required this.orderId,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('€ ${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: (() {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    }),
                  ),
                  IconButton(
                      onPressed: (() async {
                        try {
                          await Provider.of<ord.Orders>(context, listen: false)
                              .deleteOrder(widget.orderId);

                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Order removed successfully',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } catch (_) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Delete failed',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      }),
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ))
                ],
              ),
            ),
          ),
          if (_expanded)
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: min(
                  (widget.order.products.length * 20.0 + 30.0),
                  100,
                ),
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    final product = widget.order.products[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${product.quantity} x ${product.price}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    );
                  }),
                  itemCount: widget.order.products.length,
                ),
              ),
            )
        ],
      ),
    );
  }
}
