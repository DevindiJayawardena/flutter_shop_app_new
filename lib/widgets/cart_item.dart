//This is the item that we want to build in our cart_screen. After the summary card.
//This file defines how should a cart item looks like.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;


  CartItem(this.id, this.productId, this.price, this.quantity, this.title,);


  @override
  Widget build(BuildContext context) {
    return Dismissible( //From this 'Dismissible' widget,it allows us to remove an entire element. (swipe & remove in here)
      key: ValueKey(id),
      //ID of our cart item.
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size : 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right : 20),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15,),
      ),

      direction: DismissDirection.endToStart,

      confirmDismiss: (direction){
        return showDialog(
          context: context,
          builder : (ctx) => AlertDialog(
            title: Text(
              'Are you sure?',
              style : TextStyle(color: Theme.of(context).primaryColorDark),
            ),
            content: Text(
              'Do you want to remove the item from the cart?',
            ),
            backgroundColor: Colors.indigo[100],
            actions: <Widget>[
              TextButton(
                child: Text(
                  'No',
                  style : TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(false); //here we give false bcz we don't want to go ahead and remove that item.
                },
              ),
              TextButton(
                child: Text(
                  'Yes',
                  style : TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(true); // but here we give true bcz we want to go ahead and remove that item.
                },
              ),
            ],
          ),
        );
      },

      //Now we have to define what happens when its dismissed by visually bcz it affects to our data. (here we use 'onDismissed' parameter)
      onDismissed: (direction) {
        //Since we have one direction, we can go right ahead & remove the item from our cart. We set listen: false here, bcz we don't want
        // to listen to the changes in 'Cart' here.
        Provider.of<Cart>(context, listen: false,).removeItem(productId);
      },

      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15,),
        child : Padding(
          padding : EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child : Padding(
                padding: EdgeInsets.all(4),
                child : FittedBox(
                  child : Text('\$$price'),
                ),
              ),
            ),
            title: Text(title), //Title of the product
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}



