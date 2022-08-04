import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/Product.dart';
import 'package:shopp_app/Providers/Product_provider.dart';
import 'package:shopp_app/Widget/Product_item.dart';

class Product_item extends StatelessWidget {
  final bool showFav;
  Product_item(this.showFav);
  @override
  Widget build(BuildContext context) {
    final ProductData = Provider.of<products>(context);
    final Produc = showFav ? ProductData.itemsFavorites : ProductData.items;
    return Produc.isEmpty
        ? Center(
            child: Text(
            'you have no item yet',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'lato',
              fontWeight: FontWeight.bold,
            ),
          ))
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (ctx, index) {
              return ChangeNotifierProvider.value(
                value: Produc[index],
                child: ProductItem(),
              );
            },
            itemCount: Produc.length,
            padding: EdgeInsets.all(10),
          );
  }
}
