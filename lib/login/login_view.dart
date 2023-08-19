import 'package:flutter/material.dart';
import 'package:tummy_box_admin_web/home/homeView.dart';
import 'package:tummy_box_admin_web/login/login_vm.dart';

class LoginPage extends StatelessWidget {
  final Function loginCallback;

  LoginPage({required this.loginCallback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(loginCallback: loginCallback),
    );
  }
}

class LoginForm extends StatefulWidget {
  final Function loginCallback;

  const LoginForm({required this.loginCallback, Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final LoginViewModel _viewModel = LoginViewModel();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final bool isValid = await _viewModel.checkCredentials(username, password);

    if (isValid) {
      // Call the loginCallback provided during construction
      widget.loginCallback();
     

      // Navigate to home page if credentials are correct
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeView(logoutCallback: widget.loginCallback)),
      );
    } else {
      // Show an error message or alert if credentials are incorrect
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid credentials. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _login(context),
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
