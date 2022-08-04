import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/Product.dart';
import 'package:shopp_app/Providers/Product_provider.dart';
import 'package:shopp_app/Screens/Input_product.dart';

class ManageProduct extends StatefulWidget {
  final String title;
  final String ImageUrl;
  final String id;
  ManageProduct(this.ImageUrl, this.title,this.id);

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {

void removeitem(String id)
{
 setState(() {
                    Provider.of<products>(context,listen: false).removeitem(id);
                   
                  });
}

  @override
  Widget build(BuildContext context) {
   
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.ImageUrl),
      ),
      title: Text(widget.title),
      trailing: FittedBox(
        child: Row(
          children: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NewProduct.routename,arguments: widget.id);
              },
              child: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            FlatButton(
                onPressed: () {

                 removeitem(widget.id);
                },
                child: Icon(Icons.delete, color: Theme.of(context).errorColor)),
          ],
        ),
      ),
    );
  }
}
