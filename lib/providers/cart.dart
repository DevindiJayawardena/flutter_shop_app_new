import 'package:flutter/foundation.dart';

class CartItem{
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,  //This is the ID of the cart item, not the ID of the product that this item belongs to.
    @required this.title,
    @required this.quantity,
    @required this.price
  });
}


//Now the cart items can be managed here in the Cart class.
class Cart with ChangeNotifier {
  //I want to map every cart item to the ID of the product it belongs to. So in here we want to manage my cart items that we have
  //in a cart in a map where the key is the Product ID.
  // In this map, the keys are strings bcz our product ID is a string in the Products class. And the value will be the type of CartItem.
  //This '_items' are already having in the cart.
  Map<String, CartItem> _items = {}; //Empty map initially


  //Now we want to be able to get our items that are in the cart, so we can add a getter where we get that same map above.
  Map<String, CartItem> get items{
    return {..._items}; //Here we use spread operator to pull out the key value pairs from above _items map & add it to a new map to
                                // return a copy.
  }


  //This getter returns us an integer which tells us how many items are there in the cart.
  int get itemCount {
    //Two ways to count it.
    // 1. We can count the entries in the _items map. But if there are 5 quantities from one item, it counts it as 1 not as 5.
    // 2. We can count the sum of all quantities. So if we have 1 product in the cart and there are 5 quantities from that one item,
    //then it counts it as 5,not as 1.
    //return _items == null ? 0 : _items.length;  //Counting the amount of products in the cart not the sum of quantities
    return _items.length;
  }



  //With this getter method, we are calculating the total price of our items in the cart.
  double get totalAmount{
    var total = 0.0;
    //with this forEach(), we can execute a function on each item in this _items map. 'cartItem' is the value to the key.
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total; //This total amount is needed in the cart screen. In there it has to listen to changes on this cart.
  }



  //this 'productId' below is which we are use as the key in the map.
  void addItem(String productId, double price, String title){
    //before adding an item to the cart we have to check that whether that item is already having in the cart. If so, we have to
    // increase the quantity. If not, we have to add that brand new item to the cart.
    // So here, we add an if check and check our '_items' which are already items in a cart with containsKey whether they already have
    // an entry for this product ID, and that's the advantage of using the product ID as a key, we can conveniently check whether
    // we have an entry for that ID and if yes, we know we already have a cart item for that product in there, &
    // we need to simply change the quantity.
    if(_items.containsKey(productId)){
      //Change the quantity...
      _items.update(
          productId,
              (existingCartItem) => CartItem(
                  id: existingCartItem.id,
                  title: existingCartItem.title,
                  price: existingCartItem.price,
                  quantity: existingCartItem.quantity + 1,
              ),
      );
    }
    else{
      //We need to add a new entry to the cart here.
      _items.putIfAbsent(
          productId,
            () => CartItem( //So this will add a new cart item to our map of cart items
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1,
            ) ,
      );
    }
    notifyListeners(); //You always need to call notifyListeners when you change something in your provided classes to which
              // your listeners should react.So here if I update my cart, of course at the end of this add item function here,
              // I have to call notifyListeners, otherwise my changes won't be reflected in user interface.
  }



  //The easiest way of getting rid of the item here is, is to simply receive the ID of the product it belongs to. We are using that
  // productId as the key in our map.
  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }




  //method to remove a single item when the 'UNDO' button is clicked. (only a single quantity from the cart by UNDO button)
  void removeSingleItem(String productId){  //productId is the key here.
    if(!_items.containsKey(productId)) { //
      return;  //when the quantity is 0 nothing returns
    }
    if(_items[productId].quantity > 1){    //when the quantity is greater than 1
      _items.update(productId, (existingCartIem) => CartItem(
          id: existingCartIem.id,
          title: existingCartIem.title,
          quantity: existingCartIem.quantity - 1,
          price: existingCartIem.price,
      ),);
    }
    else{   //when the quantity is 1
      _items.remove(productId);
    }
    notifyListeners();  //notifies about the updates
  }



  //This method clears the cart items after we are placing an order.
  void clear() {
    _items = {}; //setting _items into an empty map again & calling to notifyListeners.
    notifyListeners();
  }
}


