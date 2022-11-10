import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:my_shop_app/providers/orders.dart' as ord;
import 'package:my_shop_app/widgets/two_button_alert_dialog.dart';
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
    return Dismissible(
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: ((context) => TwoButtonAlertDialog(
                title: 'Alert',
                content: 'Do you want to remove this order from your history?',
                firstButtonText: 'Confirm',
                firstButtonOnTap: () => Navigator.of(context).pop(true),
                secondButtonText: 'Cancel',
                secondButtonOnTap: () => Navigator.of(context).pop(false),
              )),
        );
      },
      onDismissed: (_) async {
        try {
          await Provider.of<ord.Orders>(context, listen: false)
              .deleteOrder(widget.orderId);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                'Order Removed successfully',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } catch (_) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                'Something went wrong, try again later please',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      key: ValueKey(widget.orderId),
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.error,
        ),
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('€ ${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
              trailing: Container(
                child: IconButton(
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
      ),
    );
  }
}
