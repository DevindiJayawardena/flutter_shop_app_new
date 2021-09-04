import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';


class CartScreen extends StatelessWidget{
  //This is a named route
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context){
    final cart = Provider.of<Cart>(context);  //This gives us access to the Cart. With this access we also setup our listener here.
                                                    // So we can listen to the changes in the Cart.
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),

      body : Column(
        children: <Widget>[
          Card( //This is a summary card
            margin: EdgeInsets.all(15),
            child: Padding(
              padding : EdgeInsets.all(8),
              child : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  //This 'Chip()' widget is little bit like our Badge(), Label(), an element with rounded corners to display information
                  Chip(
                    //In ths 'label', we are displaying the total sum of our items in the cart. We calculate it in the 'Cart' class/model.
                    //This needs total amount of the cart. In here we have to listen to changes in the cart.
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color : Theme.of(context).primaryTextTheme.title.color,),
                    ),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),

          SizedBox(height : 10),

          // Since a ListView directly inside a Column doesn't work,we use a Expanded widget, so we can take as much as space.
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length, // We use 'cart' here,bcz we have accessed to the 'Cart' in above this widget.
              itemBuilder: (ctx, i) => ci.CartItem( //here we want to return the widget that should be built for every item in the cart.
                //Here we are giving .value.toList() method in order to get rid of error occurred as 'The getter 'id' was called on null'.
                //Bcz by accessing only '.items' , we are trying to access to the empty map of items.
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],  //this key is the 'productId'
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}





class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}



class _OrderButtonState extends State<OrderButton>{
  var _isLoading = false;

  @override
  Widget build(BuildContext context){
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text(
        'ORDER NOW',
        //style : TextStyle(
          //fontSize: 12,
          //color: Theme.of(context).primaryColor,
        //),
      ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading) ? null : () async {
        setState(() {
          _isLoading = true;
        });
        //Here we set listen:false bcz we don't want to listen to this Orders provider, bcz we need not to listen to
        // the changes in Orders. We only just want to dispatch an action.
        await Provider.of<Orders>(context, listen : false,).addOrder(
          widget.cart.items.values.toList(), //here we pass a list of our cart item objects.
          widget.cart.totalAmount,
        );
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}