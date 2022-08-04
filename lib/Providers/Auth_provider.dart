
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopp_app/Models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier
{
  String? _userId;
  DateTime? _expireDate;
  String? _token;
   Timer? _authTimer;

bool get auth{
  
  return toke!=null;
}

dynamic get toke{

  if(_token!=null && _expireDate!=null &&_expireDate!.isAfter(DateTime.now()))        // atwanin ama bakar benen bo away katek login dakayen page bcha home page
  {
    return _token;
  }
return null;
}
dynamic get userid{
  return _userId;
}

Future<void> _auth(String email,String password,String urlsegment)async
{ 
  String url='https://identitytoolkit.googleapis.com/v1/accounts:$urlsegment?key=AIzaSyDbOMtdji1CBvXAh_vKOIRBkw8r4zeFeqI';

try{


  final response=await http.post(Uri.parse(url),body: json.encode(
    {
'email':email,
'password':password,
'returnSecureToken':true
    }
  ));
  
  final responseData=json.decode(response.body);

  if(responseData['error']!=null)
  {
throw HttpException(responseData['error']['message']);
  }

_token=responseData['idToken'];
_userId=responseData['localId'];
_expireDate=DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
_autoLogout();
      notifyListeners();
      
final pref=await SharedPreferences.getInstance();
final userdate=json.encode({
  'token':_token,
  'userId':userid,
  'expirydate':_expireDate.toString()


});

pref.setString('userDate', userdate);
}
catch(error)
{
  throw error;
}
  
}

Future <void> logout()async
{
  _expireDate=null;
  _token=null;
  _userId=null;
 if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

  notifyListeners();
  final pref=await SharedPreferences.getInstance();
  pref.clear();
}

Future<bool>tryautologin()async{
final pref=await SharedPreferences.getInstance();
if(!pref.containsKey('userDate'))
{
  return false;

}
final extractData=json.decode(pref.getString('userDate')!) as Map <String,dynamic>;
final exparydate=DateTime.parse(extractData['expirydate']);
if(exparydate.isBefore(DateTime.now()))
{
  return false;
}


_token=extractData['token'];
_userId=extractData['userId'];
_expireDate=exparydate;
notifyListeners();
 _autoLogout();
return true;
}
void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expireDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    
  }
 Future<void>LogIn(String email,String password)async
{
 return _auth(email, password, 'signInWithPassword');
}
Future<void>SignUP(String email,String password)async
{
 String url='https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDbOMtdji1CBvXAh_vKOIRBkw8r4zeFeqI';

try{


  final response=await http.post(Uri.parse(url),body: json.encode(
    {
'email':email,
'password':password,
'returnSecureToken':true
    }
  ));
  
  final responseData=json.decode(response.body);

  if(responseData['error']!=null)
  {
throw HttpException(responseData['error']['message']);
  }



}
catch(error)
{
  throw error;
}
}
}