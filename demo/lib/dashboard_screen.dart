import 'package:demo/Login_screen.dart';
import 'package:demo/report_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Bank_select_screen.dart';
import 'catagory_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

GlobalKey<_landing_page> alertDialogKey = GlobalKey<_landing_page>();

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
    required this.User,
  }) : super(key: key);
  final String User;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser;
  String firstName = "Loading...";
  // String totalBalance = "Loading...";
// Retrieve and display the user's first name
  Future getUserFirstName(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get();
      if (userDoc.data() != null) {
        return userDoc['First Name '];
      }
    }
    // ignore: use_build_context_synchronously
    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ));
  }

  void fetchUserFirstName() async {
    // You can use the getUserFirstName function from the previous answer
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    // Replace with your Firestore document ID
    String documentId = user!.uid;

    // Get the document you want to update
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(documentId).get();

    if (documentSnapshot.data() != null) {
      String userFirstName = await getUserFirstName(context);
      setState(() {
        firstName = userFirstName;
      });
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ));
    }
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

  void fetchcat() async {
    // You can use the getUserFirstName function from the previous answer
    List userCatag = await fetchCat();
    setState(() {
      catag = userCatag;
    });
  }

  int pageIndex = 0;
  final PageController _pageController = PageController();
  final name = FirebaseAuth.instance.currentUser?.email;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Call the function to get the user's first name when the screen loads
    fetchUserFirstName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $firstName'),
        backgroundColor: const Color(0xFF141E46),
        automaticallyImplyLeading: false,
        // toolbarHeight: 60,
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                try {
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    // FirebaseAuth.instance.currentUser?.delete();
                    FirebaseAuth.instance.signOut();

                    // Delete the user document

                    Navigator.pop(context); // Pop the Dashboard screen

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  }
                } catch (e) {
                  print("Error signing out: $e");
                }
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        children: [
          landing_page(
            User: widget.User,
          ),
          bank_screen(User: widget.User),
          const Catagory_add(),
          const Report_screen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 55,
        decoration: const BoxDecoration(
          color: Color(0xFF141E46),
          shape: BoxShape.rectangle,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF141E46),

          // iconSize: 20,

          fixedColor: const Color.fromARGB(255, 255, 240, 240),
          showUnselectedLabels: true,
          unselectedItemColor: Colors.white30,

          elevation: 100,
          currentIndex: pageIndex,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard_sharp,
                color: Colors.white,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.buildingColumns,
                color: Colors.white,
              ),
              label: 'Bank',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category_sharp,
                color: Colors.white,
              ),
              // backgroundColor: Colors.transparent,
              label: 'Catagory',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.book,
                color: Colors.white,
              ),
              label: 'Report',
              // backgroundColor: Colors.transparent
            ),
          ],
        ),
      ),
    );
  }
}

class landing_page extends StatefulWidget {
  const landing_page({Key? key, required this.User}) : super(key: key);
  final String User;

  @override
  State<landing_page> createState() => _landing_page();
}

class _landing_page extends State<landing_page> {
  @override
  void initState() {
    super.initState();
    sum = 0;

    fetchDataFromFirebase();
    // dropdownvalue = "";
    // Call the function to get the user's first name when the screen loads
    fetchTotalBalance();
  }

  final user = FirebaseAuth.instance.currentUser;
  String totalBalance = "Loading...";

  List amount = [];
  List date = [];
  List catag = [];
  List reason = [];
  List existingarr = [];
  List BankNameArr = [];
  List Bankselect = [];
  num cashBalance = 0;

  void getCatag() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    // Replace with your Firestore document ID
    String documentId = user!.uid;

    // Get the document you want to update
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(documentId).get();
    setState(() {
      existingarr = documentSnapshot.get('Catagory');
      BankNameArr = documentSnapshot.get('OpeningAmount');
    });

