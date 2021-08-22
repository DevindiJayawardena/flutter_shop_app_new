import 'package:flutter/material.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';


class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Dev\'s  Shopping'),
            automaticallyImplyLeading: false, //This will never add a back button
          ),

          Divider(), //This is a nice little horizontal line

          ListTile(  //This is an entry in that drawer
            leading : Icon(
              Icons.shop,
              color: Theme.of(context).primaryColor,
            ),  //This should lead us back to our ProductsOverview page.
            title : Text(
              'Shop',
              style: TextStyle(fontSize: 17,),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');  //This will go to the root route (to our home page)
            },
          ),

          Divider(), //This is a nice little horizontal line

          ListTile(  //This is an entry in that drawer
            leading : Icon(  //This should lead us to our orders page.
              Icons.payment,
              color: Theme.of(context).primaryColor,
            ),
            title : Text(
              'Orders' ,
              style: TextStyle(fontSize: 17,),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);  //This will go to the OrdersScreen page
            },
          ),

          Divider(), //This is a nice little horizontal line

          ListTile(  //This is an entry in that drawer
            leading : Icon(  //This should lead us to our orders page.
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            title : Text(
              'Manage Products' ,
              style: TextStyle(fontSize: 17,),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);  //This will go to the OrdersScreen page
            },
          ),

        ],
      ),
    );
  }
}