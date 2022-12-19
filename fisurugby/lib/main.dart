import 'package:flutter/material.dart';
import 'package:fisurugby/screens/authenticate/authenticate_screen.dart';


void main() async {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthenticateScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      );
  }
}

