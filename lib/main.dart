import 'package:flutter/material.dart';
import './wrapper/wrapper.dart'; // Import the wrapper.dart file


void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp().catchError((e) {
  //   print('Error initializing Firebase: $e');
  // });
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn =
        false; // You need to determine if the user is logged in or not
    // For demonstration, assuming the user is not logged in by default

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Wrapper(isLoggedIn: isLoggedIn),
      
    );
  }
}
