import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget{
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context){
    // This '<Products>' is used to let it know which type of data that we actually want to listen to. So here, we want to listen to
    // the changes in 'Products'. So here we are setting up a subscription & that subscription where that listener here with
    // 'Provider.of' works, bcz we're proving our 'Products' object in the main.dart file, which manages our list of products with
    // 'ChangeNotifierProvider'.
    // With the help of this 'Provider.of<Products>', we are specifically interested in that Products provider.
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items; //Here we'll get all of our products to this 'products' property


    //Here the 'GridView.builder()' is used to optimize the longer grid views with multiple items or where we don't know how
    // many items we have by only rendering the items that are on the screen & not rendering the items that are not on the screen.
    return GridView.builder(
      padding: const EdgeInsets.all(11.0), //by using 'const' this doesn't rebuild when this entire 'build' method is called.
      itemCount: products.length, //This 'itemCount' tells the GridView how many grid items to build

      //This 'itemBuilder' is a function or it holds a builder function which receives the context & index of item its currently
      // building a cell for, that should return the widget that gets build for every grid item we have. So this 'itemBuilder'
      // defines how every grid item is built, how every grid cell should be built. This 'itemBuilder' runs for every product in
      //our products list. Its perfect bcz we can set up different providers for each of our different product objects. So we're not
      // setting up a provider inside of the 'Products' class bcz it will not really work. Instead we have to do it in this widget tree.
      // bcz here we have accessed to all of our product items stored in the 'Products' class. (14th line)

      // Our single product is really only needed in every ProductItem list. So we need to set up a new provider here above our
      // 'ProductItem', so then we can listen to changes in that product item. So this 'ChangeNotifierProvider' is what i'm now
      //returning in our itemBuilder.
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // by using this 'create' named parameter, we are building our product object. but we have instantiate our product objects
        // in our 'Products' class. So we don't want to re-instantiate those product objects. I don't want to build a new product
        // object. So in our 'create' below, where we get a new context passed in automatically, where we have to return a value
        // which we want to provide. we can simply return 'products[i]'. This will return a single product item as its stored
        // in the 'Products' class, & it will do this multiple times bcz its inside of the itemBuilder for all the products to have.
        //create : (c) => products[i],
        // Since we're providing a single product here, we could, but we don't need to receive our
        // product data as arguments in 'ProductItem' as below. That's why we commented those 3 data. So we can get rid of all
        // properties in the 'ProductItem' class also. We have commented in there also.
        value : products[i],  //this'.value' constructor also keeps updated with changing data.
        child : ProductItem(
          //Here we want to forward the list 'products' for the index we're currently building our item for.
          //products[i].id,
          //products[i].title,
          //products[i].imageUrl,
        ),
      ),

      //This 'gridDelegate' defines how the grid generally should be structured, how many columns it should have. With this
      // 'SliverGridDelegateWithFixedCrossAxisCount' we can define that we want to have a certain amount of columns & it will
      // simply squeeze the items on to the screen.
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,//This tells the no.of columns we want to have
        childAspectRatio: 3 / 2, //So this should be taller than their wide
        crossAxisSpacing: 13, //width or spacing between columns
        mainAxisSpacing: 13, //spacing between the rows
      ),
    );
  }
}

