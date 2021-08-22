//This is the grid item which gets rendered for every product

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget{
  //final String id;
  //final String title;
  //final String imageUrl;

  //ProductItem(this.id, this.title, this.imageUrl);

  //Since we are interested in some dynamic value in a single product, it makes sense to use a provider here.
  @override
  Widget build(BuildContext context){
    //When we use 'Provider.of', then the whole build method will rerun whenever the data changed.
    final product = Provider.of<Product>(context, listen : false); //if we set 'listen:false', then it will not listen for updates
    //We need this 'product' there bcz we're getting the id, title & imageUrl from this 'product'.

    //This gives us access to the nearest provided object of type 'Cart'. (which is 34th line in the main.dart file). So now we can
    // get access to the Cart container. Now in the ProductItem here, we are not interested in changes to the cart. That's why we set
    // listen to false here. So then this widget will not rebuild if the cart changes. Bcz in here,we only want to tell the cart that
    // we added a new item, we are not interested in changes to the cart.
    final cart = Provider.of<Cart>(context, listen: false,);

    //This 'Consumer' widget is also another way to listen to changes. Which means, it also interested in listen to updates.
    // We must provide a generic type of data that we want to consume. in here it is 'Product' type data. So this establishes a
    // connection to our provided data & it looks for the nearest provider of that type up in the widget tree.
    return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            //This 'GridTile' works well particularly inside of grids
            child : GridTile(
              //Whenever we tap on the image we want to go to that 'product_detail_screen'. So we wrap that img within 'GestureDetector',
              // Bcz it allows us to add an 'onTap' listener to the image.
              child: GestureDetector(
                onTap: () {
                //'MaterialPageRoute' is a widget which takes a builder method which gives us a new context, an object and which has to
                // return a widget that we want to go to. In here, we want to go to the 'product_detail_screen' widget.
                //Navigator.of(context).push(MaterialPageRoute(
                //builder: (ctx) => ProductDetailScreen(title),
                //),);
                  Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id,  //By passing only 'id' as an argument, it can fetch all the data we need in the product detail widget.
                  //So in this named route, we want to extract this id in the 'ProductDetailScreen' by adding 'ModalRoute.of(context)'....
                  );
                },
                child: Image.network(
                  product.imageUrl,
                  fit : BoxFit.cover,//This takes all the available space it can get
                ),
              ),

              //This 'footer' will add a bar at the bottom of the GridTile
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                //The below part which has wrapped-up with the Consumer will listen to the nearest products, but here we're
                // interested in changes and Consumer always listens to changes here & then we rebuild the icon button whenever
                // our product changes. So we shrink the area of the widget which reruns when our product changes. So this 'Consumer'
                // allows us (since it is a widget) to throw it somewhere into our widget tree and then only rebuild the nested
                // children.
                leading: Consumer<Product>(
                  //So this builder method will receives the context, & an instance or the nearest instance if found of that data(in here
                  // 'product') and a child (_).
                  builder : (ctx, product, _) => IconButton(
                    //we want to switch this icon based on whatever this product already is a favorite one or not. So for that we need the
                    // product data & specific data about whether this product is a favorite product or not. So we are interested in hearing
                    // about the changes in that product. So what does it mean? It means that, we want to set up a listener to a single product
                    //, not to all products.
                    icon : Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border,),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      product.toggleFavoriteStatus();
                    },
                  ),
                ),
                title: Text(
                  product.title,
                  textAlign: TextAlign.center,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.black87,
                      content: Text(   //This defines which is displayed in the snack bar
                        'Added item to the Cart!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      duration : Duration(seconds: 2,),
                      action: SnackBarAction(
                        label: 'UNDO',
                        //textColor: Colors.purple,
                        //style : TextStyle(fontWeight: FontWeight.bold),
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),);
                  },
                ),
              ),
            ),
    );
  }
}


