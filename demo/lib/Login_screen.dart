// import 'package:demo/backup.dart';
// import 'package:demo/dashboard_screen.dart';
// import 'package:demo/backup.dart';
import 'package:demo/Registration_screen.dart';
import 'package:demo/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final _email = TextEditingController();
    final _pass = TextEditingController();

    Future<void> login(BuildContext context) async {
      final email = _email.text;
      final pass = _pass.text;
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass);
        if (userCredential.user != null && userCredential.user!.emailVerified) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Dashboard(User: email),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Please Verify Your Mail",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Please Enter Valid Credential",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     colors: [
              //       Color.fromARGB(255, 88, 138, 224),
              //       Color.fromARGB(255, 238, 143, 137)
              //     ]),
              color: Color(0xFF141E46)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
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
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 18.0, left: 18, right: 18),
                      child: TextField(
                        controller: _email,
                        decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10.0),
                              child: Icon(
                                FontAwesomeIcons.keyboard,
                                // fill: Checkbox.width,
                                color: Color.fromARGB(255, 0, 0, 2),
                              ),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            filled: true,
                            hintText: "Your Email",
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            label: Text(
                              "Email",
                              style: GoogleFonts.acme(
                                  textStyle: const TextStyle(
                                      backgroundColor: Colors.white,
                                      decorationColor: Colors.white,
                                      // overflow: TextOverflow.fade,
                                      textBaseline: TextBaseline.ideographic,
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3,
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(255, 235, 235, 235)),
                                borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3,
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                borderRadius: BorderRadius.circular(12)),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3,
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextField(
                        controller: _pass,
                        decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10.0),
                              child: Icon(
                                FontAwesomeIcons.keyboard,
                                // fill: Checkbox.width,
                                color: Color.fromARGB(255, 0, 0, 2),
                              ),
                            ),
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            filled: true,
                            hintText: "Enter Your ",
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            label: Text(
                              "Password",
                              style: GoogleFonts.acme(
                                  textStyle: const TextStyle(
                                      backgroundColor: Colors.white,
                                      decorationColor: Colors.white,
                                      // overflow: TextOverflow.fade,
                                      textBaseline: TextBaseline.ideographic,
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3,
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(255, 235, 235, 235)),
                                borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3,
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                borderRadius: BorderRadius.circular(12)),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3,
                                    style: BorderStyle.solid,
                                    color: Color.fromARGB(255, 255, 255, 255)),
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
                              final email = _email.text.trim();
                              final pass = _pass.text.trim();
                              if (email.isNotEmpty && pass.isNotEmpty) {
                                await login(context);
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Please enter both email and password",
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
                                  "Get Started  ",
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
                            builder: (context) => Regestration(),
                          ));
                        },
                        child: Text(
                          "Register Now!",
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontWeight: FontWeight.w800),
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
    );
  }
}
