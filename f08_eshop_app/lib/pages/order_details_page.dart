import 'package:f08_eshop_app/model/order.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  OrderDetailsPage(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pedido #${order.id}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Data: ${order.date.toLocal()}'),
            Text('Total: R\$ ${order.totalAmount}'),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text('R\$ ${item.price} x ${item.quantity}'),
                    trailing: Text('R\$ ${item.price * item.quantity}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
