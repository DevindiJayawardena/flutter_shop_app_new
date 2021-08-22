import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';



void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //This 'ChangeNotifierProvider' allows us to register a class to which we can then listen in child widgets & whenever that class
    //updates the widgets which are listening, and only these not all child widgets, only child widgets that are listening will rebuild
    // So the 'create' method of this 'ChangeNotifierProvider', should return a new instance of our provided class. Not a widget.
    return MultiProvider(
      //So we are adding these 2 below providers to the entire child widget tree down there.
      providers: [
        //BY PROVIDING THIS WE CAN LISTEN TO 'PRODUCTS' ANY WHERE IN THE APPLICATION
        ChangeNotifierProvider(      //return ChangeNotifierProvider.value(
          // we're proving our 'Products' object in here, which manages our list of products with 'ChangeNotifierProvider'.
          create : (ctx) => Products(),
          //value: Products(),
        ),

        //BY PROVIDING THIS WE CAN LISTEN TO 'CART' ANY WHERE IN THE APPLICATION
        ChangeNotifierProvider(      //return ChangeNotifierProvider.value(
          // we're proving our 'Cart' object in here, which manages our list of products with 'ChangeNotifierProvider'.
          create : (ctx) => Cart(),
          //value: Cart(),
        ),

        //BY PROVIDING THIS WE CAN LISTEN TO 'ORDERS' ANY WHERE IN THE APPLICATION
        //the first place where i want to tap into my provided orders object is in the cart_screen.dart file when we press the 'ORDER NOW'.
        ChangeNotifierProvider(
          // we're proving our 'Orders' object in here, which manages our list of products with 'ChangeNotifierProvider'.
          create: (ctx) => Orders(),
          //value: Orders(),
        ),
      ],

      child : MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.indigo,  //purple
          accentColor: Colors.blue,  //deepOrange
          errorColor: Colors.red,
          fontFamily: 'Lato',//main font in the application
        ),
        home: ProductsOverviewScreen(),
        routes: {
          //Below is how to Registering a widget as a named route here
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}









