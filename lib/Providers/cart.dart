import 'package:flutter/foundation.dart';

class cart {
  final String id;
  final String title;
  final double price;
  final int quantity;

  cart({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class CartItem with ChangeNotifier {
  Map<String, cart> _items = {};
  Map<String, cart> get item {
    return {..._items};
  }

  int get itemcount {
    return item.length;
  }

  double get totalcard {
    var total = 0.0;
    item.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void deleteitem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removesingleitem(String Productid) {
   
      _items.remove(Productid);
    
    notifyListeners();
  }

  void addItem(String Id, String title, double price) {
    if (_items.containsKey(Id)) {
      _items.update(
          Id,
          (value) => cart(
                id: value.id,
                price: value.price,
                quantity: value.quantity + 1,
                title: value.title,
              ));
    } else {
      _items.putIfAbsent(
          Id,
          () => cart(
                id: DateTime.now().toString(),
                price: price,
                quantity: 1,
                title: title,
              ));
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
