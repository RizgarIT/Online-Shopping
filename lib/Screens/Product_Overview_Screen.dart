import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/Product_provider.dart';
import 'package:shopp_app/Providers/cart.dart';
import 'package:shopp_app/Screens/cart_screen.dart';
import 'package:shopp_app/Widget/AppDrawer.dart';

import 'package:shopp_app/Widget/Product_grid.dart';
import 'package:shopp_app/Widget/badge.dart';

enum FiltersOptions {
  Favorites,
  All,
}

class ProductOverView extends StatefulWidget {

  static const routName='/ProductOverView';
  @override

  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  var _showFavorites = false;
  var _isinit = true;
  var _loading = false;

  @override
  void didChangeDependencies() async {
    
     
  
    if (_isinit) {
      setState(() {
          _loading = true;
        });
     await Provider.of<products>(context).fetchingdata().then((_) {
       setState(() {
          _loading = false;
        });
     });
      
    _isinit = false;
  
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<CartItem>(
            builder: (context, cart, child) => Badge(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routname);
                },
                icon: Icon(Icons.shopping_cart),
              ),
              value: cart.itemcount.toString(),
            ),
          ),
          PopupMenuButton(
            onSelected: (FiltersOptions SelectValue) {
              setState(() {
                if (SelectValue == FiltersOptions.Favorites) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FiltersOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FiltersOptions.All,
              )
            ],
          ),
        ],
        title: Text('My shop'),
      ),
      drawer: AppDrawer(),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.amber[800],
              ),
            )
          : Product_item(_showFavorites),
    );
  }
}
