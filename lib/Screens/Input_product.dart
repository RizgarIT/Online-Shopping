

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/Product.dart';
import 'package:shopp_app/Providers/Product_provider.dart';

class NewProduct extends StatefulWidget {
  static const routename = '/usertinput';

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  
  final _pricefocusenode = FocusNode();
  final _descriptionfocusenode = FocusNode();
  final _ImageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _image = GlobalKey<FormState>();
  String  pID='';
  var _inputproduct = Product(
      id: DateTime.now().toString(),
      description: '',
      ImageURL: '',
      title: '',
      price: 0,
      favorites: false
      );

  @override
  void dispose() {
    _descriptionfocusenode.dispose();
    _pricefocusenode.dispose();
    _ImageController.dispose();

    super.dispose();
  }
  var _intiatValue={
    'id':'',
    'title':'',
    'desctription':'',
    'price':'',
    'imageUrl':'',
    'favorate':''

  };
  var _isloading=false;
  var _isint=true;
@override
  void didChangeDependencies() {
    if(_isint){
    final ProductId=ModalRoute.of(context)!.settings.arguments as String?;
if(ProductId!=null)
{
    _inputproduct=Provider.of<products>(context).items.firstWhere((element) => element.id==ProductId);
    _ImageController.text=_inputproduct.ImageURL;
    pID=_inputproduct.id;
    _intiatValue={
       'id':DateTime.now().toString(),
       'title':_inputproduct.title,
    'desctription':_inputproduct.description,
    'price':_inputproduct.price.toString(),
'imageUrl':'',
'favorate':_inputproduct.favorites.toString()
    };
    } 
     _isint=false;
    }
   

    super.didChangeDependencies();
  }


  Future<void> _saveform()async {
   
  
   
 
 
       

      final isvalidate = _form.currentState!.validate();

    
      if (!isvalidate) {
     return ;

      }
      _form.currentState!.save();
       setState(() {
   _isloading=true;

 });
   if(pID=='')
      {  
 try {
        await  Provider.of<products>(context , listen: false).addproduct(_inputproduct) ;
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred!'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay',style: TextStyle(color:Colors.amber[800]),),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
        );
      } finally {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      }
      



      }
      else{
      try {
        await  Provider.of<products>(context , listen: false).updateItem(pID,_inputproduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred!'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay',style: TextStyle(color:Colors.amber[800]),),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
        );
      } finally {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      }
      
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _saveform, icon: Icon(Icons.save))],
        title: Text('Edit Product'),
      ),
      body:_isloading? Center(
        child: CircularProgressIndicator(color: Colors.amber[800],),
      ): Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _intiatValue['title'],
                  decoration: InputDecoration(labelText: 'Title'),
                  
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Provide a title';
                    } else {
                     
                    _inputproduct = Product(
                        id: _inputproduct.id,
                        title: value,
                        description: _inputproduct.description,
                        price: _inputproduct.price,
                        ImageURL: _inputproduct.ImageURL);
                  };
                    
                  },
                  textInputAction: TextInputAction.next,
                 
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                   initialValue: _intiatValue['price'],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _pricefocusenode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price';
                    } 
                     else if ( double.tryParse(value)==null) {
                      return 'Please enter a valid number';
                    }
                   else if (double.parse(value) <= 0) {
                      return 'Please enter a number greater than zero';
                    }
                  
                    else {
                      _inputproduct = Product(
                          title: _inputproduct.title,
                          id:_inputproduct.id,
                          description: _inputproduct.description,
                          price: double.parse(value.toString()),
                          ImageURL: _inputproduct.ImageURL);
                    }
                  },
                  onFieldSubmitted: (value) => FocusScope.of(context)
                      .requestFocus(_descriptionfocusenode),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                   initialValue: _intiatValue['desctription'],
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Provide a description';
                    } else if (value.length < 10) {
                      return 'Should be at least 10 characters long';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                     _inputproduct = Product(
                          title: _inputproduct.title,
                          id:_inputproduct.id,
                          description: newValue.toString(),
                          price: _inputproduct.price,
                          ImageURL: _inputproduct.ImageURL);
                  },
                  maxLines: 4,
                  focusNode: _descriptionfocusenode,
                ),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.all(10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blueGrey),
                        ),
                        child: _ImageController.text.isEmpty
                            ? Center(
                                child: Text(
                                'Enret a URL ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).errorColor,
                                ),
                              ))
                            : Image.network(_ImageController.text)),
                    Expanded(
                      child: TextFormField(
                        controller: _ImageController,
                     
                        decoration: InputDecoration(labelText: 'Image URL'),
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an Image URL';
                       
                          } else if(!value.startsWith('http') && !value.startsWith('https')) {
                        return 'Please enter an Image URL';
                        }
                       
                        },
                        keyboardType: TextInputType.url,
                    
                      onFieldSubmitted: (newValue) {
                         setState(() {
                            _image.currentState?.save();
                          });
                          _inputproduct = Product(
                              title: _inputproduct.toString(),
                              id: _inputproduct.id,
                              description: _inputproduct.description,
                              price: _inputproduct.price,
                              ImageURL: newValue.toString(),
                          );
                      },
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
