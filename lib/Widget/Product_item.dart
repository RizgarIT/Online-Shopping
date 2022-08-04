import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/Auth_provider.dart';
import 'package:shopp_app/Providers/Product.dart';
import 'package:shopp_app/Providers/cart.dart';

import 'package:shopp_app/Screens/product_detial_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final produc = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartItem>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(ProductDetail.routname, arguments: produc.id),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Card(
            shadowColor: Colors.blueGrey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 7,
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Hero(
                  tag: produc.id,
                  child: FadeInImage(
                    fadeInDuration: Duration(seconds: 2),
                    placeholder: AssetImage('assets/image/2.png'),
                    image: NetworkImage(produc.ImageURL),
                    fit: BoxFit.cover,
                    height: 160,
                    width: double.infinity,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Consumer<Product>(
                        builder: (context, value, child) => IconButton(
                            onPressed: () {
                              value.toggleFavorites(auth.toke, auth.userid);
                            },
                            icon: produc.favorites
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.amber[800],
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    color: Colors.amber[800],
                                  )),
                      ),
                      Text(
                        produc.title,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'lato',
                            color: Colors.black),
                      ),
                      IconButton(
                          onPressed: () {
                            cart.addItem(produc.id, produc.title, produc.price);
                            Scaffold.of(context).hideCurrentSnackBar();

                            Scaffold.of(context).showSnackBar(SnackBar(
                              elevation: 4,
                              duration: Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'undo',
                                onPressed: () {
                                  cart.removesingleitem(produc.id);
                                },
                              ),
                              content: Text('Added item to cart !'),
                            ));
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.amber[800],
                          )),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
