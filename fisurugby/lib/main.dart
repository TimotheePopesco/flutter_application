import 'package:fisurugby/page/auth_page.dart';
import 'package:fisurugby/page/search/search.dart';
import 'package:fisurugby/page/home_page.dart';
import 'package:fisurugby/utils.dart';
import 'package:fisurugby/widget/login_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fisurugby/page/ressources_pages/ressources.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static final String title = 'Firebase Auth';

  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
              .copyWith(secondary: Colors.tealAccent),
        ),
        home: MainPage(),
      );
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Something went wrong!'));
            } else if (snapshot.hasData) {
              return HomePage();
            }
            // else {
            //   return AuthPage();
            // }
            else {
              return RessourcePage();
            }
          },
        ),
      );
}
