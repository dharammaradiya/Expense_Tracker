// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class bank_screen extends StatefulWidget {
  const bank_screen({Key? key, required this.User}) : super(key: key);
  final String User;

  @override
  State<bank_screen> createState() => _bank_screen();
}

class _bank_screen extends State<bank_screen> {
  @override
  void initState() {
    super.initState();
    // Call the function to get the user's first name when the screen loads
    fetchTotalBalance();
    fetchDataFromFirebase();
  }

  var totalBalance = "Loading...";
  List colo = [
    Colors.red,
    Colors.green,
    Colors.red,
    Colors.green,
    Colors.red,
    Colors.green,
    Colors.red,
    Colors.green,
  ];

  final bankName = TextEditingController();
  final accHolderName = TextEditingController();
  final accountNumber = TextEditingController();
  final openingBalance = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    bankName.dispose();
    super.dispose();
  }

  Future<void> sendDataToFirebase() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    // Replace with your Firestore document ID
    String documentId = user!.uid;

    // Get the document you want to update
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(documentId).get();

    // Get the existing array data
    List ExistingBankNameList = documentSnapshot.get('BankName');
    List ExistingBankNumberList = documentSnapshot.get('AccNo');
    List ExistingBankHolderList = documentSnapshot.get('AccHolder');
    List ExistingBankAmount = documentSnapshot.get('OpeningAmount');

    // Add the new variable to the array

    ExistingBankNameList.insert(0, bankName.text);

    ExistingBankNumberList.insert(0, accountNumber.text);
    ExistingBankHolderList.insert(0, accHolderName.text);
    ExistingBankAmount.insert(0, 0);

    // Update the Firestore document with the new array
    await collectionReference.doc(documentId).update({
      'BankName': ExistingBankNameList,
    });
    await collectionReference.doc(documentId).update({
      'AccNo': ExistingBankNumberList,
    });
    await collectionReference.doc(documentId).update({
      'AccHolder': ExistingBankHolderList,
    });
    await collectionReference.doc(documentId).update({
      'OpeningAmount': ExistingBankAmount,
    });
  }

  num? cashBalance;

  Future<void> fetchDataFromFirebase() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    // Replace with your Firestore document ID
    String documentId = user!.uid;

    // Get the document you want to update
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(documentId).get();

    // Get the existing array data

    if (documentSnapshot.data() != null) {
      fetchBankNameList = documentSnapshot.get('BankName');
      fetchBankNumberList = documentSnapshot.get('AccNo');
      fetchBankHolderList = documentSnapshot.get('AccHolder');
      fetchBankAmount = documentSnapshot.get('OpeningAmount');
      cashBalance = documentSnapshot.get('CashBalance');
      cash = documentSnapshot.get('CashBalance');

      sum = fetchBankAmount.fold(
          0, (previous, current) => previous + (current ?? 0.0));

      total = cash.roundToDouble() + sum;

      print(sum.round());
      setState(() {});
    }
  }

  List ExistingBankNameList = [];
  List ExistingBankNumberList = [];
  List ExistingBankHolderList = [];
  List ExistingBankAmount = [];
  late double sum = 0;
  int cash = 0;

  late double total = 0;

  List fetchBankNameList = [];
  List fetchBankNumberList = [];
  List fetchBankHolderList = [];
  List fetchBankAmount = [];

  final formkey = GlobalKey<FormState>();

  Future<String> getTotalBalance() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        print("HEllo");
        return userDoc['Total Balance'].toString();
      }
    }
    return 'Total Balance Not Found';
  }

  void fetchTotalBalance() async {
    // You can use the getUserFirstName function from the previous answer
    String totalbalance = await getTotalBalance();
    setState(() {
      totalBalance = totalbalance;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        // height: double.infinity,
        // width: double.infinity,
        decoration: const BoxDecoration(
          // color: Colors.transparent,
          color: Color(0xFF141E46),
        ),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Hello, " + '${widget.User}',
                        //   style: GoogleFonts.montserrat(
                        //       fontSize: 23,
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold),
                        // ),
                      ]),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        // height: ,

                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 214, 190, 191)
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(245, 0, 0, 0)
                                  .withOpacity(
                                      0.2), // Adjust shadow color and opacity
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Total Balance : ",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text("₹ $total",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700))
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20),
                              child: Divider(
                                height: 10,
                                color: Colors.white,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Bank : ",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(sum.round().toString(),
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Cash : ",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(cashBalance.toString(),
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                // height: 2150,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Banks",
                            style: GoogleFonts.montserrat(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      elevation: 10,
                                      backgroundColor: Colors.white,
                                      content: Form(
                                        key: formkey,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,

                                                // readOnly: true,

                                                controller: bankName,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  prefixIcon: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10.0),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .indianRupeeSign,
                                                      // fill: Checkbox.width,
                                                      size: 14,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 2),
                                                    ),
                                                  ),
                                                  fillColor:
                                                      const Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  filled: true,
                                                  hintText: "Bank Name",
                                                  hintStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  label: Text(
                                                    "Bank Name",
                                                    style: GoogleFonts.acme(
                                                        textStyle:
                                                            const TextStyle(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                decorationColor:
                                                                    Colors
                                                                        .white,
                                                                // overflow: TextOverflow.fade,
                                                                textBaseline:
                                                                    TextBaseline
                                                                        .ideographic,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                letterSpacing:
                                                                    1)),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 15,
                                                          horizontal: 15),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                  border: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 2,
                                                            style: BorderStyle
                                                                .solid,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "please add Bank Name";
                                                  }
                                                  return null;
                                                },
                                              ), //Amount Text Field
                                              SizedBox(
                                                height: 15,
                                              ),
                                              TextFormField(
                                                controller: accountNumber,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "please add Account Number";
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    prefixIcon: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10.0),
                                                      child: Icon(
                                                        Icons.question_answer,
                                                        // fill: Checkbox.width,
                                                        size: 14,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 2),
                                                      ),
                                                    ),
                                                    fillColor: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    filled: true,
                                                    hintText: "Acc. Num",
                                                    hintStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    label: Text(
                                                      "Account Number",
                                                      style: GoogleFonts.acme(
                                                          textStyle:
                                                              const TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  decorationColor:
                                                                      Colors
                                                                          .white,
                                                                  // overflow: TextOverflow.fade,
                                                                  textBaseline:
                                                                      TextBaseline
                                                                          .ideographic,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  letterSpacing:
                                                                      1)),
                                                    ),
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 15),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(
                                                            width: 2,
                                                            style: BorderStyle
                                                                .solid,
                                                            color: Color.fromARGB(
                                                                255, 0, 0, 0)),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(
                                                            width: 2,
                                                            style: BorderStyle.solid,
                                                            color: Color.fromARGB(255, 0, 0, 0)),
                                                        borderRadius: BorderRadius.circular(12)),
                                                    border: OutlineInputBorder(borderSide: const BorderSide(width: 2, style: BorderStyle.solid, color: Color.fromARGB(255, 0, 0, 0)), borderRadius: BorderRadius.circular(12))),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              TextFormField(
                                                controller: accHolderName,
                                                keyboardType:
                                                    TextInputType.text,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "please add Account Holder Name";
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    prefixIcon: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10.0),
                                                      child: Icon(
                                                        Icons.question_answer,
                                                        // fill: Checkbox.width,
                                                        size: 14,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 2),
                                                      ),
                                                    ),
                                                    fillColor: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    filled: true,
                                                    hintText:
                                                        "Acc. Holder Name",
                                                    hintStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    label: Text(
                                                      "Account Holder Name",
                                                      style: GoogleFonts.acme(
                                                          textStyle:
                                                              const TextStyle(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  decorationColor:
                                                                      Colors
                                                                          .white,
                                                                  // overflow: TextOverflow.fade,
                                                                  textBaseline:
                                                                      TextBaseline
                                                                          .ideographic,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  letterSpacing:
                                                                      1)),
                                                    ),
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 15),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(
                                                            width: 2,
                                                            style: BorderStyle
                                                                .solid,
                                                            color: Color.fromARGB(
                                                                255, 0, 0, 0)),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(
                                                            width: 2,
                                                            style: BorderStyle.solid,
                                                            color: Color.fromARGB(255, 0, 0, 0)),
                                                        borderRadius: BorderRadius.circular(12)),
                                                    border: OutlineInputBorder(borderSide: const BorderSide(width: 2, style: BorderStyle.solid, color: Color.fromARGB(255, 0, 0, 0)), borderRadius: BorderRadius.circular(12))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            if (formkey.currentState!
                                                .validate()) {
                                              setState(() {
                                                sendDataToFirebase();
                                                fetchDataFromFirebase();
                                                Navigator.of(context).pop();
                                              });
                                              // setState(() {});
                                            }
                                          },
                                          child: const Text('Set'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.add))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: RefreshIndicator(
                            onRefresh: () => fetchDataFromFirebase(),
                            child: ListView.builder(
                              // physics: const BouncingScrollPhysics(),
                              itemCount: fetchBankNameList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                            color: const Color.fromARGB(
                                                    245, 72, 48, 48)
                                                .withOpacity(
                                                    0.2), // Adjust shadow color and opacity
                                            blurRadius: 10,
                                            spreadRadius: 4),
                                      ],
                                    ),
                                    height: 180,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0, top: 8),
                                              child: Text(
                                                fetchBankNameList[index]
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, top: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                fetchBankNumberList[index]
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, top: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                fetchBankHolderList[index]
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 8, right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Account Balance :",
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    fetchBankAmount[index]
                                                        .toString(),
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
