//Idea of this 'UserProductsScreen' is to show a list of all te products of the user
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';


class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen : false).fetchAndSetProducts();
  }


  @override
  Widget build(BuildContext context) {
    //by doing the below line of code, we let the provider package know that we want to tap into the nearest provided 'Products' object
    // & get accessed to that. And here, we want to listen of course, bcz if we delete a product, we want to exactly rebuild the list.
    //Of course here we can use a Consumer to wrap the ListView.builder only instead of the entire widget. Otherwise the entire widget
    // will be rebuild when there is any changes in the 'Products' object.
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //here we use 'pushNamed', not the 'pushReplacement', bcz we want to push the new page on the stack of pages so that we can
              // also go back to this 'UserProductsScreen' page.
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),

      drawer: AppDrawer(),

      body: RefreshIndicator(
        onRefresh : () => _refreshProducts(context), //here we call an anonymous function since we have to pass the context with it
        child : Padding (
          padding: EdgeInsets.all(8),
          child : ListView.builder(
            // This 'itemCount' defines the amount of products that we have. We get that from our 'Products' provider, from our provided
            // 'Products' object to be precise. SO, WE WANT TO SET UP A LISTENER TO THAT PROVIDER. And also we need to get accessed to the
            // 'Products' class.
            itemCount : productsData.items.length,
            itemBuilder: (_ , i) => Column(
              children: <Widget>[
                UserProductItem(
                  id: productsData.items[i].id,
                  title: productsData.items[i].title,
                  imageUrl: productsData.items[i].imageUrl,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),

    );
  }
}


