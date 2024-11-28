import 'package:f08_eshop_app/model/cart_provider.dart';
import 'package:f08_eshop_app/model/order_provider.dart';
import 'package:f08_eshop_app/model/user_provider.dart';
import 'package:f08_eshop_app/pages/login_user_page.dart';
import 'package:f08_eshop_app/pages/orders_page.dart';
import 'package:f08_eshop_app/pages/product_detail_page.dart';
import 'package:f08_eshop_app/pages/product_form_page.dart';
import 'package:f08_eshop_app/pages/products_cart_page.dart';
import 'package:f08_eshop_app/pages/products_manager_page.dart';
import 'package:f08_eshop_app/pages/products_overview_page.dart';
import 'package:f08_eshop_app/pages/register_user_page.dart';
import 'package:f08_eshop_app/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductList()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider())
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ThemeData().copyWith().colorScheme.copyWith(
                primary: Colors.pink, secondary: Colors.orangeAccent)),
        home: ProductsOverviewPage(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
          AppRoutes.PRODUCT_FORM: (context) => const ProductFormPage(),
          AppRoutes.PRODUCT_CART: (context) => CartPage(),
          AppRoutes.PRODUCT_MANAGER: (context) => ProductManagerPage(),
          AppRoutes.USER_REGISTER: (context) => RegisterPage(),
          AppRoutes.USER_LOGIN: (context) => LoginPage(),
          AppRoutes.HOME: (context) => ProductsOverviewPage(),
          AppRoutes.ORDERS_PAGE: (context) => OrdersPage()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
