import 'dart:io';
import 'dart:math';
import 'package:dabbawala/UI/home_page.dart';
import 'package:dabbawala/UI/map_page.dart';
import 'package:dabbawala/UI/successful_purchase.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'data/cart_data.dart' as cart;
import 'dart:convert';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;

var tempAmt;
var tempAmt2;

ProgressDialog prRemove;

var cartAdOnIdsList;
List<String> cartItemIds;
List<String> cartItemVendorIds;
var cartAdOnNamesList;
var cartAdOnPricesList;
var cartDeliveryPartnerfeeList;
var cartTaxesPerItemList;

int counter = 0;
var totalPrice;
var totalItems;
var partnerFee = 10;
var taxCharges = 18;
var partnerFeeTemp = 0;
var taxChargesTemp = 0;
var partnerFeeTempTemp = 0;
var taxChargesTempTemp = 0;
List<String> cartItemCartIds;
List<String> cartItemNames;
List<String> cartItemPrices;
List<String> cartItemDescription;

var finalAmount;
var finalAmountWithAdOns;
var finalAmount2;
var selectedCartIdToDeleted;

List<String> addressIdsList;
List<String> addressNamesList;

var selectedAddressIdForOrder;

var finalTax;
var finalDeliveryCharge;

var saveOrderItemId;
var saveOrderVendorId;
var saveOrderAddressId;
var saveOrderPaymentMode;
var saveOrderPaymentStatus;
var saveOrderAmount;

class CartPageWithoutBottomNav extends StatefulWidget {
  @override
  _CartPageWithoutBottomNavState createState() => _CartPageWithoutBottomNavState();
}

class _CartPageWithoutBottomNavState extends State<CartPageWithoutBottomNav> {

  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;

