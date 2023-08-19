import 'package:flutter/material.dart';
import 'package:tummy_box_admin_web/home/homeView.dart';
import 'package:tummy_box_admin_web/login/login_view.dart';

class Wrapper extends StatefulWidget {
  final bool isLoggedIn;

  const Wrapper({required this.isLoggedIn, Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.isLoggedIn;
  }

  void _login() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_isLoggedIn) {
      
      return HomeView(logoutCallback: _logout,);
    // } else {
  //     return LoginPage(loginCallback: _login);
  //   }
  }
}
