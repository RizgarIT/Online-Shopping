import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/Auth_provider.dart';
import 'package:shopp_app/Providers/Product_provider.dart';
import 'package:shopp_app/Providers/cart.dart';
import 'package:shopp_app/Providers/order.dart';
import 'package:shopp_app/Screens/Input_product.dart';
import 'package:shopp_app/Screens/Order_Screen.dart';
import 'package:shopp_app/Screens/Product_Overview_Screen.dart';
import 'package:shopp_app/Screens/User_product_screen.dart';
import 'package:shopp_app/Screens/auth_screen.dart';
import 'package:shopp_app/Screens/cart_screen.dart';
import 'package:shopp_app/Screens/product_detial_screen.dart';
import 'package:shopp_app/Screens/splash_screen.dart';

void main() {
  runApp(myapp());
}

class myapp extends StatelessWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth,products>(
           create: (context) =>products(null,null,[]),
          update: (context,auth,previosproduct) => products(auth.toke,auth.userid,previosproduct!.items==null?[]:previosproduct.items),
        ),
        ChangeNotifierProvider(
          create: (context) => CartItem(),
        ),
        ChangeNotifierProxyProvider<Auth,Order>(
          create: (ctx) => Order(null,null,[]),
          update: (context,auth,previosorder) => Order(auth.toke, auth.userid,previosorder!.orderitems == null ?[]:previosorder.orderitems),
        )
      ],
      child:Consumer<Auth>(
        builder: (context, _Auth, child) => MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.pink[300],
              canvasColor: Colors.white,
              fontFamily: 'lato'),
          title: 'Shop App',
        
         home:_Auth.auth
                  ? ProductOverView()
                  : FutureBuilder(
                      future: _Auth.tryautologin(),
                      builder: (ctx, authResultSnapshot) 
                        => authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                             
                              
                    ),
          routes: {
      ProductOverView.routName:(ctx)=>ProductOverView(),
          AuthScreen.routeName:(ctx)=>AuthScreen(),
            ProductDetail.routname: (ctx) => ProductDetail(),
            CartScreen.routname: (ctx) => CartScreen(),
            Order_Item.routename: (ctx) => Order_Item(),
            UserProductScreen.routename: (ctx) => UserProductScreen(),
            NewProduct.routename: (ctx) => NewProduct()
        
          },
        ),
      ),
      
    );
  }
}
