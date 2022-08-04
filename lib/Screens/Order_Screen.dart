import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopp_app/Providers/order.dart';
import 'package:shopp_app/Widget/order_item.dart';

class Order_Item extends StatefulWidget {
  
static const routename='/orders';

  @override
  State<Order_Item> createState() => _Order_ItemState();
}

class _Order_ItemState extends State<Order_Item> {
  @override
   var _isinit = true;
  var _loading = false;

  @override
  void didChangeDependencies() async {
    
     
  
    if (_isinit) {
      setState(() {
          _loading = true;
        });
     await Provider.of<Order>(context).fetchingdata().then((_) {
       setState(() {
          _loading = false;
        });
     });
      
    _isinit = false;
  
  }
  }
  Widget build(BuildContext context) {

    final orderdata=Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      
body:_loading?Center(
child: CircularProgressIndicator(),
) :ListView.builder(itemBuilder: (ctx,index){
  return OrderItems(orderdata.orderitems[index]);
},itemCount: orderdata.orderitems.length,),
    );
  }
}