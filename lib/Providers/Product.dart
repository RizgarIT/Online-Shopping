import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final dynamic price;
  final String ImageURL;
  bool favorites;
  dynamic fave;
  


  Product(
      {
      required this.id,
      required this.description,
      required this.ImageURL,
      required this.title,
      required this.price,
      this.favorites = false
      });

 void _setFavValue(bool newValue) {
    favorites = newValue;
    notifyListeners();
  }
   Future<void>toggleFavorites(String authtoken,String userId) async
      {
        final oldStatus = favorites;
         favorites=!favorites;
      
        notifyListeners();
         String url =
        'https://online-shopping-1999-default-rtdb.asia-southeast1.firebasedatabase.app/UserFavorites/$userId/$id.json?auth=$authtoken';

       try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          favorites,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
