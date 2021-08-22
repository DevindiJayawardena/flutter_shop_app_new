//The goal of this file is to output information about our orders.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;  //We use this bcz from this 'orders.dart' file, we don't need the OrderItem. We just only
                                  //needs the 'Orders' class.
import '../widgets/order_item.dart';


class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(  // we use a Scaffold here, since this will fill our page.
      appBar: AppBar(
        title: Text('Your Orders'),
      ),

      drawer: AppDrawer(),

      //Here we want to output information about our orders that were placed and each order then in turn contains information
      // about the different products that were part of that order.
      body: ListView.builder(  //since we don't know how many orders we will have.
        itemCount: orderData.orders.length, //this defines the amount of items that have to be built
        //This below 'itemBuilder' has to built single list items.
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}




