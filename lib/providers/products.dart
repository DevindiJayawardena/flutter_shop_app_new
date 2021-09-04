
//We are creating mixin by using the 'with' keyword.
//The core difference of a class & this class is that we simply merge some properties or methods into our existing class, but we
// don't return our class into an instance of that inherited class
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import 'dart:convert'; //This library is used to convert dart objects to JSON format

import './product.dart';

//We have to turn this class here into a data container(provider), in to a provider which we can use in our app & in the different
// parts of our app

//This 'ChangeNotifier' is related to the inherited widget which the provider package uses behind the scene. This allows us to
// establish bts communication tunnels with the help of the context object which we're getting in every widget
class Products with ChangeNotifier{

  //This is a list of Products created according to the 'Product' class which are in the 'product.dart' file
  List<Product> _items = [
    /*
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://media.istockphoto.com/photos/teenager-boy-wearing-red-tshirt-over-white-isolated-background-with-picture-id1213844264?k=6&m=1213844264&s=612x612&w=0&h=5DYbFfX2El3b7cFgn42A56zIc0Xozkby2bBzI3w74qg=',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://ae01.alicdn.com/kf/H3fc5746dbaee4e41a1b98d5d0fbfe661b/Suit-pants-men-Trousers-office-Straight-formal-pants-man-Business-solid-slim-fit-mens-Social-Trousers.jpg_Q90.jpg_.webp',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
        id: 'p4',
        title: 'Baby suit',
        description: 'Warm & cotton baby suits - keep your baby convenient',
        price: 49.99,
        imageUrl:
        'https://st4.depositphotos.com/3539679/24147/v/600/depositphotos_241476286-stock-illustration-vector-realistic-blue-and-pink.jpg'
    ),
    Product(
      id: 'p5',
      title: 'Pan',
      description: 'Prepare any meal you want.',
      price: 35.60,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p6',
      title: 'Saree',
      description: 'A cotton saree - it is pretty!',
      price: 25.99,
      imageUrl:
      'https://www.sutisaree.com/wp-content/uploads/2021/06/White-Yellow-Begumpuri-Saree.webp',
    ),
    Product(
      id: 'p7',
      title: 'Long dress',
      description: 'A red dress - suits for a function!',
      price: 39.99,
      imageUrl:
      'https://d5fp1c6whm5mr.cloudfront.net/3351928_webp-net-resizeimage-6_699x1000.jpg',
    ),
    Product(
      id: 'p8',
      title: 'Short',
      description: 'A linen short - suits for any one!',
      price: 31.90,
      imageUrl:
        'https://www.childrensalonoutlet.com/media/catalog/product/cache/0/image/1000x1000/9df78eab33525d08d6e5fb8d27136e95/i/d/ido-girls-brown-belted-shorts-303849-c5759591f0372c43102468262fb382a79436d00f.jpg'
    ),
    Product(
      id: 'p9',
      title: 'Baby toy',
      description: 'A baby toy of plastics!',
      price: 11.99,
      imageUrl:
      'https://cdn2.momjunction.com/wp-content/uploads/2015/06/Fisher-Price-Deluxe-Kick-n-Play-Piano-Gym-638x480.jpg.webp',
    ),
    Product(
      id: 'p10',
      title: 'Wallet',
      description: 'A leather wallet - black leather',
      price: 52.90,
      imageUrl:
      'https://ae01.alicdn.com/kf/H020e7c63cd0043f3a64e34b7f9dea5eep/CONTACT-S-Genuine-Leather-Wallet-Men-RFID-Small-Portfel-Card-Holder-Wallets-Vintage-Short-Coin-Purse.jpg_Q90.jpg_.webp',
    ),
    Product(
      id: 'p11',
      title: 'Saree Pins',
      description: 'Pair of saree pins with embedded plastic perls',
      price: 12.90,
      imageUrl:
      'https://img.ltwebstatic.com/images3_pi/2020/08/11/159711698090dac69e19a41a7f829e65616637c2e1_thumbnail_900x.webp',
    ),
    Product(
      id: 'p12',
      title: 'Roses Bouquet',
      description: 'A bouquet with fresh roses',
      price: 42.90,
      imageUrl:
      'https://raanaarts.com/wp-content/uploads/2021/03/184b61bfe08b19ee4f4e07d605673d6f.jpg',
    ),
    */
  ];

  //var _showFavoritesOnly = false;



  List<Product> get items{
    /*
    if (_showFavoritesOnly){
      //product items walin favorite items tika dagannawa list ekakata. e list eka return krnwa.
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }
    */
    return [..._items];   // '...' is spread operator
  }



