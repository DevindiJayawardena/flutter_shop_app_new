//This is the widget that should present the grid of products we have in our application.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import './cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';


// enums are the ways of assigning labels to integers
enum FilterOptions{
  Favorites,
  All,
}


class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen>{
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context){
    //Here we get a scaffold here, bcz this 'products_overview_screen' widget will be used as the screen of our app.It fills the entire screen.
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Items'),

        actions: <Widget>[
          //This 'PopupMenuButton' opens a drop over menu
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState(() {  //Here we are setting it on a setState to rebuild our UI view
                if (selectedValue == FilterOptions.Favorites){
                  _showOnlyFavorites = true;
                }
                else{
                  _showOnlyFavorites = false;
                }
              });
            },
            icon : Icon(Icons.more_vert),
            //This itemBuilder defines the entries for this popup menu
            itemBuilder: (_) => [
              //The value here is provided to find out which choice/item was selected by the user.(it can be any identifier int or string)
              PopupMenuItem(child: Text('Only Favorites'), value : FilterOptions.Favorites,),
              PopupMenuItem(child: Text('Show All'), value : FilterOptions.All,),
            ],
          ),

          Consumer<Cart>(
            builder: (_ , cart , ch) => Badge(  // here the 'Cart' is the class that we want to listen with the Consumer. So here we are looking for
                                                          // the next provided object of type Cart
              child: ch,
              //In order to give value here,we need to get access to our provided 'Cart' class. We have provided in the main.dart file.
              // So we have to set up a listener (consumer in here)
              value: cart.itemCount.toString(), //value is the amount of items we have in the cart
            ),
            child : IconButton(
              icon : Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),

      drawer: AppDrawer(),

      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}