    if (existingarr.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter at least One Catagory",
          backgroundColor: const Color(0xFF141E46),
          textColor: Colors.white);
    } else if (BankNameArr.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Enter at least One Bank",
          backgroundColor: const Color(0xFF141E46),
          textColor: Colors.white);
    } else {
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder: ((context) {
          return const CustomPopUp();
        }),
      );
    }
    // Get the existing array data
  }

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

  List<dynamic> BankAmount = [];
  // List<dynamic> SelectBank = [];

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
      BankAmount = documentSnapshot.get('OpeningAmount');
      BankNameArr = documentSnapshot.get('BankName');

      ExistingAmountList = documentSnapshot.get('Amount');
      ExistingDateList = documentSnapshot.get('Date');
      ExistingReasonList = documentSnapshot.get('Reason');
      selectedCatag = documentSnapshot.get('SelectedcCatag');
      sum = ExistingAmountList.fold(
          0, (previous, current) => previous + (current ?? 0.0));
      print(sum);
      setState(() {});
    } else {
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

  late double sum = 0.0;

  // Future<void> deletDataFromFirebase() async {
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('User');
  //   String documentId = user!.uid;

  //   // Get the document you want to update

  //   ExistingAmountList.remove(Index);
  //   ExistingDateList.remove(Index);
  //   ExistingReasonList.remove(Index);
  //   selectedCatag.remove(Index);

  //   collectionReference.doc(documentId).update({
  //     'Amount': ExistingAmountList,
  //     'Date': ExistingDateList,
  //     'Reason': ExistingReasonList,
  //     'SelectedcCatag': selectedCatag
  //   });
  // }

  void fetchTotalBalance() async {
    // You can use the getUserFirstName function from the previous answer
    String totalbalance = await getTotalBalance();
    setState(() {
      totalBalance = totalbalance;
    });
  }

  Widget build(BuildContext context) {
    print('Rebuilding widget');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: const Drawer(),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            // color: Colors.black,
            decoration: const BoxDecoration(
              color: Color(0xFF141E46),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(22.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "Account Balance",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "₹",
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          sum.toString(),
                          style: GoogleFonts.montserrat(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recent Transaction",
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    getCatag();
                                    // showDialog(
                                    //   context: context,
                                    //   builder: ((context) {
                                    //     return CustomPopUp();
                                    //   }),
                                    // );
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: MediaQuery.removePadding(
                            removeBottom: true,
                            context: context,
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await fetchDataFromFirebase();
                                setState(() {});
                                // setState(() {
                                //   fetchDataFromFirebase();
                                // });
                              },
                              child: ListView.builder(
                                itemCount: ExistingAmountList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: ExistingAmountList[index] < 0
                                            ? const Color.fromARGB(255, 189, 96, 126)
                                            : const Color(0xFFd8fbc5),
                                      ),
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(14),
                                                  bottomLeft:
                                                      Radius.circular(14)),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 24.0),
                                                child: Text(
                                                  selectedCatag[index]
                                                      .toString(),
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(ExistingAmountList[index]
                                                    .toString()),
                                                Text(ExistingDateList[index]
                                                    .toString())
                                              ]),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: IconButton(
                                                onPressed: () async {
                                                  CollectionReference
                                                      collectionReference =
                                                      FirebaseFirestore.instance
                                                          .collection('User');
                                                  String documentId = user!.uid;

                                                  DocumentSnapshot
                                                      documentSnapshot =
                                                      await collectionReference
                                                          .doc(documentId)
                                                          .get();

                                                  List<dynamic> amount =
                                                      documentSnapshot
                                                          .get('Amount');
                                                  List<dynamic> reason =
                                                      documentSnapshot
                                                          .get('Reason');
                                                  List<dynamic> date =
                                                      documentSnapshot
                                                          .get('Date');
                                                  List<dynamic> catag =
                                                      documentSnapshot.get(
                                                          'SelectedcCatag');
                                                  List<dynamic> Bankselect =
                                                      documentSnapshot
                                                          .get('SelectedBank');
                                                  cashBalance = documentSnapshot
                                                      .get('CashBalance');

                                                  if (index >= 0 &&
                                                      index < amount.length) {
                                                    var SelectedBankName =
                                                        Bankselect[index];

                                                    if (ExistingAmountList[
                                                                index] <
                                                            0 &&
                                                        Bankselect[index] !=
                                                            "Cash") {
                                                      BankAmount[BankNameArr
                                                              .indexOf(
                                                                  SelectedBankName)] +=
                                                          -ExistingAmountList[
                                                              index];
                                                    } else if (ExistingAmountList[
                                                                index] >
                                                            0 &&
                                                        Bankselect[index] !=
                                                            "Cash") {
                                                      BankAmount[BankNameArr
                                                              .indexOf(
                                                                  SelectedBankName)] -=
                                                          ExistingAmountList[
                                                              index];
                                                    } else if (ExistingAmountList[
                                                                index] <
                                                            0 &&
                                                        Bankselect[index] ==
                                                            "Cash") {
                                                      cashBalance +=
                                                          -ExistingAmountList[
                                                              index];
                                                    } else if (ExistingAmountList[
                                                                index] >
                                                            0 &&
                                                        Bankselect[index] ==
                                                            "Cash") {
                                                      cashBalance +=
                                                          -ExistingAmountList[
                                                              index];
                                                    }

                                                    // Remove elements at the specified index
                                                    amount.removeAt(index);
                                                    reason.removeAt(index);
                                                    date.removeAt(index);
                                                    catag.removeAt(index);
                                                    Bankselect.removeAt(index);

                                                    await collectionReference
                                                        .doc(documentId)
                                                        .update({
                                                      'Amount': amount,
                                                      'Date': date,
                                                      'Reason': reason,
                                                      'SelectedcCatag': catag,
                                                      'OpeningAmount':
                                                          BankAmount,
                                                      'SelectedBank':
                                                          Bankselect,
                                                      'CashBalance':
                                                          cashBalance,
                                                    });

                                                    setState(() {
                                                      ExistingAmountList
                                                          .removeAt(index);
                                                      ExistingDateList.removeAt(
                                                          index);
                                                      ExistingReasonList
                                                          .removeAt(index);
                                                      selectedCatag
                                                          .removeAt(index);
                                                      fetchDataFromFirebase();
                                                    });
                                                  } else {
                                                    print(
                                                        "Index out of bounds");
                                                  }
                                                  ;

                                                  print("delete");
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 30,
                                                ),),
                                          ),
                                        ],
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPopUp extends StatefulWidget {
  const CustomPopUp({super.key});

  @override
  State<CustomPopUp> createState() => CustomPopUpState();
}

