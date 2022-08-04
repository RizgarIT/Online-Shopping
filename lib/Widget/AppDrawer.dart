import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/Auth_provider.dart';
import 'package:shopp_app/Screens/Order_Screen.dart';
import 'package:shopp_app/Screens/Product_Overview_Screen.dart';
import 'package:shopp_app/Screens/User_product_screen.dart';
import 'package:shopp_app/Screens/auth_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      
           child: Column(
            children: [
              AppBar(title: Text("Shopping"),automaticallyImplyLeading: false,),
             

              ListTile(

                leading: Icon(Icons.shop),
                title: Text('Shop'),
                onTap: (){
                  Navigator.of(context).pushNamed(ProductOverView.routName);
                  
                  
                },
              ),
              Divider(),
               ListTile(

                leading: Icon(Icons.payment,),
                title: Text('Order'),
                onTap: (){
                  Navigator.of(context).pushNamed(Order_Item.routename);
                }
               ),
                 Divider(),
               ListTile(

                leading: Icon(Icons.edit,),
                title: Text('Manage Products'),
                onTap: (){
                  Navigator.of(context).pushNamed(UserProductScreen.routename);
                }
               ),
                Divider(),
               ListTile(

                leading: Icon(Icons.exit_to_app,),
                title: Text('Logout'),
                onTap: (){
                 
  Navigator.of(context).pop();
  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context,listen: false).logout();
                 
                }
               )
            ],
           ),
    );
  }
}