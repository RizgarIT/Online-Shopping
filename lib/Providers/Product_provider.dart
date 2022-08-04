import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shopp_app/Providers/Product.dart';
import 'package:http/http.dart' as http;

class products with ChangeNotifier {
  final dynamic authtoken;
  final dynamic userId;
  products(this.authtoken,this.userId, this._item);
  List<Product> _item = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   ImageURL:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     ImageURL:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     ImageURL:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Shoes',
    //     description:
    //         'Assertive yet understated appeal accompanies the sleek Carnaby designed for true sneaker fans. Crafted from smooth white leather, the court-inspired uppers perfectly epitomize the elegance of the brand. Subtly embellished with a contrast-colored heel and a tonal branded lace jewel, the piece features a signature crocodile on the quarter underlined by a trio of perforations.',
    //     price: 49.99,
    //     ImageURL:
    //         'https://www.lacoste.sa/dw/image/v2/BDCL_PRD/on/demandware.static/-/Sites-lacoste-master-catalog/default/dw37b3fbd7/images/43SMA0033_080_01.jpg?sw=420&sh=420',
    //   ),
  ];
// var _FavoritesData=false;
  List<Product> get items {
    // if(_FavoritesData)
    // {
    //   return _item.where((element) => element.favorites).toList();
    // }
    return [..._item];
  }

  List<Product> get itemsFavorites {
    return _item.where((element) => element.favorites).toList();
  }

  Future<void> removeitem(String id) async {
    final url =
        'https://online-shopping-1999-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authtoken';
    await http.delete(Uri.parse(url));
    _item.removeWhere((item) => item.id == id);
    notifyListeners();
  }
// void showfavorites()
// {

//   _FavoritesData=true;
//   notifyListeners();
// }

// void showall()
// {
//   _FavoritesData=false;
//   notifyListeners();
// }

  Product buildfirstitem(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchingdata([bool filltaring=false]) async {
     String uri
          =
        'https://online-shopping-1999-default-rtdb.asia-southeast1.firebasedatabase.app/UserFavorites/$userId.json?auth=$authtoken';

 final responsedata = await http.get(Uri.parse(uri));
 final userdata=json.decode(responsedata.body);

 final filterdata= filltaring ? 'orderBy="creatorID"&equalTo="$userId"': '';

    final url =
        'https://online-shopping-1999-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authtoken&$filterdata';
        
    try {
      final response = await http.get(Uri.parse(url));
      final jsonData = json.decode(response.body);
      if (jsonData != null) {
        final fetchingData = json.decode(response.body) as Map<String, dynamic>;
        List<Product> loadingData = [];
        fetchingData.forEach((prodID, ProdData) {
          loadingData.add(Product(
            id: prodID,
            ImageURL: ProdData['imageUrl'],
            description: ProdData['description'],
            price: ProdData['price'],
            title: ProdData['title'],
            favorites: userdata==null?false:userdata[prodID]??false
          ));
      
        });
        _item = loadingData;
        notifyListeners();
      } else {
        return;
      }
    } catch (error) {
      return;
    }
  }

  Future<void> addproduct(Product Pro) async {
    String url =
        'https://online-shopping-1999-default-rtdb.asia-southeast1.firebasedatabase.app/product.json?auth=$authtoken';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': Pro.title,
          'description': Pro.description,
          'imageUrl': Pro.ImageURL,
          'price': Pro.price,
          'creatorID':userId
          
        }),
      );
      final newProduct = Product(
        title: Pro.title,
        description: Pro.description,
        price: Pro.price,
        ImageURL: Pro.ImageURL,
        id: json.decode(response.body)['name'],
      );
      _item.insert(0, newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItem(String id, Product pro) async {
    final productIndex = _item.indexWhere((element) => element.id == id);
    final url =
        'https://online-shopping-1999-default-rtdb.asia-southeast1.firebasedatabase.app/product/$id.json?auth=$authtoken';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': pro.title,
          'description': pro.description,
          'price': pro.price.toString(),
          'imageUrl': pro.ImageURL
        }));
    if (productIndex >= 0) {
      _item[productIndex] = pro;
      notifyListeners();
    }
  }
}