class CustomPopUpState extends State<CustomPopUp> {
  final amount = TextEditingController();
  final reason = TextEditingController();
  final datetime = TextEditingController();

  List<dynamic> existingarr = [];
  List<dynamic> BankNameArr = [];
  List<int> BankAmount = [];
  int CashBalance = 0;

  var dropdownvalue;
  var bankDropDownValue;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> updateCashBalance() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    // Replace with your Firestore document ID
    String documentId = user!.uid;

    // Get the document you want to update
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(documentId).get();

    num cashbalance = documentSnapshot.get('CashBalance');

    if (isSelected[0]) {
      cashbalance = cashbalance + int.parse(amount.text);
    } else {
      cashbalance = cashbalance - (int.parse(amount.text));
    } // cashbalance = cashbalance + int.parse(amount.text);

    await collectionReference.doc(documentId).update({
      'CashBalance': cashbalance,
    });
  }

  Future<void> updateBankAmount() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    // Replace with your Firestore document ID
    String documentId = user!.uid;

    // Get the document you want to update
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(documentId).get();

    List BankAmount = documentSnapshot.get('OpeningAmount');

    if (isSelected[0] == true && isSelected[1] == false) {
      BankAmount[BankNameArr.indexOf(bankDropDownValue)] =
          BankAmount[BankNameArr.indexOf(bankDropDownValue)] +
              int.parse(amount.text);
    } else {
      BankAmount[BankNameArr.indexOf(bankDropDownValue)] =
          BankAmount[BankNameArr.indexOf(bankDropDownValue)] +
              (int.parse(amount.text) - (int.parse(amount.text) * 2));
    }
    await collectionReference.doc(documentId).update({
      'OpeningAmount': BankAmount,
    });
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
    List ExistingAmountList = documentSnapshot.get('Amount');
    List ExistingDateList = documentSnapshot.get('Date');
    List ExistingReasonList = documentSnapshot.get('Reason');
    List selectedCatag = documentSnapshot.get('SelectedcCatag');

    List SelectedBank = documentSnapshot.get('SelectedBank');

    // Add the new variable to the array
    if (isSelected[0]) {
      ExistingAmountList.insert(0, int.parse(amount.text));
    } else {
      ExistingAmountList.insert(
          0, int.parse(amount.text) - (int.parse(amount.text) * 2));
    }
    ExistingDateList.insert(0, datetime.text);
    ExistingReasonList.insert(0, reason.text);
    selectedCatag.insert(0, dropdownvalue);
    if (isCashOrCard[0] == true) {
      SelectedBank.insert(0, 'Cash');
    } else {
      SelectedBank.insert(0, bankDropDownValue);
    }

    // Update the Firestore document with the new array
    await collectionReference.doc(documentId).update({
      'Amount': ExistingAmountList,
    });
    await collectionReference.doc(documentId).update({
      'Date': ExistingDateList,
    });
    await collectionReference.doc(documentId).update({
      'Reason': ExistingReasonList,
    });
    await collectionReference.doc(documentId).update({
      'SelectedcCatag': selectedCatag,
    });
    await collectionReference.doc(documentId).update({
      'SelectedBank': SelectedBank,
    });
  }

  List<bool> isSelected = [true, false];
  List<bool> isCashOrCard = [true, false];
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    datetime.text = "";
    getCatag();

    // dropdownvalue = "";
    // Call the function to get the user's first name when the screen loads
  }

  void getCatag() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('User');

    // Replace with your Firestore document ID
    String documentId = user!.uid;

    // Get the document you want to update
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(documentId).get();
    setState(() {
      existingarr = documentSnapshot.get('Catagory');
      BankNameArr = documentSnapshot.get('BankName');

      dropdownvalue = existingarr.first;
      bankDropDownValue = BankNameArr.first;
    });
    // Get the existing array data
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 20,
      backgroundColor: Colors.white,
      content: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                // readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please add Amount";
                  } else if (amount.text == "0") {
                    return "please add more amount";
                  }
                  return null;
                },

                controller: amount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10.0),
                      child: Icon(
                        FontAwesomeIcons.indianRupeeSign,
                        // fill: Checkbox.width,
                        size: 14,
                        color: Color.fromARGB(255, 0, 0, 2),
                      ),
                    ),
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    hintText: "Amount",
                    hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                    label: Text(
                      "Add Amount",
                      style: GoogleFonts.acme(
                          textStyle: const TextStyle(
                              backgroundColor: Colors.white,
                              decorationColor: Colors.white,
                              // overflow: TextOverflow.fade,
                              textBaseline: TextBaseline.ideographic,
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 20,
              ), //Amount Text Field
              TextFormField(
                controller: reason,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please Add Your Reason";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10.0),
                      child: Icon(
                        Icons.question_answer,
                        // fill: Checkbox.width,
                        size: 14,
                        color: Color.fromARGB(255, 0, 0, 2),
                      ),
                    ),
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    hintText: "Reason",
                    hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                    label: Text(
                      "Your Reason",
                      style: GoogleFonts.acme(
                          textStyle: const TextStyle(
                              backgroundColor: Colors.white,
                              decorationColor: Colors.white,
                              // overflow: TextOverflow.fade,
                              textBaseline: TextBaseline.ideographic,
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: datetime,
                keyboardType: TextInputType.none,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please Add Current Date";
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime.now());

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      datetime.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10.0),
                      child: Icon(
                        Icons.question_answer,
                        // fill: Checkbox.width,
                        size: 14,
                        color: Color.fromARGB(255, 0, 0, 2),
                      ),
                    ),
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                    hintText: "Date",
                    hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                    label: Text(
                      "Enter Date",
                      style: GoogleFonts.acme(
                          textStyle: const TextStyle(
                              backgroundColor: Colors.white,
                              decorationColor: Colors.white,
                              // overflow: TextOverflow.fade,
                              textBaseline: TextBaseline.ideographic,
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        borderRadius: BorderRadius.circular(12)),
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
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Catagory : "),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          hint: const Text("Catagory"),

                          // dropdownColor: Colors.black,

                          value: dropdownvalue,
                          alignment: Alignment.center,
                          style: GoogleFonts.montserrat(
                              color: Colors.black, fontSize: 16),

                          isDense: true,
                          elevation: 0,

                          autofocus: true,
                          borderRadius: BorderRadius.circular(10),
                          focusColor: Colors.blue,

                          // isExpanded: true,
                          items: existingarr.map((items) {
                            return DropdownMenuItem(
                              // enabled: true,
                              value: items,
                              child: Text(
                                items,
                                selectionColor: Colors.black,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownvalue = newValue;
                              print(dropdownvalue);
                              alertDialogKey.currentState?.setState(() {});
                              // print(existingarr);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  isSelected: isSelected,
                  onPressed: (index) {
                    setState(() {
                      isSelected[index] = !isSelected[index];
                      // If you want only one option to be selected at a time
                      if (index == 0) {
                        isSelected[1] = !isSelected[0];
                      } else {
                        isSelected[0] = !isSelected[1];
                      }
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 30, left: 30),
                      child: Icon(Icons.trending_up),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 30.0, left: 30),
                      child: Icon(Icons.trending_down),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ToggleButtons(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
                isSelected: isCashOrCard,
                onPressed: (index) {
                  setState(() {
                    isCashOrCard[index] = !isCashOrCard[index];
                    // If you want only one option to be selected at a time
                    if (index == 0) {
                      isCashOrCard[1] = !isCashOrCard[0];
                    } else {
                      isCashOrCard[0] = !isCashOrCard[1];
                    }
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 30, left: 30),
                    child: Icon(FontAwesomeIcons.indianRupeeSign),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 30.0, left: 30),
                    child: Icon(Icons.credit_card),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: isCashOrCard[1] ? true : false,
                child: DropdownButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  hint: const Text("Catagory"),

                  // dropdownColor: Colors.black,

                  value: bankDropDownValue,
                  alignment: Alignment.center,
                  style:
                      GoogleFonts.montserrat(color: Colors.black, fontSize: 16),

                  isDense: true,
                  elevation: 0,

                  autofocus: true,
                  borderRadius: BorderRadius.circular(10),
                  focusColor: Colors.blue,

                  // isExpanded: true,
                  items: BankNameArr.map((items) {
                    return DropdownMenuItem(
                      // enabled: true,
                      value: items,
                      child: Text(
                        items,
                        selectionColor: Colors.black,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      bankDropDownValue = newValue;
                      print(dropdownvalue);
                      alertDialogKey.currentState?.setState(() {});
                      // print(existingarr);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (formkey.currentState!.validate()) {
              setState(() {
                sendDataToFirebase();

                if (isCashOrCard[0] == true) {
                  updateCashBalance();
                } else {
                  print(existingarr.indexOf(dropdownvalue));

                  updateBankAmount();
                }
              });

              Navigator.of(context).pop();
            }
          },
          child: const Text('Set'),
        ),
      ],
    );
  }
}
