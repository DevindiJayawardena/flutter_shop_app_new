//This defines how a single item should looks like in our list of items.
import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  UserProductItem({this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
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
            onPressed: (){},
            color: Theme.of(context).accentColor,
          ),
          IconButton(
            icon: Icon(
              Icons.delete_forever_rounded,
            ),
            onPressed: (){},
            color: Theme.of(context).errorColor,
          ),
        ],),
      ),
    );
  }
}



