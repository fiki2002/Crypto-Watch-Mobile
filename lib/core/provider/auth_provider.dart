import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cryptowatch/core/constants/app_url.dart';

import '../../app/app_routes.dart';

class AuthenticationProvider extends ChangeNotifier {
  final requestBaseUrl = AppUrl.baseUrl;

  bool _isLoading = false;
  String _resMessage = '';

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  void signUpUser({
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    String url = "$requestBaseUrl/auth/signup";

    final Map<String, String> header = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final body = {
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword
    };
    print(body);

    try {
      http.Response req = await http.post(Uri.parse(url),
          headers: header, body: json.encode(body));

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        print(res);
        _isLoading = false;
        _resMessage = "User created successfully";
        notifyListeners();

        Navigator.of(context).pushNamed(AppRoutes.signInView);
      } else {
        final res = json.decode(req.body);
        _resMessage = res['message'];

        print(res);
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again";
      notifyListeners();

      print(":::: $e");
    }
  }

  void clear() {
    _resMessage = "";
    notifyListeners();
  }
}
