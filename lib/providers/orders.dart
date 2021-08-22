import 'package:flutter/foundation.dart';
import './cart.dart';


//This defines how an order should looks like
class OrderItem{
  final String id; //order id
  final double amount; //total amount to the quantity of items time the price.
  //In order to say which products were ordered.. (actually we are getting here our cart items..)
  final List<CartItem> products;
  final DateTime dateTime; //Time that the order was placed.


  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}


//BEFORE USING THIS 'Orders' CLASS, WE NEED TO PROVIDE THIS CLASS. BECAUSE I PLAN ON USING THAT IN DIFFERENT PLACES IN THE APP, EITHER
// TO DISPATCH ACTIONS LIKE ADD ANEW ORDER, OR TO LISTEN TO MY ORDERS OR FETCH MY ORDERS. SO WE SHOULD PROVIDE IT IN THE main.dart FILE.


//So in this 'Orders' class we now have a list of such Order Items.
//Here we use 'ChangeNotifier' bcz we will provide this & we might have places in our app where we want to listen to changes.
class Orders with ChangeNotifier {

  List<OrderItem> _orders = [];


  //This is a getter method of returning our order items.
  List<OrderItem> get orders {
    //This returns a copy by creating a new list with square brackets & then using the spread operator to take some items and move
    // them into this new list. We are doing this so that from outside of this class, we can't edit orders.
    return [..._orders];
  }


  //This method executes, when the 'ORDER NOW' button is clicked in the cart_screen.dart file
  //THE IDEA OF THIS 'addOrder()' METHOD IS TO ADD ALL THE CONTENT OF THE CART, INTO ONE ORDER. So we should get a list of cart items
  // as an argument. And also the total value. With that, we can add this as a new order.
  void addOrder(List<CartItem> cartProducts, double total) {
    //Here 0 is, to add this new order as the first element of the list.
    // the element to be added to the _orders list is 'OrderItem'
    _orders.insert(0, OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
    ),);
    notifyListeners(); //So by using this, any places in our app which depend on orders are now updated.
  }
}