
import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //to convert our map to json


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



  Future<void> fetchAndSetOrders() async{
    final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);  // 'response' is an object here
    //print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    //here in this 'extractedData', the data will be stored which we have printed above
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null){ //we put this here to avoid from the error called 'foreach on null' whenever there is no orders in the server.
      return; //if there is no any orders in the server, then nothing will be returned to our app.
      //so this below codes will not run if the extractedData is null.
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((item) =>
              CartItem(
                id : item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title'],
              )).toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList(); //this is done to view the recent orders at first. (to the reverse order)
    notifyListeners();
  }




  //This method executes, when the 'ORDER NOW' button is clicked in the cart_screen.dart file
  //THE IDEA OF THIS 'addOrder()' METHOD IS TO ADD ALL THE CONTENT OF THE CART, INTO ONE ORDER. So we should get a list of cart items
  // as an argument. And also the total value. With that, we can add this as a new order.
  Future<void> addOrder(List<CartItem> cartProducts, double total) async{
    final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/orders.json');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({ //this is a map
        // In this map, we want to store all the data which should be stored in the server in the end.
        'amount' : total,
        'dateTime' : timestamp.toIso8601String(),
        'products' : cartProducts.map((cp) => { //'cp' means on every cart product
          //then we want to return a new map. which means, convert our objects based on 'CartItem' into maps.
          'id' : cp.id,
          'title' : cp.title,
          'quantity' : cp.quantity,
          'price' : cp.price,
        }).toList(),
      }),
    );
    //SO BY THE BELOW CODE,WE ADD OUR ORDER LOCALLY.
    //Here 0 is, to add this new order as the first element of the list.
    // the element to be added to the _orders list is 'OrderItem'
    _orders.insert(0, OrderItem(
        id: json.decode(response.body)['name'], //this is the auto generated id for the order by Firebase.
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
    ),);
    notifyListeners(); //So by using this, any places in our app which depend on orders are now updated.
  }

}










