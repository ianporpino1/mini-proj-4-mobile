import 'package:f08_eshop_app/model/product_list.dart';
import 'package:f08_eshop_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<ProductList>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: productList.fetchProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os produtos.'));
          } else {
            return ListView.builder(
              itemCount: productList.items.length,
              itemBuilder: (ctx, index) {
                final product = productList.items[index];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(product.imageUrl),
                    ),
                    title: Text(product.title),
                    subtitle: Text(product.description),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.PRODUCT_FORM,
                                arguments: product,
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Confirmação'),
                                  content: Text(
                                      'Tem certeza que deseja excluir o produto?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancelar'),
                                      onPressed: () => Navigator.of(ctx).pop(),
                                    ),
                                    TextButton(
                                      child: Text('Excluir'),
                                      onPressed: () {
                                        productList.removeProduct(product);
                                        Navigator.of(ctx).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
