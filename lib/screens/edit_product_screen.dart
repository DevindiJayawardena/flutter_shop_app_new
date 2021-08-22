import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//This file is used to both editing a product as well as to add a new product. Bcz the input fields are same. The only difference is the
//data we load & how we load the data to prepopulate the inputs.

//form input is a good candidate for a widget only or a local state. The reason for that is, what the user enters is important for this
// widget, bcz we want to validate it, we want to temporarily store it there and once the user submits that, then we want to save that into
//our app-wide state, create a new product, sign up a user, whatever we are doing but until the use presses the submit button, we want to
// only manage those data in our widget, bcz the user might cancel adding this, might close the app. So our general input is not affected by
//the user inputs until those details are really submitted. So we want to manage & validate the user inputs locally in this widget. Hence,
// 'StatefulWidget' is the right solution. (instead of using a provider package)


class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}


class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();



  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }


  
  //To dispose the created focus nodes above. Otherwise, there will be a memory leakage.
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }



  void _updateImageUrl() {
    if(!_imageUrlFocusNode.hasFocus){
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(  //since this is a standalone page
      appBar: AppBar(
        title: Text('Edit Product',),
      ),

      //Instead of manually collecting all inputs with 'TextEditingController' which we have to assign, Flutter gives a widget called
      // 'Form' that helps us with collecting user inputs & with validation as well. This 'Form' widget is invisible, it doesn't render
      //anything on the screen that we could see. But inside of this 'Form' widget, we can use special input widgets are then grouped
      // together and which can be submitted together & validated together.
      body : Padding(
        padding: EdgeInsets.all(16.0),
        child : Form(
          child : ListView(  //ListView eka wenuwata SingleChildScrollView eka daala Column eka daanna puluwan.
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title',),
                textInputAction: TextInputAction.next,
                autofocus: true,
                // we use _ to the value to indicate that we're not interested in the value of this particular text field.
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Price',),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                // we use _ to the value to indicate that we're not interested in the value of this particular text field.
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Description',),
                maxLines: 3,
                //textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[

                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 15, right: 10,),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width : 1,
                        color : Colors.grey,
                      ),
                    ),
                    child : _imageUrlController.text.isEmpty ? Text(
                      'Enter a URL',
                      style: TextStyle(
                          color : Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ) : FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.go,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      //onEditingComplete: () {   //meeka daanawa nm ara listeners, focusnodes ona na imageUrl ekta 
                        //setState(() {});
                      //},
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),

    );
  }
}








