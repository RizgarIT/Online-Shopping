import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:shopp_app/Providers/cart.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

class orderitem {
  final String id;
  final double amount;
  final List<dynamic> products;
  final dynamic dateTime;

  orderitem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}


class Order with ChangeNotifier {
  final dynamic authtoken;
  final dynamic userId;
  Order(this.authtoken,this.userId ,this._orderItem);

  List<orderitem> _orderItem = [];
  List<orderitem> get orderitems {
    return [..._orderItem];
  }

  Future<void> fetchingdata() async {
    String url =
        'https://online-shopping-1999-default-rtdb.asia-southeast1.firebasedatabase.app/order/$userId.json?auth=$authtoken';
    try {
      final response = await http.get(Uri.parse(url));
      final jsonData = json.decode(response.body);
      if (jsonData != null) {
        final fetchingData = json.decode(response.body) as Map<String, dynamic>;
        List<orderitem> loadingData = [];
        fetchingData.forEach((prodID, ProdData) {
          loadingData.add(orderitem(
              id: prodID,
              amount: ProdData['amount'],
              dateTime: DateTime.parse(ProdData['DateTime']),
              products: (ProdData['products'] as List<dynamic>)
                  .map((item) => 
                        cart(
                            id: item['id'],
                            price: item['price'],
                            quantity: item['quantity'],
                            title: item['title'])
                      )
                  .toList()));
        });
        _orderItem = loadingData.reversed.toList();
        notifyListeners();
      } else {
        return;
      }
    } catch (error) {
      return;
    }
  }

  Future<void> addorder(List<cart> cartitem, double total) async {
    String url =
        'https://online-shopping-1999-default-rtdb.asia-southeast1.firebasedatabase.app/order/$userId.json?auth=$authtoken';

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'DateTime': DateTime.now().toIso8601String(),
            'products': cartitem
                .map((item) => {
                      'id': item.id,
                      'price': item.price,
                      'title': item.title,
                      'quantity': item.quantity
                    })
                .toList(),
          }));

      _orderItem.insert(
        0,
        orderitem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartitem,
            dateTime: DateTime.now()),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
