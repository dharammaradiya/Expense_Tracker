import 'package:demo/spash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'user_input.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAQFmMYS4YqWKwEoqECCfRsKEaPrCNKl38",
          authDomain: "",
          projectId: "smartspend-6cfcd",
          storageBucket: "",
          messagingSenderId: "695357660877",
          appId: "1:695357660877:android:74e406185d7403cae79384",
          measurementId: ""));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));

  runApp(const MyApp());
  Fluttertoast.showToast(msg: "App started");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Demo",
      home: spashscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
