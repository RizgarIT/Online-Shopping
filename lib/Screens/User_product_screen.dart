import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/Product.dart';

import 'package:shopp_app/Providers/Product_provider.dart';
import 'package:shopp_app/Screens/Input_product.dart';
import 'package:shopp_app/Widget/AppDrawer.dart';
import 'package:shopp_app/Widget/manage_product.dart';

class UserProductScreen extends StatelessWidget {
  static const routename='/manage_product';

  Future<void> _Refresh(BuildContext context)async
  {
   await Provider.of<products>(context,listen: false).fetchingdata(true);
   
  }
  @override
  Widget build(BuildContext context) {
   
    final ProductData = Provider.of<products>(context,listen: false);
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(onPressed: (){

            Navigator.of(context).pushNamed(NewProduct.routename);
          }, icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _Refresh(context),
        builder:(context,snapshot)=>snapshot.connectionState==ConnectionState.waiting? Center(
          child: CircularProgressIndicator(),
        ): RefreshIndicator(
          onRefresh:()=> _Refresh(context)
          ,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ManageProduct(
                      ProductData.items[index].ImageURL,
                        ProductData.items[index].title,
                      ProductData.items[index].id
                        ),
                        Divider()
                  ],
                );
              },
              itemCount: ProductData.items.length,
            ),
          ),
        ),
      ),
    );
  }
}
