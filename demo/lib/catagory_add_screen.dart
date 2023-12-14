import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Catagory_add extends StatefulWidget {
  const Catagory_add({Key? key}) : super(key: key);

  @override
  State<Catagory_add> createState() => _Catagory_addState();
}

class _Catagory_addState extends State<Catagory_add> {
  @override
  void initState() {
    super.initState();
    print("initState called");
    fetchcat();
  }

  List<dynamic> catag = [];

  Future fetchCat() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        return userDoc['Catagory'];
        // setState(() {
        //   catag = userDoc.get('Catagory');
        // });
      } else {
        print("Doc not found");
      }
    }
  }

  TextEditingController _catg = TextEditingController();
  final formkey = GlobalKey<FormState>();

  void fetchcat() async {
    // You can use the getUserFirstName function from the previous answer
    List userCatag = await fetchCat();
    setState(() {
      catag = userCatag;
    });
  }

  final user = FirebaseAuth.instance.currentUser;

  Future<void> _showMyDialog1() async {
    return showDialog<void>(
      context: context,
      useSafeArea: false,
      barrierDismissible:
          true, // Allow user to dismiss the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 20,
          content: SizedBox(
            height: 100,
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _catg,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      hintText: "Catagory",
                      hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                      label: Text(
                        "catagory",
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
                              width: 2,
                              style: BorderStyle.solid,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(12)),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2,
                              style: BorderStyle.solid,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please add catagory";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  CollectionReference collectionReference =
                      FirebaseFirestore.instance.collection('User');

                  // Replace with your Firestore document ID
                  String documentId = user!.uid;

                  // Get the document you want to update
                  DocumentSnapshot documentSnapshot =
                      await collectionReference.doc(documentId).get();

                  // Get the existing array data
                  List existingarr = documentSnapshot.get('Catagory');

                  // Add the new variable to the array
                  existingarr.add(_catg.text);

                  // Update the Firestore document with the new array
                  await collectionReference.doc(documentId).update({
                    'Catagory': existingarr,
                  });

                  setState(() {
                    fetchcat();
                    _catg.clear();
                    Navigator.of(context).pop();
                  });
                }
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF141E46),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 300,
                  child: Container(
                    height: 200,
                    width: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.blue.shade400,
                            value: 30, // Replace with your data
                            title: 'A', // Optional title for the section
                            radius: 60, // Adjust the radius as needed
                          ),
                          PieChartSectionData(
                            color: Colors.green.shade400,
                            value: 20, // Replace with your data
                            title: 'B',
                            radius: 60,
                          ),
                          PieChartSectionData(
                            color: Colors.red.shade400,
                            value: 20, // Replace with your data
                            title: 'c',
                            radius: 60,
                          ),
                          // Add more sections as needed
                        ],
                        // You can customize the appearance and behavior of the pie chart further
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        // height: 500,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Your Catagories",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: IconButton(
                                        onPressed: () => _showMyDialog1(),
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.black,
                                          size: 30,
                                        )),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    print("Done");
                                    fetchcat();
                                  },
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    // scrollDirection: Axis.vertical,
                                    itemCount: catag.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF141E46)
                                                .withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        245, 0, 0, 0)
                                                    .withOpacity(
                                                        0.1), // Adjust shadow color and opacity
                                                blurRadius: 10,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  catag[index],
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                IconButton(
                                                    onPressed: () async {
                                                      CollectionReference
                                                          collectionReference =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'User');

                                                      // Replace with your Firestore document ID
                                                      String documentId =
                                                          user!.uid;

                                                      // Get the document you want to update
                                                      DocumentSnapshot
                                                          documentSnapshot =
                                                          await collectionReference
                                                              .doc(documentId)
                                                              .get();

                                                      // Get the existing array data
                                                      List existingarr =
                                                          documentSnapshot
                                                              .get('Catagory');

                                                      // Add the new variable to the array
                                                      existingarr
                                                          .removeAt(index);

                                                      // Update the Firestore document with the new array
                                                      await collectionReference
                                                          .doc(documentId)
                                                          .update({
                                                        'Catagory': existingarr,
                                                      });
                                                      print("Deleted");

                                                      setState(() {
                                                        fetchcat();
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
