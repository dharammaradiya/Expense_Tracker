// import 'package:demo/backup.dart';

// import 'package:demo/dashboard_screen.dart';
// ignore: depend_on_referenced_packages
// import 'package:example/auth.config.dart';
// import 'package:demo/backup.dart';
// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/Login_screen.dart';
// import 'package:email_auth/email_auth.dart';
// import 'package:demo/dashboard_screen.dart';
// import 'package:demo/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Regestration extends StatefulWidget {
  const Regestration({super.key});

  @override
  State<Regestration> createState() => _RegestrationState();
}

class _RegestrationState extends State<Regestration> {
  @override
  Widget build(BuildContext context) {
    final _email = TextEditingController();
    final _pass = TextEditingController();
    final _FirstName = TextEditingController();
    final _LastName = TextEditingController();

    // final FirebaseAuth _auth;

    Future<void> registration() async {
      final email = _email.text;
      final pass = _pass.text;
      final tb = 0;
      // List  catag = [];

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);
        // String userId = userCredential.user!.uid;

        // Send email verification
        await userCredential.user!.sendEmailVerification();
        print("Email verification sent");
        // final user = FirebaseAuth.instance.currentUser;

        if (userCredential.user != null) {
          final userId = FirebaseAuth.instance.currentUser!.uid;
          FirebaseFirestore.instance.collection('User').doc(userId).set(
            {
              'First Name ': _FirstName.text,
              'Last Name ': _LastName.text,
              'Email ': email,
              'Password ': pass,
              'Total Balance': tb,
              'Catagory': [],
              'Amount': [],
              'Reason': [],
              'Date': [],
              'SelectedcCatag': [],
              'BankName': [],
              'AccNo': [],
              'AccHolder': [],
              'OpeningAmount': [],
              'CashBalance': 0,
              'SelectedBank' : []
            },
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
        }
        Fluttertoast.showToast(
          msg: "Verification mail send you",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Please Enter Valid Credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        print("Error: $e");
      }
    }

    void adduser(email, pass, firstName, lastName) async {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('User').doc(userId).set(
        {
          'First Name ': firstName,
          'Last Name ': lastName,
          'Email ': email,
          'Password ': pass,
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          // width: double.infinity,
          decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     colors: [
              //       Color.fromARGB(255, 88, 138, 224),
              //       Color.fromARGB(255, 238, 143, 137)
              //     ]),
              color: Color(0xFF141E46)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SmartSpend',
                        style: GoogleFonts.acme(
                            color: Colors.white,
                            textStyle: const TextStyle(fontSize: 28)),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          // top: 18.0,
                          left: 18,
                          right: 18),
                      child: Text(
                        'Register YourSelf',
                        style: GoogleFonts.acme(
                            color: Colors.white,
                            textStyle: const TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 18.0, left: 18, right: 18),
                        child: TextField(
                          controller: _FirstName,
                          decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10.0),
                                child: Icon(
                                  FontAwesomeIcons.user,
                                  // fill: Checkbox.width,
                                  color: Color.fromARGB(255, 0, 0, 2),
                                ),
                              ),
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              filled: true,
                              hintText: "First Name",
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 235, 235, 235)),
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(12)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 18.0, left: 18, right: 18),
                        child: TextField(
                          controller: _LastName,
                          decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10.0),
                                child: Icon(
                                  FontAwesomeIcons.user,
                                  // fill: Checkbox.width,
                                  color: Color.fromARGB(255, 0, 0, 2),
                                ),
                              ),
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              filled: true,
                              hintText: "Last Name",
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 235, 235, 235)),
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(12)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 18.0, left: 18, right: 18),
                        child: TextField(
                          controller: _email,
                          decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10.0),
                                child: Icon(
                                  Icons.email,
                                  // fill: Checkbox.width,
                                  color: Color.fromARGB(255, 0, 0, 2),
                                ),
                              ),
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              filled: true,
                              hintText: "Your Email",
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 235, 235, 235)),
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(12)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 18.0, left: 18, bottom: 18, top: 18),
                        child: TextField(
                          controller: _pass,
                          enabled: _email.text.isEmpty ? true : true,
                          decoration: InputDecoration(
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10.0),
                                child: Icon(
                                  Icons.password,
                                  // fill: Checkbox.width,
                                  color: Color.fromARGB(255, 0, 0, 2),
                                ),
                              ),
                              fillColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              filled: true,
                              hintText: "Enter Your Password",
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 235, 235, 235)),
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(12)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3,
                                      style: BorderStyle.solid,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            onPressed: () async {
                              if (_email.text.isNotEmpty &&
                                  _pass.text.isNotEmpty &&
                                  _LastName.text.isNotEmpty &&
                                  _FirstName.text.isNotEmpty) {
                                await registration();
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Please fil all details",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 16.0,
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Verify  ",
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                                const Icon(
                                  FontAwesomeIcons.arrowRight,
                                  color: Colors.black,
                                )
                              ],
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You are Not a Member?",
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("its me");
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                          },
                          child: Text(
                            "Login Now!",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
