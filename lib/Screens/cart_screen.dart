import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/cart.dart';
import 'package:shopp_app/Providers/order.dart';
import 'package:shopp_app/Widget/Catr_Item.dart';

class CartScreen extends StatelessWidget {
  static const routname = '/cart';

  @override
  Widget build(BuildContext context) {
    final total = Provider.of<CartItem>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text('Total',style: TextStyle(fontSize: 20,),),
                  Spacer(),
                  Chip(label: Text('\$${total.totalcard}')),
                  OrderButton(total: total)
                ],
              ),
            ),
          ),
SizedBox(height: 10,),

          Flexible(
            flex: 2,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Cart_Item(
                  total.item.values.toList()[index].id,
                  total.item.values.toList()[index].price,
                  total.item.values.toList()[index].quantity,
                  total.item.values.toList()[index].title,
                  total.item.keys.toList()[index]
                );
              },
              itemCount: total.item.length,
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.total,
  }) : super(key: key);

  final CartItem total;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}
var _loading=false;

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed:(widget.total.itemcount<=0)?null: () async{
setState(() {
  _loading=true;
});
       await   Provider.of<Order>(context,listen: false).addorder(widget.total.item.values.toList(), widget.total.totalcard);
          widget.total.clear();
          setState(() {
            _loading=false;
          });
        },
        child:_loading?CircularProgressIndicator(): Text(
          ' Order Now',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ));
  }
}