  //This is the filtering logic
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }



  //This method returns a product in the end
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }



  /*
  void showFavoritesOnly () {
    _showFavoritesOnly = true;
    notifyListeners(); //we call this to rebuild the parts that are interested in our products data here.
  }


  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners(); //we call this to rebuild the parts that are interested in our products data here.
  }
  */




  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products.json');
    try{
      final response = await http.get(url); //'get' request is for fetching a product while 'post' request is for storing and adding the products.
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) { //we put this here to avoid from the error called 'foreach on null' when there is no products in the server.
        return;  //if there is no any products in the server, then nothing will be returned to our app.
        //so this below codes will not run if the extractedData is null.
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id : prodId,
          title: prodData['title'],
          description : prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    }
    catch(error){
      throw error;
    }

  }



  //When our products change, we have to call a certain method to tell all the listeners of this provider, that new data is available
  Future<void> addProduct(Product product) async{
    //This is the suitable place to send HTTP requests. Let's send a HTTP request.So this is our URL to which we send the request. Here we
    // define this url as a url object with the use of 'Uri.parse()'.
    //final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products.json'); //meeka gtte error handling walata
    final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products.json');
    //And now, here since we want to append data, firebase offers us to send a post request. With this post request, we also need to define
    // what kind of data that we want to send (store) there.  So it takes some named arguments also like below only than the 'url' argument.
    try{ //we add try to the codeblock that might be failed.
    final response = await http.post(
      url,
      //This 'body' argument is important here bcz this allows us to define the request body which is the data that gets attached to the request.
      //Here for this 'body', we should use JSON (JavaScript Object Notation) data.This JSON is a format for storing and transmitting data.
      // JSON data looks like a bit of 'maps' in dart. For example {'someKey' : 'someValue'} So here we want to attach to data we want to send
      // in JSON format. So now this will send a POST request to the above url, with this JSON data attached, & then send this piece of data to the server
      // and store these data in the server.
      body : json.encode({
        'title' : product.title,
        'description' : product.description,
        'imageUrl' : product.imageUrl,
        'price' : product.price,
        'isFavorite' : product.isFavorite,
      }),
    );
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id : json.decode(response.body)['name'], //This 'json.decode(response.body)' will return a map with a unique name. It'll be our id here.
    );
    _items.add(newProduct);    //_items.insert(0, newProduct);  //This is used to add this product at the start of the list.
    //so if we change data in this class, how to tell to all other widgets & widgets that are
    // interested to know about this? That's why we add 'ChangeNotifier' bcz, that gives us access to a 'notifyListeners()' method.
    // because this class will soon be used by the provider package which uses inherited widget behind the scenes, and therefore
    // it will establish a communication channel between this class & widgets that are interested for us. And we want to let those
    // widgets know about the updates that we did with notifyListeners. So those widgets which are listening to this class & to the
    // changes of this class, are then rebuilt & get the latest data we have in the '_items'.
    notifyListeners(); //to let the app know that we add a new product.
    print(json.decode(response.body));
    } //if we just print the response, then we'll get it printed like 'Instance of the response', bcz
            // we have encoded that response. Therefore, in order to get that response to be printed in the console, we have to decode it.
            // and also, it will convert it into a map.
    catch (error) {
      print(error);
      throw error;
    }

  }






  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0){
      //here we user id as a string interpolation bcz we are targeting that particular product to be updated with that given id..
      final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products/$id.json');
      //patch requests will tell firebase to merge the data which is incoming with the existing data at the address (url) you're sending it to.
      await http.patch(url, body : json.encode({
        'title' : newProduct.title,
        'description' : newProduct.description,
        'imageUrl' : newProduct.imageUrl,
        'price' : newProduct.price,
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
    else{
      print('...');
    }
  }




  Future<void> deleteProduct(String id) async{
    //here we user id as a string interpolation bcz we are targeting that particular product to be deleted with that given id..
    //final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products/$id'); //this is for exception handling
    final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    //http.delete(url);

    //This below is called optimistic updating bcz it ensures that we re-add that product if we fail.
    //here, if any error occurred, then we'll rollback our removal here.
    _items.removeAt(existingProductIndex); //so this will reinsert it into the list, if we fail there.
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400){
      //here, if any error occurred, then we'll rollback our removal here.
      _items.insert(existingProductIndex, existingProduct); //so this will reinsert it into the list, if we fail there.
      notifyListeners();
      throw HttpException('Could not delete Product!');
    }
    print(response.statusCode);
    existingProduct = null;
  }

}















/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }


  Future<void> addProduct(Product product) async {
    final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }


  Future<void> deleteProduct(String id) async {
    //final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products/$id'); //this is for error handling
    final url = Uri.parse('https://first-project-4de81-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
*/