  Future<String> getCartItems(context) async {

    print(storedUserId.toString());
    print(tempCartId.toString());

    String url = globals.apiUrl + "getcart.php";

    http.post(url, body: {

      "userID" : storedUserId.toString(),
      "cartID" : "",

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayGetCart = jsonDecode(response.body);
      print(responseArrayGetCart);

      var responseArrayGetCartMsg = responseArrayGetCart['message'].toString();
      print(responseArrayGetCartMsg);

      if(statusCode == 200){
        if(responseArrayGetCartMsg == "Item Found"){

          setState(() {
            cartItemCartIds = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemcartID'].toString());
            cartItemIds = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemcartItemID'].toString());
            cartItemVendorIds = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemVendorid'].toString());
            cartItemNames = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemName'].toString());
            cartItemPrices = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemPrice'].toString());
            cartItemDescription = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemDescription'].toString());
            cartDeliveryPartnerfeeList = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['vendorDeliverypartner'].toString());
            cartTaxesPerItemList = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['vendorTax'].toString());

            totalItems = cartItemPrices.length.toString();
            finalAmount = responseArrayGetCart['totalamt'].toString();
            tempAmt = responseArrayGetCart['totalamt'].toString();
            tempAmt2 = (int.parse(tempAmt.toString())+18+10).toString();

            finalDeliveryCharge = (cartDeliveryPartnerfeeList[0]*cartDeliveryPartnerfeeList.length);
            print("deliverycharge:::"+finalDeliveryCharge.toString());

          });
          print(cartItemCartIds.toList());
          print(cartItemIds.toList());
          print(cartItemVendorIds.toList());
          print(cartItemNames.toList());
          print(cartItemPrices.toList());
          print(cartItemDescription.toList());
          print(cartDeliveryPartnerfeeList.toList());
          print(cartTaxesPerItemList.toList());
          print(totalPrice);
          print(finalAmount);

          print("tempAmt"+tempAmt.toString());
          print("tempAmt2"+tempAmt2.toString());

        }else{

          Fluttertoast.showToast(msg: 'No items found', backgroundColor: Colors.black, textColor: Colors.white);
          setState(() {
            cartItemCartIds = null;
          });

        }
      }
    });
  }
  Future<String> getCartAdons(context) async {

    print(storedUserId.toString());
    print(tempCartId.toString());

    String url = globals.apiUrl + "getadsoncartbyuserid.php";

    http.post(url, body: {

      "userID" : storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetCartA = jsonDecode(response.body);
      print(responseArrayGetCartA);

      var responseArrayGetCartAMsg = responseArrayGetCartA['message'].toString();
      print(responseArrayGetCartAMsg);

      if(statusCode == 200){
        if(responseArrayGetCartAMsg == "Item Found"){

          setState(() {
            cartAdOnIdsList = List.generate(responseArrayGetCartA['data'].length, (index) => responseArrayGetCartA['data'][index]['adsoncartID'].toString());
            cartAdOnNamesList = List.generate(responseArrayGetCartA['data'].length, (index) => responseArrayGetCartA['data'][index]['itemadsonName'].toString());
            cartAdOnPricesList = List.generate(responseArrayGetCartA['data'].length, (index) => responseArrayGetCartA['data'][index]['itemadsonPrice'].toString());
            int sum = cartAdOnPricesList.fold(0, (previous, current) => int.parse(previous.toString()) + int.parse(current.toString()));
            print("adons total :" + sum.toString());
            finalAmountWithAdOns = int.parse(finalAmount.toString())+int.parse(sum.toString());
            finalAmount2 = (int.parse(finalAmountWithAdOns.toString())+18+10).toString();
          });

          print(cartAdOnIdsList.toList());
          print(cartAdOnNamesList.toList());
          print(cartAdOnPricesList.toList());
          print("final amount : "+finalAmountWithAdOns.toString());
          print(finalAmount2);

        }else{

          setState(() {
            cartAdOnIdsList = [];
            cartAdOnNamesList = [];
            cartAdOnPricesList = [];
          });

        }
      }
    });
  }

  Future<String> removeFromCart(context) async {

    String url = globals.apiUrl + "removeitem.php";

    http.post(url, body: {

      "id" : selectedCartIdToDeleted.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayRemoveFromCart = jsonDecode(response.body);
      print(responseArrayRemoveFromCart);

      var responseArrayRemoveFromCartMsg = responseArrayRemoveFromCart['message'].toString();
      print(responseArrayRemoveFromCartMsg);

      if(statusCode == 200){
        if(responseArrayRemoveFromCartMsg == "Successfully"){

          prRemove.hide();
          Fluttertoast.showToast(msg: 'Removing...', backgroundColor: Colors.black, textColor: Colors.white);
          getCartItems(context);
          getCartAdons(context);

        }else{
          prRemove.hide();
          Fluttertoast.showToast(msg: 'Some error occured', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  Future<String> getAddressList(context) async {

    String url = globals.apiUrl + "getcustomeraddress.php";

    http.post(url, body: {

      "customerID" : storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetAddresses = jsonDecode(response.body);
      print(responseArrayGetAddresses);

      var responseArrayGetAddressesMsg = responseArrayGetAddresses['message'].toString();
      print(responseArrayGetAddressesMsg);

      if(statusCode == 200){
        if(responseArrayGetAddressesMsg == "Item Found"){

          setState(() {
            addressIdsList = List.generate(responseArrayGetAddresses['data'].length, (index) => responseArrayGetAddresses['data'][index]['customeraddressID'].toString());
            addressNamesList = List.generate(responseArrayGetAddresses['data'].length, (index) => responseArrayGetAddresses['data'][index]['customeraddressAddress'].toString());
          });
          print(addressIdsList.toList());
          print(addressNamesList.toList());

        }else{

          setState(() {
            addressIdsList = null;
          });

        }
      }
    });
  }

  Future<String> deleteCart(context) async {

    String url = globals.apiUrl + "deletecartbyuser.php";

    http.post(url, body: {

      "userid" : storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayDeleteCart = jsonDecode(response.body);
      print(responseArrayDeleteCart);

      var responseArrayDeleteCartMsg = responseArrayDeleteCart['message'].toString();
      print(responseArrayDeleteCartMsg);

      if(statusCode == 200){
        if(responseArrayDeleteCartMsg == "Successfully"){

          print("deleted cart successfully...");
          getCartItems(context);

        }else{

          print("cart was empty...");

        }
      }

    }

    );

  }

  Future<String> saveOrder(context) async {

    String url = globals.apiUrl + "saveorders.php";

    http.post(url, body: {

      "ordernumber" : "DB-PUN105",
      "itemID" : saveOrderItemId.toString(),//
      "custID" : storedUserId.toString(),
      "vendorID" : saveOrderVendorId.toString(),//
      "addressID" : selectedAddressIdForOrder.toString(),
      "paymentmode" : saveOrderPaymentMode.toString(),
      "paymentstatus" : saveOrderPaymentStatus.toString(),
      "amnt" : saveOrderAmount.toString(),
      "qnty" : "1",
      "adson" : "",
      "prices" : "",

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayDeleteCart = jsonDecode(response.body);
      print(responseArrayDeleteCart);

      var responseArrayDeleteCartMsg = responseArrayDeleteCart['message'].toString();
      print(responseArrayDeleteCartMsg);

      if(statusCode == 200){
        if(responseArrayDeleteCartMsg == "Successfully"){

          print("deleted cart successfully...");
          getCartItems(context);

        }else{

          print("cart was empty...");

        }
      }

    }

    );

  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_YJz3qhQIm0gqoo',
      'amount': int.parse(finalAmount2)*100,
      'name': 'Dabbawala',
      'description': 'Order number Db17846',
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
    //saveOrder(context);
    cartItemIds.forEach((element) {
      int idx = cartItemIds.indexOf(element);
      setState(() {
        saveOrderItemId = cartItemIds[idx].toString();
        saveOrderVendorId = cartItemVendorIds[idx];
        saveOrderAmount = cartItemPrices[idx];
      });
      print("saveOrderItemId :" + saveOrderItemId.toString());
      print("saveOrderVendorId :" + saveOrderVendorId.toString());
      print("saveOrderAmount :" + saveOrderAmount.toString());
      saveOrder(context);
    });
    Fluttertoast.showToast(
      msg: "SUCCESS: " + response.paymentId,).whenComplete((){
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) =>SuccessfulPurchase(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          )
      ).whenComplete((){
        deleteCart(context);
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    setState(() {
      tempAmt2 = null;
      tempAmt = null;
      finalAmount = null;
      finalAmount2 = null;
      finalAmountWithAdOns = null;
      cart.addressOption = 'first';
      counter = 1;
      selectedAddressIdForOrder = null;
    });
    getCartItems(context);
    getCartAdons(context);
    getAddressList(context);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    prRemove = ProgressDialog(context);
    getCartItems(context);
    getCartAdons(context);
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: cartItemCartIds == null ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/cart_empty.png'),
            SizedBox(height: 20,),
            Text('Your Cart is Empty!',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text('Do something to make me happy',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              color: Colors.black,
              fontSize: 16,
              letterSpacing: 0.5,
            ),),
          ],
        ) : SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Items you have added',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                    Divider(),
                  ],
                ),
              ),
              buildCartItems(context),
              cartAdOnNamesList == null ? Container() : Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Adons you have added',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                    Divider(),
                  ],
                ),
              ),
              buildAdOnsListViewBuilder(context),
              SizedBox(height: 10,),
              buildDivider(context),
              SizedBox(height: 20,),
              buildAddCouponField(context),
              SizedBox(height: 20,),
              buildItemListPrice(context),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: buildLocationsListViewBuilder(context),
              ),
              SizedBox(height: 20,),
              buildCheckOutAndCancelButton(context),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCartItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
      child: Column(children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            itemCount: cartItemNames == null ? 0 : cartItemNames.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            selectedCartIdToDeleted = cartItemCartIds[index].toString();
                                          });
                                          print(selectedCartIdToDeleted);
                                          prRemove.show();
                                          removeFromCart(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 0, top: 5),
                                          child: Icon(Icons.remove_circle, color: Colors.red[900], size: 20,),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 0, top: 5),
                                        child: Text(
                                          cartItemNames[index],textScaleFactor: 1,
                                          style: GoogleFonts.nunitoSans(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30, top: 5),
                                  child: Container(
                                    width: 300,
                                    child: Text(
                                      cartItemDescription[index],textScaleFactor: 1,
                                      maxLines: 2,
                                      style: GoogleFonts.nunitoSans(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              globals.currencySymbl+cartItemPrices[index],textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                  Divider(),
                ],
              ),
            ))
      ]),
    );
  }

  Widget buildAdOnsListViewBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
      child: Column(children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            itemCount: cartAdOnNamesList == null ? 0 : cartAdOnNamesList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //width: MediaQuery.of(context).size.width/1.5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Text(
                                cartAdOnNamesList[index],textScaleFactor: 1,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              globals.currencySymbl+cartAdOnPricesList[index],textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                  Divider(),
                ],
              ),
            ))
      ]),
    );
  }

  Widget buildDivider(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Divider(
        color: Colors.black,
        thickness: 0.2,
        height: 1,
      ),
    );
  }

  Widget buildAddCouponField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Container(
        width: MediaQuery.of(context).size.width/1,
        height: MediaQuery.of(context).size.height/15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 1
          )],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //SizedBox(width: 10,),
            Image.asset('assets/images/coupons.png',scale: 20,color: Colors.deepPurple[800],),
            //SizedBox(width: 10,),
            Text('Apply Coupon :',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              color: Colors.deepPurple[800],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                width: MediaQuery.of(context).size.width/2.5,
                height: MediaQuery.of(context).size.height/25,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white
                ),
                child: Padding(
                    padding: const EdgeInsets.only(left: 5,),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Colors.white
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.white),
                          gapPadding: 10,

                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.white),
                            gapPadding: 10
                        ),
                      ),
                    )
                ),
              ),
            ),
            Icon(Icons.play_arrow,color: Colors.deepPurple[800],size: 30,),
          ],
        ),
      ),
    );
  }

  Widget buildItemListPrice(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total item bill:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),),
              InkWell(
                onTap: (){print(finalAmount.toString());},
                child: finalAmountWithAdOns == null || finalAmountWithAdOns == "null" ? Text(globals.currencySymbl + tempAmt.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),) : Text(globals.currencySymbl + finalAmountWithAdOns.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),),
              )
            ],
          ),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Partner Fee:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),),
              Text(globals.currencySymbl+partnerFee.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),)
            ],
          ),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax and charges:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),),
              Text(globals.currencySymbl+taxCharges.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),)
            ],
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total bill:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),),
              finalAmount2 == null || finalAmount2 == "null" ? Text(globals.currencySymbl+tempAmt2.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),) : Text(globals.currencySymbl+finalAmount2.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),)
            ],
          ),
          // SizedBox(height: 12,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Total bill with subscription:',style: GoogleFonts.nunitoSans(
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold,
          //       color: Colors.blue[800]
          //     ),),
          //     Text('Rs 560',style: GoogleFonts.nunitoSans(
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.blue[800]
          //     ),)
          //   ],
          // )
        ],
      ),
    );

  }

  Widget buildCheckOutAndCancelButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: GestureDetector(
        onTap: (){
          if(selectedAddressIdForOrder == null){
            Fluttertoast.showToast(msg: 'Please select a delivery address', backgroundColor: Colors.black, textColor: Colors.white);
            if(addressNamesList == null){
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => MapPage(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  )
              ).whenComplete((){
                getAddressList(context);
              });
            }
          }else{
            slideSheet();
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.4),blurRadius: 3,
              )],
              color: Colors.blue[800]
          ),
          child: Center(
            child: Text('Proceed to Pay',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),),
          ),
        ),
      ),
    );
  }

  Widget buildAddressDetails(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width/1.1,
        height: MediaQuery.of(context).size.height /23,
        padding: EdgeInsets.only(left: 0, right: 0),
        child: TextFormField(
          enabled: false,
          style: TextStyle(color: Colors.black,),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(

              hintText: 'Road Name/Locality Name',
              hintStyle: TextStyle(color: Colors.black,fontSize: 15,),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding:
              EdgeInsets.only(left: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 10,
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.black),
                  gapPadding: 10),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.black),
                  gapPadding: 10)),
          validator: (value) {
            if (value.isEmpty) {
              return 'First name is cumpulsary';
            }
            return null;
          },
        ));

  }

  Widget buildAddressText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left:18),
      child: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Address',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue[900]
            ),),
          )
      ),
    );
  }

  Widget buildAddressOptions(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
              onTap: (){
                setState(() {
                  cart.addressOption = 'first';
                });
              },
              child: cart.addressOption == 'first' ? Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.2),blurRadius: 3,
                  )],
                  color: Colors.blue[800],
                ),
                child: Center(
                  child: Text('Address A',style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ) : Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.2),blurRadius: 3,
                  )],
                  color: Colors.white,
                ),
                child: Center(
                  child: Text('Address A',style: GoogleFonts.nunitoSans(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              )
          ),
          GestureDetector(
              onTap: (){
                setState(() {
                  cart.addressOption = 'second';
                });
              },
              child: cart.addressOption == 'second' ? Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.2),blurRadius: 3,
                  )],
                  color: Colors.blue[800],
                ),
                child: Center(
                  child: Text('Address B',style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ) : Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.2),blurRadius: 3,
                  )],
                  color: Colors.white,
                ),
                child: Center(
                  child: Text('Address B',style: GoogleFonts.nunitoSans(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),),
                ),
              )
          ),
          GestureDetector(
              onTap: (){
                setState(() {
                  // ignore: unnecessary_statements
                  cart.addressOption = 'third';
                });
              },
              child: cart.addressOption == 'third' ?  Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.4),blurRadius: 3,
                    )],
                    color: Colors.blue[800]
                ),
                child: Center(
                  child: Text('Address C',style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                ),
              ) : Container(
                width: MediaQuery.of(context).size.width/4,
                height: MediaQuery.of(context).size.height/20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.4),blurRadius: 3,
                    )],
                    color: Colors.white
                ),
                child: Center(
                  child: Text('Address C',style: GoogleFonts.nunitoSans(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                ),
              )
          )
        ],
      ),
    );
  }

  Widget buildLocationsListViewBuilder(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your saved locations",textScaleFactor: 1,
          style: GoogleFonts.nunitoSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),SizedBox(height: 20,),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0.0),
          scrollDirection: Axis.vertical,
          itemCount: addressNamesList == null ? 0 : addressNamesList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedAddressIdForOrder = addressIdsList[index];
                        });
                        print(selectedAddressIdForOrder);
                      },
                      child: Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: selectedAddressIdForOrder == addressIdsList[index] ? Center(
                          child: Icon(Icons.check, size: 10,),
                        ) : Container(),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        child: Text(addressNamesList[index],textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => MapPage(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 300),
                        )
                    ).whenComplete((){
                      getAddressList(context);
                    });
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text("Remove this address",textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 25,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text("Update this address",textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  void slideSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    color: Color(0xFF737373),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: Colors.white,
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              saveOrderPaymentMode = "RazorPay";
                              print(saveOrderPaymentMode);
                              openCheckout();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2,
                              height: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 40,
                                      width: 100,
                                      child: Image.asset("assets/images/razorpay.png",
                                        fit: BoxFit.fitWidth,
                                      )),
                                  Text('Razor Pay',style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              saveOrderPaymentMode = "0";
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/2,
                              height: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    child: Text('COD',style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),),
                                  ),
                                  Text('Cash on Delivery',style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ) ;

              });
        });
  }

}


//                      Container(
//                        width: 180,
//                        height: 120,
//                        decoration: BoxDecoration(
//                          borderRadius:
//                          BorderRadius.all(Radius.circular(15)),
//                        ),
//                        child: Image.network(index == 0 ? "https://images.pexels.com/photos/461198/pexels-photo-461198.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500" : index == 1 ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOtRfuB96de9SrW04x1GnhYiBwSEOIwq-UBg&usqp=CAU" : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuepUwe-088oSaHE1v4Md8ExADM0syPoDAwA&usqp=CAU",
//                          fit: BoxFit.fill,
//                        ),
//                      ),
