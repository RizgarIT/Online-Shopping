import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/cart.dart';

class Cart_Item extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  Cart_Item(this.id, this.price, this.quantity, this.title, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (value) {
        Provider.of<CartItem>(context, listen: false).deleteitem(productId);
      },
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        color: Colors.red[800],
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            Icons.delete,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are you sure ?!'),
                content: Text('Do you want to remove the item from cart?'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('No')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text('Yes'))
                ],
              );
            });
      },
      direction: DismissDirection.endToStart,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(child: Text('\$$price')),
          ),
          title: Text(title),
          subtitle: Text(' Total : \$${price * quantity}'),
          trailing: Text('$quantity X'),
        ),
      ),
    );
  }
}
