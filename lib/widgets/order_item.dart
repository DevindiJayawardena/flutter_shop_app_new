//This is the item that we want to build in our orders_screen.
//This file defines how should a order item looks like.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';  //this gives us the usage of 'min' function

class OrderItem extends StatefulWidget {
  final ord.OrderItem order; //In here the 'OrderItem' is from the '../providers/orders.dart' class.

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}



class _OrderItemState extends State<OrderItem>{
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    //Order will be in an Card widget
    return Card(
      margin: EdgeInsets.all(10),
      child : Column(
        children: <Widget>[
          ListTile(
            title: Text( //This Text will define that the order amount of that particular order
              '\$${widget.order.amount.toStringAsFixed(2)}',
              style : TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy  hh:mm').format(widget.order.dateTime),
              style : TextStyle(
                color : Theme.of(context).primaryColorLight,
              ),
            ),
            trailing: IconButton(  //by this trailing IconButton, we can press to expand this order.
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more, color : Theme.of(context).primaryColor,),
              onPressed: () {
                setState(() { //we use setState bcz here we want to update the UI by expanding the order details.
                  _expanded = !_expanded; // set this _expanded into what its currently not.
                });
              },
            ),
          ),
          if(_expanded)Container(
            padding : EdgeInsets.symmetric(horizontal: 15, vertical : 3,),
            height: min(widget.order.products.length * 20.0 + 20, 120),
            child : ListView(
              children: widget.order.products.map((prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    prod.title,
                    style : TextStyle(
                      fontSize: 16,
                      color : Colors.black87,
                    ),
                  ),
                  Text(
                    '${prod.quantity}  x  \$${prod.price}',
                    style : TextStyle(
                      fontSize: 16,
                      color : Colors.grey,
                    ),
                  ),
                ],
              ),).toList(),
            ),
          ),
        ],
      ),
    );
  }
}



