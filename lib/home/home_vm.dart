import 'package:flutter/material.dart';
import 'package:tummy_box_admin_web/login/login_view.dart';

class HomeViewModel {
  final Function loginCallback; // Pass the callback through the constructor

  HomeViewModel({required this.loginCallback});
  void logout(BuildContext context) {
    // Perform any logout actions here
    // For now, let's assume it's just navigating back to the login page
    loginCallback();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(loginCallback: loginCallback,)),
    );
  }
}
