import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  final DateTime _expiryDate = DateTime.now();
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

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyC77yWo_Jr8YPfuIIOi0TWmkX4ncwDkSxg');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }
}
