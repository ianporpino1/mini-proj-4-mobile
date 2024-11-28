import 'package:f08_eshop_app/model/cart_provider.dart';
import 'package:f08_eshop_app/model/product_list.dart';
import 'package:f08_eshop_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //PEGANDO CONTEUDO PELO PROVIDER
    //
    final product = context.watch<Product>();
    //final productProvider = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      //corta de forma arredondada o elemento de acordo com o BorderRaius
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              //adicionando metodo ao clique do botão
              product.toggleFavorite();
            },
            //icon: Icon(Icons.favorite),
            //pegando icone se for favorito ou não
            icon: Consumer<Product>(
              builder: (context, product, child) => Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
            //isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  cart.addItem(product.id, product.title, product.price);
                },
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).colorScheme.secondary,
              ),
              IconButton(
                  onPressed: () =>
                      Provider.of<ProductList>(context, listen: false)
                          .removeProduct(product),
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.secondary),
            ],
          ),
        ),
      ),
    );
  }
}
