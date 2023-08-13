import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './wrapper/wrapper.dart'; // Import the wrapper.dart file


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: const FirebaseOptions (
  apiKey: "AIzaSyCdzA02622-P24risizEwJt5m7wYTaYJXQ",
  authDomain: "tummybox-f2238.firebaseapp.com",
  projectId: "tummybox-f2238",
  storageBucket: "tummybox-f2238.appspot.com",
  messagingSenderId: "335574407035",
  appId: "1:335574407035:web:914eb761c088204d140fde",
  measurementId: "G-64CZXPK2NZ"
    )
  ).catchError((e) {
    print('Error initializing Firebase: $e');
  });
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
