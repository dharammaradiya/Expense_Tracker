import 'dart:async';

import 'package:demo/dashboard_screen.dart';
import 'package:demo/Login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class spashscreen extends StatefulWidget {
  const spashscreen({super.key});

  @override
  State<spashscreen> createState() => _spashscreenState();
}

class _spashscreenState extends State<spashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () => checkUserAndNavigate());
  }

  Future<void> checkUserAndNavigate() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
  

      // User is already logged in, navigate to the dashboard.

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(User: user.displayName.toString()),
        ),
      );
    } else {
      // User is not logged in, navigate to the Login input screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF141E46),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SmartSpend',
                style: GoogleFonts.acme(
                    textStyle:
                        const TextStyle(fontSize: 28, color: Colors.white)),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                FontAwesomeIcons.coins,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 50,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
