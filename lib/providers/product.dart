//This file defines how a product should looks like in this application
//This 'Product' is just a class its not a widget. Bcz we just want to use this as a blueprint to create objects based on this class

import 'package:flutter/foundation.dart'; //This is used for the '@required' fields
import 'package:http/http.dart' as http; //'http' is the prefix here as a bundle of all the features under this prefix.
import 'dart:convert'; //to encode to a json code


class Product with ChangeNotifier{
  //This is 'final' bcz we expect to get that id when the product is created. We get that bcz we'll create a product on a
      // server & then we'll store that server-side generated product here in our application.
  final String id;
  final String title;
  final String description;
  final double price; //We use 'double' here to allow decimal places too.
  final String imageUrl; //This image will be stored in the server and not as an asset within application.So this is a network image
  bool isFavorite; //This is not final this is boolean. bcz this will be changeable(mutable) after the product has been created.
  // we also need a way of manipulating this boolean value in a way that also allows us to call notify listener.


  //The named arguments are used here within the {} curly braces
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });


  void _setFavValue(bool newValue){
    //in here we want to roll it back when there is any failure
    isFavorite = newValue;
    notifyListeners();
  }



  //The purpose of this method is we invert the value of the 'isFavorite'. So if it is true, then we want to set it false. If it is
  // false, then we want to set it true.
  Future<void> toggleFavoriteStatus() async{
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    // in order to let all listeners know that we need to call 'notifyListeners()'. so when we are letting them to listen, if some
    // thing changed, then they will rebuild.
    notifyListeners();
    //final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products/$id'); //this is for error handling
    final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products/$id.json');
    try{
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite' : isFavorite,
        }),
      );
      if(response.statusCode >= 400) { //which means if there's any error
        //in here we want to roll it back when there is any failure
        _setFavValue(oldStatus);
      }
    }
    catch(error){
      //in here we want to roll it back when there is any failure
      _setFavValue(oldStatus);
    }
  }
}


