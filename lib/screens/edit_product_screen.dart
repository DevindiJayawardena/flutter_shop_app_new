/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

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
  var _editedProduct = Product(
      id: null,
      title: '',
      price: 0,
      description: '',
      imageUrl: '',
  );
  var _initValues = {
    'title' : '',
    'description' : '',
    'price' : '',
    'imageUrl' : '',
  };
  var _isInit = true;
  var _isLoading = false;


  //A property that holds a global key. This is used when we need to interact with a widget inside from our code. (with 'Form' widget)
  final _form = GlobalKey<FormState>(); //'FormState' is the type of data where the GlobalKey refers to.
  //This 'GlobalKey' will allow us to interact with the state behind the 'Form' widget. So now we can assign this _form key to establish
  // a connection.



  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }



  @override
  void didChangeDependencies() {
    if(_isInit){
      //extracting the product with its 'id'
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false).findByID(productId);
        _initValues = {
          'title' : _editedProduct.title,
          'description' : _editedProduct.description,
          'price' : _editedProduct.price.toString(),
          //'imageUrl' : _editedProduct.imageUrl,
          'imageUrl' : '',
        };
        _imageUrlController.text= _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
      if((!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpeg') && !_imageUrlController.text.endsWith('webp')))
      {
        return;
      }
      setState(() {});
    }
  }




  void _saveForm() {
    final isValid = _form.currentState.validate(); //This will trigger all the defined validators.
    if(!isValid){
      return;  //if there's any error this will stops the function execution of this method from this line of code.
    }
    _form.currentState.save();  //this will only save the form & output our results if the form is valid.
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id , _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop(); //This screen will only get popped once this data is stored.
    }
    else{
      //here we'll set listen:false bcz we don't need to listen to changes of our products here. We just want to dispatch an action.
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct).catchError((error) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred!',),
            content : Text('Something went wrong..'),    //content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(
                child : Text('Okay'),
                onPressed :() {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();  //This screen will only get popped once this data is stored.
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(  //since this is a standalone page
      appBar: AppBar(
        title: Text('Edit Product',),
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: _saveForm,
          ),
        ],
      ),

      //Instead of manually collecting all inputs with 'TextEditingController' which we have to assign, Flutter gives a widget called
      // 'Form' that helps us with collecting user inputs & with validation as well. This 'Form' widget is invisible, it doesn't render
      //anything on the screen that we could see. But inside of this 'Form' widget, we can use special input widgets are then grouped
      // together and which can be submitted together & validated together.
      body : _isLoading ? Center(child : CircularProgressIndicator(),) : Padding(
        padding: EdgeInsets.all(16.0),
        child : Form(
          key : _form,  //This '_form' is our global key.
          child : ListView(  //ListView eka wenuwata SingleChildScrollView eka daala Column eka daanna puluwan.
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                  errorStyle: TextStyle(color: Colors.red),
                  //hintText: 'give a title to your product',
                ),
                textInputAction: TextInputAction.next,
                autofocus: true,
                validator: (value) {
                  if(value.isEmpty){
                    return 'Please give a title for your product!';
                  }
                  else{
                    return null;   //it returns null if the user enters a non-empty title
                  }
                },
                // we use _ to the value to indicate that we're not interested in the value of this particular text field.
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),


              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                // we use _ to the value to indicate that we're not interested in the value of this particular text field.
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if(value.isEmpty){
                    return 'PLease give a price for your product!';
                  }
                  if(double.tryParse(value) == null){
                    return 'Please enter a valid number!';
                  }
                  if(double.parse(value) <= 0) {
                    return 'Please a number greater than 0!';
                  }
                  else{
                    return null;  //it returns null if the user enters a valid number
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),


              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description',),
                maxLines: 3,
                //textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator : (value) {
                  if(value.isEmpty){
                    return 'Please give a description for your product!';
                  }
                  if(value.length < 10) {
                    return 'Your product description should be at least 10 characters long!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
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
                      //initialValue: _initValues['imageUrl'],
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.go,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      //onEditingComplete: () {   //meeka daanawa nm ara listeners, focusnodes ona na imageUrl ekta 
                        //setState(() {});
                      //},
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if(value.isEmpty){
                          return 'Please give an Image URL for your product!';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')) {
                          return 'Please enter a valid image URL!';
                        }
                        if(!value.endsWith('.jpg') && !value.endsWith('.png') && !value.endsWith('.jpeg') && !value.endsWith('webp')) {
                          return 'Please enter a valid image URL!';
                        }
                        else{
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
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

*/





import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

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
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async{
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try{
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);  //this 'addProduct' returns a future. So we added 'await' to this provider.
      }
      catch(error) {
        showDialog<Null>(  //Here we are giving generic type '<Null>' in order to pop up this showBox finally.
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              ElevatedButton(child: Text('Okay'), onPressed: () {
                Navigator.of(context).pop();
              },)
            ],
          ),
        );
      }
      /*
      finally {  //This 'finally' block runs either we succeeded or failed.
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
      */
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
          )
          : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          title: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a price.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number.';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Please enter a number greater than zero.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a description.';
                      }
                      if (value.length < 10) {
                        return 'Should be at least 10 characters long.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        price: _editedProduct.price,
                        description: value,
                        imageUrl: _editedProduct.imageUrl,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(
                          top: 8,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter a URL')
                            : FittedBox(
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
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an image URL.';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Please enter a valid URL.';
                            }
                            if (!value.endsWith('.png') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('.jpeg')) {
                              return 'Please enter a valid image URL.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              imageUrl: value,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
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




