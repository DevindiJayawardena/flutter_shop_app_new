//This defines how a single item should looks like in our list of items.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';



class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title), //this title is the name of the product. so we have to get the name of the product in above.
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl), //this 'NetworkImage' isn't a widget. Its just an object which just fetching the image.
      ),
      trailing: Container(
        width : 100,
        child : Row(children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
            ),
            onPressed: (){
              Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id, //here we pass id as an argument bcz we want to know which product is going to be edited. so in the
                                            // 'EditProductScreen' , we can load the product with this given argument 'id'.
              );
            },
            color: Theme.of(context).accentColor,
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever_rounded,
            ),
            onPressed: () async {
              try{
                await Provider.of<Products>(context, listen : false).deleteProduct(id);
              }
              catch(error){
                scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deletion Failed!', textAlign: TextAlign.center,),
                    ),
                );
              }
            },
            color: Theme.of(context).errorColor,
          ),
        ],),
      ),
    );
  }
}



