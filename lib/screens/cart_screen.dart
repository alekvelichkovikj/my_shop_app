import 'package:flutter/material.dart';
import 'package:my_shop_app/providers/cart.dart' show Cart;
import 'package:my_shop_app/providers/orders.dart';
import 'package:my_shop_app/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '€ ${cart.totalSum.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          cart.items.length == 0
              ? Text(
                  'You cart is empty.',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemBuilder: ((context, index) => CartItem(
                          productId: cart.items.keys.toList()[index],
                          id: cart.items.values.toList()[index].id,
                          price: cart.items.values.toList()[index].price,
                          quantity: cart.items.values.toList()[index].quantity,
                          title: cart.items.values.toList()[index].title,
                        )),
                    itemCount: cart.items.length,
                  ),
                )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (widget.cart.totalSum <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalSum,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCartItems();
            },
      child: Row(
        children: [
          _isLoading
              ? CircularProgressIndicator()
              : const Text(
                  'Order Now',
                ),
          SizedBox(
            width: 5,
          ),
          Icon(Icons.delivery_dining)
        ],
      ),
    );
  }
}
