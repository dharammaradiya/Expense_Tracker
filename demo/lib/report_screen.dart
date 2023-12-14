import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/Login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Report_screen extends StatefulWidget {
  const Report_screen({Key? key}) : super(key: key);

  @override
  State<Report_screen> createState() => _Report_screenState();
}

class _Report_screenState extends State<Report_screen> {
  @override
  void initState() {
    super.initState();
    // _selectToDate(context);s
    // Call the function to get the user's first name when the screen loads
    fetchDataFromFirebase();
    // _selectToDate(context);
  }

  // final String User;
  final user = FirebaseAuth.instance.currentUser;

  List indexList = [];

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
      ExistingAmountList = documentSnapshot.get('Amount');
      ExistingDateList = documentSnapshot.get('Date');
      ExistingReasonList = documentSnapshot.get('Reason');
      selectedCatag = documentSnapshot.get('SelectedcCatag');
      sum = ExistingAmountList.fold(
          0, (previous, current) => previous + (current ?? 0.0));
      print(sum);
      print(ExistingAmountList);
      print(ExistingDateList);
      print(ExistingReasonList);

      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }

  List ExistingAmountList = [];
  List ExistingDateList = [];
  List ExistingReasonList = [];
  List selectedCatag = [];
  List amountHistoryout = [];
  List dateHistoryout = [];
  List resonHistoryout = [];
  List catagHistoryout = [];
  late double sumofnegout = 0;
  late double sumofposout = 0;

  late double sum = 0.0;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  Future _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    List<int> indices = [];

    indexList = indices;

    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
      final List<String> days = [];

      // Create a list of dates between the start and end dates
      for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
        days.add(
            DateFormat('dd-MM-yyyy').format(fromDate.add(Duration(days: i))));
      }
      // days.add(DateFormat('dd-MM-yyyy').format(toDate));

      // Print the list of dates, including the selected 'to' date
      // ...
      List<List<Map<String, dynamic>>> allMatchingDataList = [];

// Inside _selectToDate function, after the for loop
      for (var date in days) {
        // print(date);

        // Find all occurrences of the date in ExistingDateList
        int index = ExistingDateList.indexOf(date);
        while (index != -1) {
          indices.add(index);
          index = ExistingDateList.indexOf(date, index + 1);
        }

        if (indices.isNotEmpty) {
          // Date found in ExistingDateList
          // print("Indices in ExistingDateList: $indices");

          // Collect all matching data in a list of maps
          List<Map<String, dynamic>> matchingDataList = [];
          // for (var i in indices) {
          //   Map<String, dynamic> matchingData = {
          //     'Amount': ExistingAmountList[i],
          //     'Date': ExistingDateList[i],
          //     'Reason': ExistingReasonList[i],
          //     'Category': selectedCatag[i],
          //   };
          //   matchingDataList.add(matchingData);
          // }

          allMatchingDataList.add(matchingDataList);
        } else {
          print("Date not found in ExistingDateList");
        }
      }

      List amountHistory = [];
      List dateHistory = [];
      List resonHistory = [];
      List catagHistory = [];
      List positiveAmountList = [];
      List negativeAmountList = [];
      var sumofpos = 0.0;
      var sumofneg = 0.0;

      amountHistoryout = amountHistory;
      dateHistoryout = dateHistory;
      resonHistoryout = resonHistory;
      catagHistoryout = catagHistory;

      for (var index in indexList) {
        if (index >= 0 && index < ExistingAmountList.length) {
          amountHistory.add(ExistingAmountList[index]);
          dateHistory.add(ExistingDateList[index]);
          resonHistory.add(ExistingReasonList[index]);
          catagHistory.add(selectedCatag[index]);
        }
      }

      // print(allMatchingDataList);
      print(indices);
      print("Selected Amount List: $amountHistory");
      print("Selected Date List: $dateHistory");
      print("Selected Reason List: $resonHistory");
      print("Selected Category List: $catagHistory");

      for (var amount in amountHistory) {
        if (amount > 0) {
          positiveAmountList.add(amount);
        } else if (amount < 0) {
          negativeAmountList.add(amount);
        }
      }

      sumofpos = positiveAmountList.fold(
          0, (previous, current) => previous + (current ?? 0.0));

      sumofneg = negativeAmountList.fold(
          0, (previous, current) => previous + (current ?? 0.0));

      sumofnegout = sumofneg;
      sumofposout = sumofpos;

      setState(() {});
      // print(indexList);

// ...
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141E46),
            // gradient: LinearGradient(
            //     begin: Alignment.topRight,
            //     end: Alignment.bottomLeft,
            //     colors: [
            //       Color.fromARGB(255, 88, 138, 224),
            //       Color.fromARGB(255, 238, 143, 137)
            //     ]),
          ),
          child: Column(
            children: [
              Container(
                height: 300,
                color: Colors.transparent,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 30.0, left: 30, top: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => _selectFromDate(context),
                              child: Text(
                                  'From: ${DateFormat('dd-MM-yyyy').format(fromDate)}'),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectToDate(context),
                              child: Text(
                                  'To: ${DateFormat('dd-MM-yyyy').format(toDate)}'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 214, 190, 191)
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                      "Statistics : ",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
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
                                      "Income : ",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(sumofposout.toString(),
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700))
                                  ],
                                ),
                              ),
                              // const Padding(
                              //   padding: EdgeInsets.only(left: 8.0, right: 8),
                              //   child: Divider(
                              //     height: 10,
                              //     color: Colors.white,
                              //     thickness: 1,
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Expenses : ",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(sumofnegout.toString(),
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
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 20),
                          child: Text(
                            "History",
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          color: Color.fromARGB(255, 255, 255, 255),
                          child: ListView.builder(
                            itemCount: amountHistoryout.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: amountHistoryout[index] < 0
                                        ? Color.fromARGB(255, 189, 96, 126)
                                        : Color(0xFFd8fbc5),
                                  ),
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(14),
                                              bottomLeft: Radius.circular(14)),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 24.0,
                                            ),
                                            child: Text(
                                              catagHistoryout[index].toString(),
                                              style: GoogleFonts.roboto(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 100.0),
                                        child: Row(
                                          children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(amountHistoryout[index]
                                                      .toString()),
                                                  Text(dateHistoryout[index]
                                                      .toString())
                                                ]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
