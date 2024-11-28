import 'package:f08_eshop_app/model/order.dart';
import 'package:f08_eshop_app/model/order_provider.dart';
import 'package:f08_eshop_app/model/user.dart';
import 'package:f08_eshop_app/model/user_provider.dart';
import 'package:f08_eshop_app/pages/order_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).currentUser;
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Meus Pedidos')),
      body: FutureBuilder<List<Order>>(
        future: orderProvider.fetchOrders(user?.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar pedidos.'));
          } else if (snapshot.hasData) {
            final orders = snapshot.data!;
            if (orders.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum pedido encontrado.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return OrdersListView(orders: orders);
          } else {
            return Center(child: Text('Erro desconhecido.'));
          }
        },
      ),
    );
  }
}

class OrdersListView extends StatelessWidget {
  final List<Order> orders;

  const OrdersListView({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text('Pedido #${order.id}'),
            subtitle:
                Text('Total: R\$ ${order.totalAmount.toStringAsFixed(2)}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(order),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
