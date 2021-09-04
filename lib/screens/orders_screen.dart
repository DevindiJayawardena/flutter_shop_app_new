//The goal of this file is to output information about our orders.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;  //We use this bcz from this 'orders.dart' file, we don't need the OrderItem. We just only
                                  //needs the 'Orders' class.
import '../widgets/order_item.dart';


class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}


class _OrdersScreenState extends State<OrdersScreen>{
  Future _ordersFuture;


  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen : false).fetchAndSetOrders();
  }


  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print('Building orders!');
    //we are not setting up this listener here bcz we'll get an infinite loop of orders.
    //final orderData = Provider.of<Orders>(context);

    return Scaffold(  // we use a Scaffold here, since this will fill our page.
      appBar: AppBar(
        title: Text('Your Orders'),
      ),

      drawer: AppDrawer(),

      //Here we want to output information about our orders that were placed and each order then in turn contains information
      // about the different products that were part of that order.
      body: FutureBuilder(
        future : _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child : CircularProgressIndicator());
          }
          else{
            if (dataSnapshot.error != null){
              //...
              //DO ERROR HANDLING STUFF HERE
              return Center(child : Text('An error occurred!'));
            }
            else{
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(  //since we don't know how many orders we will have.
                  itemCount: orderData.orders.length, //this defines the amount of items that have to be built
                  //This below 'itemBuilder' has to built single list items.
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}




