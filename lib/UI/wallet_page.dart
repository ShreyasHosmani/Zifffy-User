import 'dart:io';
import 'package:dabbawala/UI/my_meals_page.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dabbawala/UI/data/wallet_data.dart' as wallet;
import 'dart:convert';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'data/globals_data.dart';
import 'my_account_page.dart';

var walletBalance;

TextEditingController addMoneyController = TextEditingController();

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  Razorpay _razorpay;

  Future<String> getWallet(context) async {

    String url = globals.apiUrl + "getcustomerwallet.php";

    http.post(url, body: {

      "userID" : storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetWallet = jsonDecode(response.body);
      print(responseArrayGetWallet);

      var responseArrayGetWalletMsg = responseArrayGetWallet['message'].toString();
      print(responseArrayGetWalletMsg);

      if(statusCode == 200){
        if(responseArrayGetWalletMsg == "Item Found"){

          setState(() {
            walletBalance = responseArrayGetWallet['data']['customerwalletBalance'].toString();
          });
          print(walletBalance);

        }else{

          Fluttertoast.showToast(msg: 'You have 0 balance currently', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  Future<String> addMoneyToWallet(context) async {

    String url = globals.apiUrl + "addmoneytowallet.php";

    http.post(url, body: {

      "customerid" : storedUserId.toString(),
      "amnt" : addMoneyController.text.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayAddMoney = jsonDecode(response.body);
      print(responseArrayAddMoney);

      var responseArrayAddMoneyMsg = responseArrayAddMoney['message'].toString();
      print(responseArrayAddMoneyMsg);

      if(statusCode == 200){
        if(responseArrayAddMoneyMsg == "true"){

          Fluttertoast.showToast(msg: 'Money added successfully!', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            getWallet(context);
          });

        }else{

          Fluttertoast.showToast(msg: 'You have 0 balance currently', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_x3INZuXXf81aZB',
      'amount': int.parse(addMoneyController.text.toString())*100,
      'name': 'Zifffy',
      'description': 'Request for adding money to wallet',
      'image' : '',
      'prefill': {'contact': '$tempPhone', 'email': '$tempEmail'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "SUCCESS: " + response.paymentId,).whenComplete((){
      addMoneyToWallet(context);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
//    Fluttertoast.showToast(
//      msg: "ERROR: " + response.code.toString() + " - " + response.message,);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
//    Fluttertoast.showToast(
//      msg: "EXTERNAL_WALLET: " + response.walletName,);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    wallet.order = 0;
    walletBalance = null;
    getWallet(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          showDialog(
            context: context,
            builder: (context) =>
            new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit the App'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => exit(0),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Yes"),
                  ),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("No"),
                  ),
                ),
              ],
            ),

          ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: walletBalance == null ? Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100,left: 5,right: 5),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1,
                  height: MediaQuery.of(context).size.height /10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      color: Colors.blue[700]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Align(
                alignment: Alignment.topCenter,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.white,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 6.8,
                    width: MediaQuery.of(context).size.width / 2.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 20,
                      color: Colors.blue[700],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
//                          Text(
//                            currencySymbl+walletBalance,textScaleFactor: 1,
//                            style: GoogleFonts.nunitoSans(
//                                fontSize: 30,
//                                color: Colors.white,
//                                fontWeight: FontWeight.w400),
//                          ),
//                          Text(
//                            'Wallet Balance',
//                            textScaleFactor: 1,
//                            style: GoogleFonts.nunitoSans(
//                                fontSize: 16,
//                                color: Colors.white,
//                                fontWeight: FontWeight.bold),
//                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 170),
              child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.white,
                  child: buildWalletAddMoney(context)),
            ),
          ],
        ) : buildWalletContainer(context),
      ),
    );
  }

  Widget buildWalletContainer(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100,left: 5,right: 5),
          child: Container(
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height /10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.blue[700]),
          ),
        ),
        buildWalletAmountContainer(context),
        Padding(
          padding: const EdgeInsets.only(top: 170),
          child: buildWalletAddMoney(context),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 250, left: 20, right: 20),
          child: Text("You can use this money to order food items soon!",
            textAlign: TextAlign.center,
            textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWalletAmountContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: MediaQuery.of(context).size.height / 6.8,
          width: MediaQuery.of(context).size.width / 2.25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 20,
            color: Colors.blue[700],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  currencySymbl+walletBalance,textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'Wallet Balance',
                  textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWalletAddMoney(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5,right: 5),
      child: Container(
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.height / 15,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
            color: Colors.blue[700]),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: Text(
              'Add Money :',
              textScaleFactor: 1,
              style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.4,
              height: MediaQuery.of(context).size.height / 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white),
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: TextFormField(
                    controller: addMoneyController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 0),
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: globals.currencySymbl,
                      hintStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white),
                        gapPadding: 10,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.white),
                          gapPadding: 10),
                    ),
                  )),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 22,
            child: RaisedButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  'Confirm',
                  textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black),
                ),
                onPressed: () {
                  if(addMoneyController.text.toString() == "" || addMoneyController.text.toString() == " "){
                    Fluttertoast.showToast(msg: 'Field cannot be empty!', backgroundColor: Colors.black, textColor: Colors.white);
                  }else{
                    openCheckout();
                  }
                }),
          )
        ]),
      ),
    );
  }

  Widget buildWalletAndOrderHistoryButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                wallet.order = 1;
              });
            },

            child: Container(
              padding: EdgeInsets.only(left: 30, top: 12),
              width: MediaQuery.of(context).size.width / 2.2,
              height: MediaQuery.of(context).size.height / 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                color: Colors.blue[700],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Text(
                'View Wallet History',
                style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => MyMeals(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  ));
            },
            child: Container(
              padding: EdgeInsets.only(left: 30, top: 12),
              width: MediaQuery.of(context).size.width / 2.2,
              height: MediaQuery.of(context).size.height / 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                color: Colors.blue[700],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Text(
                'View Order History',
                style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
  //
  Widget buildPiggyBankImage(BuildContext context) {
    return Center(
      child: Container(
        height:200,
        width: 180,
        color: Colors.white,
        child: Center(
          child: Image.asset('assets/images/piggybank.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget buildWalletHistory(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left:10,right: 10),
        child: Container(
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width / 1,
            color: Colors.white,
            child: ListView.builder(
              padding: EdgeInsets.all(0.0),
              scrollDirection: Axis.vertical,
              itemCount: 20,
              itemBuilder: (context, index) => Container(
                  child:Table(
                    border: TableBorder.symmetric(
                        outside: BorderSide(width: 0.5,color: Colors.grey[300])),
                    defaultColumnWidth: FixedColumnWidth(150),
                    columnWidths: {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(4),
                      2: FlexColumnWidth(6),
                      3: FlexColumnWidth(4),
                    },
                    children: [
                      TableRow(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('11/12/20',style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('12:20 pm',style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Fish Curry',style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(globals.currencySymbl +'250',style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15
                              ),),
                            )
                          ]
                      )
                    ],
                  )

              ),
            ))
    );

  }

  Widget buildAnimatedSwitcher(BuildContext context){
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      child: wallet.order == 0 ? buildPiggyBankImage(context) : buildWalletHistory(context),

    );
  }

}
