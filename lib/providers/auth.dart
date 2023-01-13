import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  DateTime _expiryDate = DateTime.now();
  late String _userId;

  bool get isAuth {
    return token != '1';
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate == _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return '1';
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC77yWo_Jr8YPfuIIOi0TWmkX4ncwDkSxg');
    var response = await http.post(url,
        body: json.encode(
            {email: email, password: password, 'returnSecureToken': true}));
    print(jsonDecode(response.body));
    final responseData = jsonDecode(response.body);
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate =
        DateTime.now().add(Duration(seconds: responseData['expiresIn']));
  }

  Future<void> signIn(String password, String email) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC77yWo_Jr8YPfuIIOi0TWmkX4ncwDkSxg');
    var response = await http.post(url,
        body: json.encode(
            {email: email, password: password, 'returnSecureToken': true}));
    print(jsonDecode(response.body));
    final responseData = jsonDecode(response.body);
    //_token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate = responseData['expiresIn'];
  }
}
