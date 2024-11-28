import 'package:f08_eshop_app/model/cart_provider.dart';
import 'package:f08_eshop_app/model/order_provider.dart';
import 'package:f08_eshop_app/model/user.dart';
import 'package:f08_eshop_app/model/user_provider.dart';
import 'package:f08_eshop_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    final cartProvider = Provider.of<Cart>(context);
    final cartItems = cartProvider.items.values.toList();

    final orderProvider = Provider.of<OrderProvider>(context);
    User? user = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (user == null) {
                        Navigator.of(context).pushNamed(AppRoutes.USER_LOGIN);
                        return;
                      }
                      await orderProvider.placeOrder(user.id, cartItems);
                      cartProvider.clear();
                      Navigator.pop(context);
                    },
                    child: Text('FINALIZAR COMPRA'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) {
                final item = cartItems[i];

                return Dismissible(
                  key: ValueKey(item.id),
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Tem certeza?'),
                        content: Text(
                          'Quer remover o item do carrinho?',
                        ),
                        actions: [
                          TextButton(
                            child: Text('Não'),
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Sim'),
                            onPressed: () {
                              Navigator.of(ctx).pop(true);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    cart.removeItem(item.id);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: FittedBox(
                              child: Text('\$${item.price.toStringAsFixed(2)}'),
                            ),
                          ),
                        ),
                        title: Text(item.title),
                        subtitle: Text(
                          'Total: \$${(item.price * item.quantity).toStringAsFixed(2)}',
                        ),
                        trailing: Container(
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    cart.updateQuantity(
                                        item.id, item.quantity - 1);
                                  } else {
                                    cart.removeItem(item.id);
                                  }
                                },
                              ),
                              Text('${item.quantity}x'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  cart.updateQuantity(
                                      item.id, item.quantity + 1);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
