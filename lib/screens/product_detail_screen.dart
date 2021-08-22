import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget{
  //final String title;
  //final double price;

  //ProductDetailScreen(this.title, this.price);


  //This is how to use this page/screen/widget as a named route. Then we use this 'routeName' in our main.dart file in the route table
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context){
    final productId = ModalRoute.of(context).settings.arguments as String; //This is giving us the id to the property 'productId'
    //so in here we want to get all our product data for this taken id. But this won't work if we pass data through constructors.
    // So, NOW WE NEED A CENTRAL STATE MANAGEMENT SOLUTION
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,  //If we set this as 'true', then the build method of the widget in which we're using the 'Provider.of' will
            // rerun whenever the provided object (in here the 'Products' object) changed.
    ).findByID(productId);  //by doing this, we have fetched our product here by its ID.
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView( //si it is scrollable in case the space does not sufficient on our page.
        child : Column(
          children : <Widget>[
            Container(
              height : 300,
              width : double.infinity,
              child : Image.network(
                loadedProduct.imageUrl,
                fit : BoxFit.cover, //to fit the image nicely into the container
              ),
            ),
            SizedBox(height : 10),
            Text(   //This text holds the price of that element.
              '\$${loadedProduct.price}',
              style : TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 22,
              ),
            ),
            SizedBox(height : 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,),
              width : double.infinity,
              child :Text(
                loadedProduct.description,
                style: TextStyle(fontSize: 23, color : Theme.of(context).primaryColor, fontWeight: FontWeight.bold,),
                textAlign: TextAlign.center,
                softWrap: true, //by setting this true, this wraps into new lines if there is no more space
              ),
            ),
          ],
        ),
      ),
    );
  }
}