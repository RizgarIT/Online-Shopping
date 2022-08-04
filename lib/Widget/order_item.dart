import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopp_app/Providers/order.dart' as ord;

import 'package:intl/intl.dart';

class OrderItems extends StatefulWidget {
  final ord.orderitem orders;

  OrderItems(this.orders);

  

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  bool _expanden = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(microseconds: 300),
      height: _expanden?min(200, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '\$${widget.orders.amount}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(DateFormat((' yyyy/MM/dd  -  HH:mm  '))
                  .format(widget.orders.dateTime)),
              trailing: IconButton(
                icon:
                    _expanden ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
                onPressed: () {
                  setState(() {
                    _expanden = !_expanden;
                  });
                },
              ),
            ),
           
              AnimatedContainer(
                duration: Duration(microseconds: 300),
                height:_expanden?min(100 , 150) : 0,
                child: ListView(
                  children: widget.orders.products.map((e) {
                    return ListTile(
                      leading: Text(
                          e.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing:     Text('${e.quantity} X      \$${e.price}'),
                        
                    );
                  }).toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
