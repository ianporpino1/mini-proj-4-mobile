import 'package:f08_eshop_app/components/product_grid.dart';
import 'package:f08_eshop_app/model/cart_provider.dart';
import 'package:f08_eshop_app/model/product_list.dart';
import 'package:f08_eshop_app/model/user_provider.dart';
import 'package:f08_eshop_app/pages/products_cart_page.dart';
import 'package:f08_eshop_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorite, All }

class ProductsOverviewPage extends StatefulWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductList>(context);
    final cartProvider = Provider.of<Cart>(context);
    final userProvider = Provider.of<UserProvider>(context);

    int totalItems =
        cartProvider.items.values.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Minha Loja'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_MANAGER);
            },
            icon: Icon(Icons.list),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  productProvider.showFavoriteOnly();
                  _showOnlyFavorites = true;
                } else {
                  productProvider.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CartPage()),
                  );
                },
                icon: Icon(Icons.shopping_cart),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    totalItems.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              if (userProvider.isLoggedIn) {
                Navigator.of(context).pushNamed(AppRoutes.ORDERS_PAGE);
              } else {
                Navigator.of(context).pushNamed(AppRoutes.USER_LOGIN);
              }
            },
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}
