import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/Product.dart';
import 'package:shopp_app/Providers/Product_provider.dart';

class ProductDetail extends StatelessWidget {
  static const routname = '/ProductDetail';
  var Itemtitle;

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as String;
    final ItemId = arg;

    final Produc = Provider.of<products>(context).buildfirstitem(ItemId);

    return Scaffold(
        appBar: AppBar(
          title: Text(Produc.title),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Hero(tag: ItemId,child: Image.network(Produc.ImageURL)),
            ),
            SizedBox(
              height: 10,
            ),
            Text('\$\ ${Produc.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
          
              alignment: Alignment.center,
                child: Text(
              '${Produc.description}',
              style: TextStyle(fontSize: 20),
              softWrap: true,
            ))
          ],
        ));
  }
}
