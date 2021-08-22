//We are creating mixin by using the 'with' keyword.
//The core difference of a class & this class is that we simply merge some properties or methods into our existing class, but we
// don't return our class into an instance of that inherited class
import 'package:flutter/material.dart';

import './product.dart';

//We have to turn this class here into a data container(provider), in to a provider which we can use in our app & in the different
// parts of our app

//This 'ChangeNotifier' is related to the inherited widget which the provider package uses behind the scene. This allows us to
// establish bts communication tunnels with the help of the context object which we're getting in every widget
class Products with ChangeNotifier{

  //This is a list of Products created according to the 'Product' class which are in the 'product.dart' file
  List<Product> _items = [
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
  Product findByID(String id) {
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


  
  //When our products change, we have to call a certain method to tell all the listeners of this provider, that new data is available
  void addProduct() {
    //_items.add(value);
    //so if we change data in this class, how to tell to all other widgets & widgets that are
    // interested to know about this? That's why we add 'ChangeNotifier' bcz, that gives us access to a 'notifyListeners()' method.
    // because this class will soon be used by the provider package which uses inherited widget behind the scenes, and therefore
    // it will establish a communication channel between this class & widgets that are interested for us. And we want to let those
    // widgets know about the updates that we did with notifyListeners. So those widgets which are listening to this class & to the
    // changes of this class, are then rebuilt & get the latest data we have in the '_items'.
    notifyListeners();
  }
}

