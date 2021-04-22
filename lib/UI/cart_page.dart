import 'dart:math';
import 'dart:math' as Math;
import 'package:dabbawala/UI/home_page.dart';
import 'package:dabbawala/UI/home_page.dart' as bm;
import 'package:dabbawala/UI/map_page.dart';
import 'package:dabbawala/UI/successful_purchase.dart';
import 'package:dabbawala/UI/view_offers_and_promos.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'data/cart_data.dart' as cart;
import 'dart:convert';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/Widgets/bottom_nav_bar.dart' as bm;

import 'data/globals_data.dart';

bool showLoadinggggCart = false;

List<String> vendorLat;
List<String> vendorLong;

var deliveryFees;
var taxFees;
var packingCharge;

TextEditingController additionalRequirements = TextEditingController();
TextEditingController phoneController = TextEditingController();
var selectedDiscountAmount;
var selectedDiscountId;
var selectedDiscountPromoCode;

var tempAmt;
var tempAmt2;
ProgressDialog prRemove;

var cartAdOnIdsListForOrdering;
var cartAdOnIdsList;var cartAdOnItemIdsList;
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

var cartItemCartIds;
List<String> cartItemIds;
List<String> cartItemVendorIds;
List<String> cartItemNames;
List<String> cartItemPrices;
List<String> cartItemDescription;

var random;
var finalAmount;
var finalAmountWithAdOns;
var finalAmount2;
var selectedCartIdToDeleted;

List<String> addressIdsList;
List<String> addressNamesList;
List<String> addressLatList;
List<String> addressLongList;
var distance;
var distanceV;
var distanceV2;
var distanceV3;
var distanceV4;
var distanceV5;
var distanceV6;
var distanceV7;
var distanceV8;

var selectedAddressIdForOrder;

var finalTax;
var finalDeliveryCharge;

var saveOrderItemId;
var saveOrderVendorId;
var saveOrderAddressId;
var saveOrderPaymentMode;
var saveOrderPaymentStatus;
var saveOrderAmount;

var walletBalance;
bool useWalletBalance = false;

bool savedDiscountLog = false;

class CartPage extends StatefulWidget {
  final ValueChanged<int> updateCartMinus;
  final ValueChanged<int> updateToZeroo;
  final ValueChanged<int> getCarttt;

  CartPage({this.updateCartMinus, this.updateToZeroo, this.getCarttt});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;

  Future<String> getWallet(context) async {
    String url = globals.apiUrl + "getcustomerwallet.php";

    http.post(url, body: {
      "userID": storedUserId.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayGetWallet = jsonDecode(response.body);
      print(responseArrayGetWallet);

      var responseArrayGetWalletMsg =
          responseArrayGetWallet['message'].toString();
      print(responseArrayGetWalletMsg);

      if (statusCode == 200) {
        if (responseArrayGetWalletMsg == "Item Found") {
          setState(() {
            walletBalance = responseArrayGetWallet['data']
                    ['customerwalletBalance']
                .toString();
          });
          print(walletBalance);
          if (int.parse(walletBalance.toString()) > 0) {
            setState(() {
              useWalletBalance = true;
            });
          } else {
            setState(() {
              useWalletBalance = false;
            });
          }

          getCartItems(context);
        } else {
          Fluttertoast.showToast(
              msg: 'You have 0 balance currently',
              backgroundColor: Colors.black,
              textColor: Colors.white);

          setState(() {
            walletBalance = "0";
          });
          getCartItems(context);
        }
      }
    });
  }

  Future<String> getCartItems(context) async {
    print(storedUserId.toString());
    print(tempCartId.toString());

    String url = globals.apiUrl + "getcart.php";

    http.post(url, body: {
      "userID": storedUserId.toString(),
      "cartID": "",
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayGetCart = jsonDecode(response.body);
      print(responseArrayGetCart);

      var responseArrayGetCartMsg = responseArrayGetCart['message'].toString();
      print(responseArrayGetCartMsg);

      if (statusCode == 200) {
        if (responseArrayGetCartMsg == "Item Found") {
          setState(() {
            cartItemCartIds = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['itemcartID']
                    .toString());
            cartItemIds = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['itemcartItemID']
                    .toString());
            cartItemVendorIds = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['itemVendorid']
                    .toString());
            cartItemNames = List.generate(
                responseArrayGetCart['data'].length,
                (index) =>
                    responseArrayGetCart['data'][index]['itemName'].toString());
            cartItemPrices = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['itemPrice']
                    .toString());
            cartItemDescription = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]
                        ['itemDescription']
                    .toString());
            cartDeliveryPartnerfeeList = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]
                        ['vendorDeliverypartner']
                    .toString());
            cartTaxesPerItemList = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['vendorTax']
                    .toString());
            vendorLat = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['vendorLatitude']
                    .toString());
            vendorLong = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]
                        ['vendorLongitude']
                    .toString());

            deliveryFees = responseArrayGetCart['deliveryfees'].toString();
            taxFees = responseArrayGetCart['taxfees'].toString();
            packingCharge = responseArrayGetCart['packingfees'].toString();

            totalItems = cartItemPrices.length.toString();
            finalAmount = responseArrayGetCart['totalamt'].toString();
            tempAmt = responseArrayGetCart['totalamt'].toString();
//            if(walletBalance == "0"){
//
//            }else{
            tempAmt2 = (int.parse(tempAmt.toString()) +
                    int.parse(deliveryFees.toString()) +
                    int.parse(taxFees.toString()) +
                    int.parse(packingCharge.toString()) -
                    int.parse(walletBalance.toString()))
                .toString();
            //}

            finalDeliveryCharge = (cartDeliveryPartnerfeeList[0] *
                cartDeliveryPartnerfeeList.length);
            print("deliverycharge:::" + finalDeliveryCharge.toString());
          });
          print(cartItemCartIds.toList());
          print(cartItemIds.toList());
          print(cartItemVendorIds.toList());
          print(cartItemNames.toList());
          print(cartItemPrices.toList());
          print(cartItemDescription.toList());
          print(cartDeliveryPartnerfeeList.toList());
          print(cartTaxesPerItemList.toList());
          print(vendorLat.toList());
          print(vendorLong.toList());
          print(totalPrice);
          print(finalAmount);

          print("tempAmt" + tempAmt.toString());
          print("tempAmt2" + tempAmt2.toString());

          print("DELIVERY FEES ::::::" + deliveryFees.toString());
          print("TAX FEES ::::::" + taxFees.toString());
          print("PACKING FEES ::::::" + packingCharge.toString());

          getCartAdons(context);
        } else {
          //Fluttertoast.showToast(msg: 'No items found', backgroundColor: Colors.black, textColor: Colors.white);
          setState(() {
            cartItemCartIds = null;
            totalItems = 0;
          });
          widget.updateToZeroo(0);
        }
      }
    });
  }

  Future<String> getCartItems2(context) async {
    print(storedUserId.toString());
    print(tempCartId.toString());

    String url = globals.apiUrl + "getcart.php";

    http.post(url, body: {
      "userID": storedUserId.toString(),
      "cartID": "",
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayGetCart = jsonDecode(response.body);
      print(responseArrayGetCart);

      var responseArrayGetCartMsg = responseArrayGetCart['message'].toString();
      print(responseArrayGetCartMsg);

      if (statusCode == 200) {
        if (responseArrayGetCartMsg == "Item Found") {
          setState(() {
            cartItemCartIds = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['itemcartID']
                    .toString());
            cartItemIds = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['itemcartItemID']
                    .toString());
            cartItemVendorIds = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['itemVendorid']
                    .toString());
            cartItemNames = List.generate(
                responseArrayGetCart['data'].length,
                (index) =>
                    responseArrayGetCart['data'][index]['itemName'].toString());
            cartItemPrices = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['itemPrice']
                    .toString());
            cartItemDescription = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]
                        ['itemDescription']
                    .toString());
            cartDeliveryPartnerfeeList = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]
                        ['vendorDeliverypartner']
                    .toString());
            cartTaxesPerItemList = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['vendorTax']
                    .toString());

            deliveryFees = responseArrayGetCart['deliveryfees'].toString();
            taxFees = responseArrayGetCart['taxfees'].toString();
            packingCharge = responseArrayGetCart['packingfees'].toString();

            totalItems = cartItemPrices.length.toString();
            finalAmount = responseArrayGetCart['totalamt'].toString();
            tempAmt = responseArrayGetCart['totalamt'].toString();
//            if(walletBalance == "0"){
//
//            }else{
            tempAmt2 = (int.parse(tempAmt.toString()) +
                    int.parse(deliveryFees.toString()) +
                    int.parse(taxFees.toString()) +
                    int.parse(packingCharge.toString()) -
                    int.parse(walletBalance.toString()))
                .toString();
            //}

            finalDeliveryCharge = (cartDeliveryPartnerfeeList[0] *
                cartDeliveryPartnerfeeList.length);
            print("deliverycharge:::" + finalDeliveryCharge.toString());
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

          print("tempAmt" + tempAmt.toString());
          print("tempAmt2" + tempAmt2.toString());

          print("DELIVERY FEES ::::::" + deliveryFees.toString());
          print("TAX FEES ::::::" + taxFees.toString());
          print("PACKING FEES ::::::" + packingCharge.toString());

          setState(() {
            showLoadinggggCart = false;
          });

          getCartAdons(context);
        } else {
          //Fluttertoast.showToast(msg: 'No items found', backgroundColor: Colors.black, textColor: Colors.white);
          setState(() {
            showLoadinggggCart = false;
            cartItemCartIds = null;
            totalItems = 0;
          });
          widget.updateToZeroo(0);
        }
      }
    });
  }

  Future<String> getCartAdons(context) async {
    print(storedUserId.toString());
    print(tempCartId.toString());

    String url = globals.apiUrl + "getadsoncartbyuserid.php";

    http.post(url, body: {
      "userID": storedUserId.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayGetCartA = jsonDecode(response.body);
      print(responseArrayGetCartA);

      var responseArrayGetCartAMsg =
          responseArrayGetCartA['message'].toString();
      print(responseArrayGetCartAMsg);

      if (statusCode == 200) {
        if (responseArrayGetCartAMsg == "Item Found") {
          setState(() {
            cartAdOnIdsListForOrdering = List.generate(
                responseArrayGetCartA['data'].length,
                    (index) => responseArrayGetCartA['data'][index]['adsoncartAdsonid']
                    .toString());
            cartAdOnItemIdsList = List.generate(
                responseArrayGetCartA['data'].length,
                    (index) => responseArrayGetCartA['data'][index]['itemadsonItemid']
                    .toString());
            cartAdOnIdsList = List.generate(
                responseArrayGetCartA['data'].length,
                (index) => responseArrayGetCartA['data'][index]['adsoncartID']
                    .toString());
            cartAdOnNamesList = List.generate(
                responseArrayGetCartA['data'].length,
                (index) => responseArrayGetCartA['data'][index]['itemadsonName']
                    .toString());
            cartAdOnPricesList = List.generate(
                responseArrayGetCartA['data'].length,
                (index) => responseArrayGetCartA['data'][index]
                        ['itemadsonPrice']
                    .toString());
            int sum = cartAdOnPricesList.fold(
                0,
                (previous, current) =>
                    int.parse(previous.toString()) +
                    int.parse(current.toString()));
            print("adons total :" + sum.toString());
            finalAmountWithAdOns =
                int.parse(finalAmount.toString()) + int.parse(sum.toString());

//            if(walletBalance == "0"){
//
//            }else{
            finalAmount2 = (int.parse(finalAmountWithAdOns.toString()) +
                    int.parse(deliveryFees.toString()) +
                    int.parse(taxFees.toString()) +
                    int.parse(packingCharge.toString()) -
                    int.parse(walletBalance.toString()))
                .toString();
            //}
          });

          print("AdOn Ids in cart");
          print(cartAdOnIdsListForOrdering.toList());
          print("AdOn Item Ids in cart");
          print(cartAdOnItemIdsList.toList());
          print("AdOn Cart Ids in cart");
          print(cartAdOnIdsList.toList());
          print("AdOn Names in cart");
          print(cartAdOnNamesList.toList());
          print("AdOn Prices in cart");
          print(cartAdOnPricesList.toList());
          print("final amount : " + finalAmountWithAdOns.toString());
          print(finalAmount2);
        } else {
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
      "id": selectedCartIdToDeleted.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayRemoveFromCart = jsonDecode(response.body);
      print(responseArrayRemoveFromCart);

      var responseArrayRemoveFromCartMsg =
          responseArrayRemoveFromCart['message'].toString();
      print(responseArrayRemoveFromCartMsg);

      if (statusCode == 200) {
        if (responseArrayRemoveFromCartMsg == "Successfully") {
          prRemove.hide();
          Fluttertoast.showToast(
              msg: 'Removing...',
              backgroundColor: Colors.black,
              textColor: Colors.white);
          //widget.getCarttt(int.parse(totalItems.toString()));
          getCartItems(context);
          getCartAdons(context);
        } else {
          prRemove.hide();
          Fluttertoast.showToast(
              msg: 'Some error occured',
              backgroundColor: Colors.black,
              textColor: Colors.white);
        }
      }
    });
  }

  Future<String> getAddressList(context) async {
    String url = globals.apiUrl + "getcustomeraddress.php";

    http.post(url, body: {
      "customerID": storedUserId.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayGetAddresses = jsonDecode(response.body);
      print(responseArrayGetAddresses);

      var responseArrayGetAddressesMsg =
          responseArrayGetAddresses['message'].toString();
      print(responseArrayGetAddressesMsg);

      if (statusCode == 200) {
        if (responseArrayGetAddressesMsg == "Item Found") {
          setState(() {
            addressIdsList = List.generate(
                responseArrayGetAddresses['data'].length,
                (index) => responseArrayGetAddresses['data'][index]
                        ['customeraddressID']
                    .toString());
            addressNamesList = List.generate(
                responseArrayGetAddresses['data'].length,
                (index) => responseArrayGetAddresses['data'][index]
                        ['customeraddressAddress']
                    .toString());
            addressLatList = List.generate(
                responseArrayGetAddresses['data'].length,
                (index) => responseArrayGetAddresses['data'][index]
                        ['customeraddressLatitude']
                    .toString());
            addressLongList = List.generate(
                responseArrayGetAddresses['data'].length,
                (index) => responseArrayGetAddresses['data'][index]
                        ['customeraddressLongitude']
                    .toString());
          });
          print(addressIdsList.toList());
          print(addressNamesList.toList());
          print(addressLatList.toList());
          print(addressLongList.toList());
        } else {
          setState(() {
            addressIdsList=null;
          });
        }
      }
    });
  }

  Future<String> deleteCart(context) async {
    setState(() {
      showLoadinggggCart = true;
    });

    String url = globals.apiUrl + "deletecartbyuser.php";

    http.post(url, body: {
      "userid": storedUserId.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayDeleteCart = jsonDecode(response.body);
      print(responseArrayDeleteCart);

      var responseArrayDeleteCartMsg =
          responseArrayDeleteCart['message'].toString();
      print(responseArrayDeleteCartMsg);

      if (statusCode == 200) {
        if (responseArrayDeleteCartMsg == "Successfully") {
          if(savedDiscountLog == true){

          }else{
            saveUserDisCountLogs(context);
          }
          print("deleted cart successfully...");
          widget.updateToZeroo(int.parse(totalItems.toString()));
          getCartItems2(context);
        } else {
          print("cart was empty...");
        }
      }
    });
  }

  Future<String> saveUserDisCountLogs(context) async {

    String url = globals.apiUrl + "saveuserdiscountlog.php";

    http.post(url, body: {

      "userID" : storedUserId.toString(),
      "discountID" : selectedDiscountId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArraySaveMyLog = jsonDecode(response.body);
      print(responseArraySaveMyLog);

      var responseArraySaveMyLogMsg = responseArraySaveMyLog['message'].toString();
      print(responseArraySaveMyLogMsg);

      if(statusCode == 200){
        if(responseArraySaveMyLogMsg == "Successfully"){

          setState(() {
            savedDiscountLog = true;
          });

        }else{



        }
      }

    }
    );
  }

  Future<String> saveOrder(context) async {
    print(additionalRequirements.text.toString());

    var list = new List<int>.generate(10, (int index) => index); // [0, 1, 4]
    list.shuffle();
    print(list);

    String url = globals.apiUrl + "saveorders.php";

    http.post(url, body: {
      "ordernumber": "ZFU-" + DateTime.now().microsecondsSinceEpoch.toString(),
      "itemID": saveOrderItemId.toString(), //
      "custID": storedUserId.toString(),
      "vendorID": saveOrderVendorId.toString(), //
      "addressID": selectedAddressIdForOrder.toString(),
      "paymentmode": saveOrderPaymentMode.toString(),
      "paymentstatus": saveOrderPaymentStatus.toString(),
      "amnt": saveOrderAmount.toString(),
      "mobileno": phoneController.text.toString(),
      "qnty": "1",
      "adson": "",
      "prices": "",
      "additionalinfo": cartAdOnItemIdsList.toList().contains(saveOrderItemId.toString()) ? additionalRequirements.text.toString()+""+ cartAdOnNamesList.toString() :  additionalRequirements.text.toString(),
      "walletbalance": walletBalance.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayDeleteCart = jsonDecode(response.body);
      print(responseArrayDeleteCart);

      var responseArrayDeleteCartMsg =
          responseArrayDeleteCart['message'].toString();
      print(responseArrayDeleteCartMsg);

      if (statusCode == 200) {
        if (responseArrayDeleteCartMsg == "Successfully") {
          print("deleted cart successfully...");
          additionalRequirements.clear();
          getCartItems(context);
        } else {
          print("cart was empty...");
        }
      }
    });
  }
  Future<String> saveOrder2(context) async {
    String url = globals.apiUrl + "saveorders.php";

    http.post(url, body: {
      "ordernumber": "ZFU-" + DateTime.now().microsecondsSinceEpoch.toString(),
      "itemID": saveOrderItemId.toString(), //
      "custID": storedUserId.toString(),
      "vendorID": saveOrderVendorId.toString(), //
      "addressID": selectedAddressIdForOrder.toString(),
      "paymentmode": saveOrderPaymentMode.toString(),
      "paymentstatus": saveOrderPaymentStatus.toString(),
      "amnt": saveOrderAmount.toString(),
      "mobileno": phoneController.text.toString(),
      "additionalinfo": cartAdOnItemIdsList.toList().contains(saveOrderItemId.toString()) ? additionalRequirements.text.toString()+""+ cartAdOnNamesList.toString() :  additionalRequirements.text.toString(),
      "qnty": "1",
      "adson": "",
      "prices": "",
      "walletbalance": walletBalance.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayDeleteCart = jsonDecode(response.body);
      print(responseArrayDeleteCart);

      var responseArrayDeleteCartMsg =
          responseArrayDeleteCart['message'].toString();
      print(responseArrayDeleteCartMsg);

      if (statusCode == 200) {
        if (responseArrayDeleteCartMsg == "Successfully") {
          print("deleted cart successfully...");
          additionalRequirements.clear();
          prRemove.hide().whenComplete(() {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => SuccessfulPurchase(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                )).whenComplete(() {
              deleteCart(context);
            });
          });
        } else {
          prRemove.hide();
          print("cart was empty...");
        }
      }
    });
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_x3INZuXXf81aZB',
      'amount': finalAmount2 == null || finalAmount2 == "null"
          ? (int.parse(tempAmt2.toString()) * 100).toString()
          : (int.parse(finalAmount2.toString()) * 100).toString(),
      'name': 'Zifffy',
      'description': 'Order Payment',
      'image': '',
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
      msg: "SUCCESS: " + response.paymentId,
    ).whenComplete(() {
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => SuccessfulPurchase(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          )).whenComplete(() {
        deleteCart(context);
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
//    Fluttertoast.showToast(
//      msg: "ERROR: " + response.code.toString() + " - " + response.message,
//    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,
    );
  }

  double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(double.parse(lat2.toString()) -
        double.parse(lat1.toString())); // deg2rad below
    var dLon =
        deg2rad(double.parse(lon2.toString()) - double.parse(lon1.toString()));
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    setState(() {
      distance = d.toString();
    });
    print(distance + "kms");
    return d;
  }

  double getDistanceFromLatLonInKmV(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(double.parse(lat2.toString()) -
        double.parse(lat1.toString())); // deg2rad below
    var dLon =
        deg2rad(double.parse(lon2.toString()) - double.parse(lon1.toString()));
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    setState(() {
      distanceV = d.toString();
    });
    print(distanceV + "kms");
    return d;
  }

  double getDistanceFromLatLonInKmV2(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(double.parse(lat2.toString()) -
        double.parse(lat1.toString())); // deg2rad below
    var dLon =
        deg2rad(double.parse(lon2.toString()) - double.parse(lon1.toString()));
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    setState(() {
      distanceV2 = d.toString();
    });
    print(distanceV2 + "kms");
    return d;
  }

  double getDistanceFromLatLonInKmV3(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(double.parse(lat2.toString()) -
        double.parse(lat1.toString())); // deg2rad below
    var dLon =
        deg2rad(double.parse(lon2.toString()) - double.parse(lon1.toString()));
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    setState(() {
      distanceV3 = d.toString();
    });
    print(distanceV3 + "kms");
    return d;
  }

  double getDistanceFromLatLonInKmV4(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(double.parse(lat2.toString()) -
        double.parse(lat1.toString())); // deg2rad below
    var dLon =
        deg2rad(double.parse(lon2.toString()) - double.parse(lon1.toString()));
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    setState(() {
      distanceV4 = d.toString();
    });
    print(distanceV4 + "kms");
    return d;
  }

  double getDistanceFromLatLonInKmV5(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(double.parse(lat2.toString()) -
        double.parse(lat1.toString())); // deg2rad below
    var dLon =
        deg2rad(double.parse(lon2.toString()) - double.parse(lon1.toString()));
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    setState(() {
      distanceV5 = d.toString();
    });
    print(distanceV + "kms");
    return d;
  }

  double getDistanceFromLatLonInKmV6(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(double.parse(lat2.toString()) -
        double.parse(lat1.toString())); // deg2rad below
    var dLon =
        deg2rad(double.parse(lon2.toString()) - double.parse(lon1.toString()));
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    setState(() {
      distanceV6 = d.toString();
    });
    print(distanceV6 + "kms");
    return d;
  }

  double getDistanceFromLatLonInKmV7(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(double.parse(lat2.toString()) -
        double.parse(lat1.toString())); // deg2rad below
    var dLon =
        deg2rad(double.parse(lon2.toString()) - double.parse(lon1.toString()));
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    setState(() {
      distanceV7 = d.toString();
    });
    print(distanceV7 + "kms");
    return d;
  }

  double getDistanceFromLatLonInKmV8(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(double.parse(lat2.toString()) -
        double.parse(lat1.toString())); // deg2rad below
    var dLon =
        deg2rad(double.parse(lon2.toString()) - double.parse(lon1.toString()));
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    setState(() {
      distanceV8 = d.toString();
    });
    print(distanceV8 + "kms");
    return d;
  }

  double deg2rad(deg) {
    return double.parse(deg.toString()) * (Math.pi / 180);
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
      savedDiscountLog = false;
      showLoadinggggCart = false;
      cartItemCartIds = "1";
      random = Random();
      deliveryFees = null;
      taxFees = null;
      useWalletBalance = false;
      selectedDiscountAmount = null;
      selectedDiscountPromoCode = null;
      walletBalance = null;
      tempAmt2 = null;
      tempAmt = null;
      finalAmount = null;
      finalAmount2 = null;
      finalAmountWithAdOns = null;
      cart.addressOption = 'first';
      counter = 1;
      selectedAddressIdForOrder = null;
    });
    //getWallet(context);
    getAddressList(context);
    getWallet(context);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    prRemove = ProgressDialog(context);
    //getCartItems(context);
    //getCartAdons(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: cartItemCartIds == "1" || showLoadinggggCart == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.white,
                      child: Text(
                        'Fetching cart',
                        textScaleFactor: 1,
                        style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Food is the best blessing you can have in this world!',
                        textAlign: TextAlign.center,
                        textScaleFactor: 1,
                        style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : cartItemCartIds == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            deleteCart(context);
                          },
                          child: Image.asset('assets/images/cart_empty.png')),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Your Cart is Empty!',
                        textScaleFactor: 1,
                        style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Do something to make me happy',
                        textScaleFactor: 1,
                        style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            print(DateTime.now()
                                .microsecondsSinceEpoch
                                .toString());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 10, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Items you have added',
                                  textScaleFactor: 1,
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                        buildCartItems(context),
                        cartAdOnNamesList == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, bottom: 10, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add-ons you have added',
                                      textScaleFactor: 1,
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                        buildAdOnsListViewBuilder(context),
                        SizedBox(
                          height: 10,
                        ),
                        buildDivider(context),
                        SizedBox(
                          height: 20,
                        ),
                        buildAddCouponField(context),
                        SizedBox(
                          height: 20,
                        ),
                        buildItemListPrice(context),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        buildPhoneNumberField(context),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: buildLocationsListViewBuilder(context),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildCheckOutAndCancelButton(context),
                        SizedBox(
                          height: 20,
                        )
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
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                widget.updateCartMinus(
                                                    int.parse(
                                                        totalItems.toString()));
                                                selectedCartIdToDeleted =
                                                    cartItemCartIds[index]
                                                        .toString();
                                              });
                                              print(selectedCartIdToDeleted);
                                              prRemove.show();
                                              removeFromCart(context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0, top: 5),
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red[900],
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(
                                                  (index + 1).toString() + ". ",
                                                  textScaleFactor: 1,
                                                  style: GoogleFonts.nunitoSans(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0, top: 5),
                                                child: Text(
                                                  cartItemNames[index],
                                                  textScaleFactor: 1,
                                                  style: GoogleFonts.nunitoSans(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, top: 5),
                                      child: Container(
                                        width: 300,
                                        child: Text(
                                          cartItemDescription[index],
                                          textScaleFactor: 1,
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
                                  currencySymbl + cartItemPrices[index],
                                  textScaleFactor: 1,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  (index + 1).toString() + ". ",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                //width: MediaQuery.of(context).size.width/1.5,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 0, top: 5),
                                  child: Text(
                                    cartAdOnNamesList[index],
                                    textScaleFactor: 1,
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  currencySymbl + cartAdOnPricesList[index],
                                  textScaleFactor: 1,
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

  Widget buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Divider(
        color: Colors.black,
        thickness: 0.2,
        height: 1,
      ),
    );
  }

  Widget buildAddCouponField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          TextFormField(
            maxLines: 2,
            controller: additionalRequirements,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Additional requirements/ Special instructions'),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => OffersAndPromoCodes(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  )).whenComplete(() {
                print(selectedDiscountAmount);
                if (selectedDiscountAmount == null ||
                    selectedDiscountAmount == "null") {
                } else {
                  if (finalAmount2 == null || finalAmount2 == "null") {
                    setState(() {
                      tempAmt2 = double.parse(tempAmt2.toString()) -
                          double.parse(selectedDiscountAmount.toString());
                    });
                    print(tempAmt2);
                  } else {
                    setState(() {
                      finalAmount2 = double.parse(finalAmount2.toString()) -
                          double.parse(selectedDiscountAmount.toString());
                    });
                    print(finalAmount2);
                  }
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 1)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/images/coupons.png',
                    scale: 20,
                    color: Colors.deepPurple[800],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'View available offers',
                    textScaleFactor: 1,
                    style: GoogleFonts.nunitoSans(
                      color: Colors.deepPurple[800],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.play_arrow,
                    color: Colors.deepPurple[800],
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemListPrice(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total item bill:',
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ), //baseColor: Colors.grey.shade200,
              //highlightColor: Colors.white,
              InkWell(
                onTap: () {
                  print(finalAmount.toString());
                },
                child: finalAmountWithAdOns == null ||
                        finalAmountWithAdOns == "null"
                    ? Text(
                        tempAmt == null || tempAmt == "null"
                            ? "loading"
                            : currencySymbl + tempAmt.toString(),
                        textScaleFactor: 1,
                        style: GoogleFonts.nunitoSans(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      )
                    : Text(
                        finalAmountWithAdOns == null ||
                                finalAmountWithAdOns == "null"
                            ? "loading"
                            : currencySymbl + finalAmountWithAdOns.toString(),
                        textScaleFactor: 1,
                        style: GoogleFonts.nunitoSans(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Partner Fee:',
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                deliveryFees == null || deliveryFees == "null"
                    ? "loading"
                    : globals.currencySymbl + deliveryFees.toString(),
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax and charges:',
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                taxFees == null || taxFees == "null"
                    ? "loading"
                    : globals.currencySymbl + taxFees.toString(),
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Packing charges:',
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                packingCharge == null || packingCharge == "null"
                    ? "loading"
                    : globals.currencySymbl + packingCharge.toString(),
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          walletBalance == "0"
              ? Container()
              : Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Use wallet balance',
                      textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      walletBalance == null || walletBalance == "null"
                          ? "loading"
                          : globals.currencySymbl + walletBalance.toString(),
                      textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Center(
                        child: useWalletBalance == true
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    useWalletBalance = false;
                                  });
                                  if (finalAmount2 == null ||
                                      finalAmount2 == "null") {
                                    setState(() {
                                      tempAmt2 = int.parse(
                                              tempAmt2.toString()) +
                                          int.parse(walletBalance.toString());
                                    });
                                    print(tempAmt2);
                                  } else {
                                    setState(() {
                                      finalAmount2 = int.parse(
                                              finalAmount2.toString()) +
                                          int.parse(walletBalance.toString());
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    useWalletBalance = true;
                                  });
                                  if (finalAmount2 == null ||
                                      finalAmount2 == "null") {
                                    setState(() {
                                      tempAmt2 = int.parse(
                                              tempAmt2.toString()) -
                                          int.parse(walletBalance.toString());
                                    });
                                    print(tempAmt2);
                                  } else {
                                    setState(() {
                                      finalAmount2 = int.parse(
                                              finalAmount2.toString()) -
                                          int.parse(walletBalance.toString());
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.check_box_outline_blank,
                                  color: Colors.grey,
                                )),
                      ),
                    ),
                  ],
                ),
          selectedDiscountAmount == null || selectedDiscountAmount == "null"
              ? Container()
              : Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        print("remove promo called");
                        Fluttertoast.showToast(
                            msg: 'Removing promo code...',
                            backgroundColor: Colors.black,
                            textColor: Colors.white);
                        if (finalAmount2 == null || finalAmount2 == "null") {
                          setState(() {
                            tempAmt2 = double.parse(tempAmt2.toString()) +
                                double.parse(selectedDiscountAmount.toString());
                          });
                          print(tempAmt2);
                        } else {
                          setState(() {
                            finalAmount2 = double.parse(finalAmount2.toString()) +
                                double.parse(selectedDiscountAmount.toString());
                          });
                          print(finalAmount2);
                        }
                        Future.delayed(Duration(seconds: 3), () async {
                          setState(() {
                            selectedDiscountAmount = null;
                          });
                          print(selectedDiscountAmount);
                        });
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 15,
                      ),
                    ),
                    Text(
                      'Promo code applied',
                      textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      selectedDiscountPromoCode +
                          "- Rs. " +
                          selectedDiscountAmount.toString(),
                      textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total bill:',
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              finalAmount2 == null || finalAmount2 == "null"
                  ? Text(
                      tempAmt2 == null || tempAmt2 == "null"
                          ? "loading"
                          : globals.currencySymbl + tempAmt2.toString(),
                      textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      finalAmount2 == null || finalAmount2 == "null"
                          ? "loading"
                          : globals.currencySymbl + finalAmount2.toString(),
                      textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
            ],
          ),
          SizedBox(
            height: 10,
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

  Widget buildPhoneNumberField(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: phoneController,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter Contact no.',
            hintStyle: GoogleFonts.nunitoSans(
              color: Colors.black,
              fontSize: 14,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(
              Icons.call,
              color: Colors.grey,
            ),
          ),
          validator: (value) {
            if (value.length == 0) {
              return 'Contact no. is compulsary!';
            }
            return null;
          },
        ));
  }

  Widget buildCheckOutAndCancelButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          if (selectedAddressIdForOrder == null ||
              phoneController.text.isEmpty) {
            Fluttertoast.showToast(
                msg:
                    'Please select/input a delivery address and contact number',
                backgroundColor: Colors.black,
                textColor: Colors.white);
            if (addressIdsList==null) {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => MapPage(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  )).whenComplete(() {
                getAddressList(context);
              });
            }
          } else {
            if(phoneController.text.length > 10 || phoneController.text.length < 10){
              Fluttertoast.showToast(
                  msg:
                  'Contact number must be 10 digits!',
                  backgroundColor: Colors.black,
                  textColor: Colors.white);
            }else{
              slideSheet();
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 3,
                )
              ],
              color: Colors.blue[800]),
          child: Center(
            child: Text(
              'Proceed to Pay',
              textScaleFactor: 1,
              style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAddressDetails(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 1.1,
        height: MediaQuery.of(context).size.height / 23,
        padding: EdgeInsets.only(left: 0, right: 0),
        child: TextFormField(
          enabled: false,
          style: TextStyle(
            color: Colors.black,
          ),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Road Name/Locality Name',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.only(left: 0),
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

  Widget buildAddressText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Address',
              textScaleFactor: 1,
              style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[900]),
            ),
          )),
    );
  }

  Widget buildAddressOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
              onTap: () {
                setState(() {
                  cart.addressOption = 'first';
                });
              },
              child: cart.addressOption == 'first'
                  ? Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                          )
                        ],
                        color: Colors.blue[800],
                      ),
                      child: Center(
                        child: Text(
                          'Address A',
                          style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                          )
                        ],
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'Address A',
                          style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
          GestureDetector(
              onTap: () {
                setState(() {
                  cart.addressOption = 'second';
                });
              },
              child: cart.addressOption == 'second'
                  ? Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                          )
                        ],
                        color: Colors.blue[800],
                      ),
                      child: Center(
                        child: Text(
                          'Address B',
                          style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                          )
                        ],
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'Address B',
                          style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
          GestureDetector(
              onTap: () {
                setState(() {
                  // ignore: unnecessary_statements
                  cart.addressOption = 'third';
                });
              },
              child: cart.addressOption == 'third'
                  ? Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 3,
                            )
                          ],
                          color: Colors.blue[800]),
                      child: Center(
                        child: Text(
                          'Address C',
                          style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 3,
                            )
                          ],
                          color: Colors.white),
                      child: Center(
                        child: Text(
                          'Address C',
                          style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ))
        ],
      ),
    );
  }

  Widget buildLocationsListViewBuilder(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your saved locations",
          textScaleFactor: 1,
          style: GoogleFonts.nunitoSans(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0.0),
          scrollDirection: Axis.vertical,
          itemCount: addressIdsList == null ? 0 : addressIdsList.length,
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
                      onTap: () {
                        setState(() {
                          tmpLat = addressLatList[index];
                          tmpLong = addressLongList[index];
                        });
                        print(selectedAddressIdForOrder);
                        print(tmpLat);
                        print(tmpLong);
                        print(bm.lat);
                        print(bm.long);
//                        vendorLat.forEach((element) {
//                          int idx = cartItemIds.indexOf(element);
//                          setState(() {
//                            saveOrderItemId = cartItemIds[idx].toString();
//                            saveOrderVendorId = cartItemVendorIds[idx];
//                            saveOrderAmount = cartItemPrices[idx];
//                          });
//                          print("saveOrderItemId :" + saveOrderItemId.toString());
//                          print("saveOrderVendorId :" + saveOrderVendorId.toString());
//                          print("saveOrderAmount :" + saveOrderAmount.toString());
//                          saveOrder(context);
//                        });
                        print(getDistanceFromLatLonInKm(
                            tmpLat, tmpLong, bm.lat, bm.long));

                        if (cartItemCartIds.length == 1) {
                          print(getDistanceFromLatLonInKmV(
                              vendorLat[0], vendorLong[0], tmpLat, tmpLong));
                          if (double.parse(distanceV) < 5) {
                            setState(() {
                              selectedAddressIdForOrder = addressIdsList[index];
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'The items in your cart are not servicable to your current location!',
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                          }
                        } else if (cartItemCartIds.length == 2) {
                          print(getDistanceFromLatLonInKmV(
                              vendorLat[0], vendorLong[0], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV2(
                              vendorLat[1], vendorLong[1], tmpLat, tmpLong));
                          if (double.parse(distanceV) < 5 &&
                              double.parse(distanceV2) < 5) {
                            setState(() {
                              selectedAddressIdForOrder = addressIdsList[index];
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'The items in your cart are not servicable to your current location!',
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                          }
                        } else if (cartItemCartIds.length == 3) {
                          print(getDistanceFromLatLonInKmV(
                              vendorLat[0], vendorLong[0], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV2(
                              vendorLat[1], vendorLong[1], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV3(
                              vendorLat[2], vendorLong[2], tmpLat, tmpLong));
                          if (double.parse(distanceV) < 5 &&
                              double.parse(distanceV2) < 5 &&
                              double.parse(distanceV3) < 5) {
                            setState(() {
                              selectedAddressIdForOrder = addressIdsList[index];
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'The items in your cart are not servicable to your current location!',
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                          }
                        } else if (cartItemCartIds.length == 4) {
                          print(getDistanceFromLatLonInKmV(
                              vendorLat[0], vendorLong[0], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV2(
                              vendorLat[1], vendorLong[1], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV3(
                              vendorLat[2], vendorLong[2], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV4(
                              vendorLat[3], vendorLong[3], tmpLat, tmpLong));
                          if (double.parse(distanceV) < 5 &&
                              double.parse(distanceV2) < 5 &&
                              double.parse(distanceV3) < 5 &&
                              double.parse(distanceV4) < 5) {
                            setState(() {
                              selectedAddressIdForOrder = addressIdsList[index];
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'The items in your cart are not servicable to your current location!',
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                          }
                        } else if (cartItemCartIds.length == 5) {
                          print(getDistanceFromLatLonInKmV(
                              vendorLat[0], vendorLong[0], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV2(
                              vendorLat[1], vendorLong[1], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV3(
                              vendorLat[2], vendorLong[2], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV4(
                              vendorLat[3], vendorLong[3], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV5(
                              vendorLat[4], vendorLong[4], tmpLat, tmpLong));
                          if (double.parse(distanceV) < 5 &&
                              double.parse(distanceV2) < 5 &&
                              double.parse(distanceV3) < 5 &&
                              double.parse(distanceV4) < 5 &&
                              double.parse(distanceV5) < 5) {
                            setState(() {
                              selectedAddressIdForOrder = addressIdsList[index];
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'The items in your cart are not servicable to your current location!',
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                          }
                        } else if (cartItemCartIds.length == 6) {
                          print(getDistanceFromLatLonInKmV(
                              vendorLat[0], vendorLong[0], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV2(
                              vendorLat[1], vendorLong[1], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV3(
                              vendorLat[2], vendorLong[2], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV4(
                              vendorLat[3], vendorLong[3], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV5(
                              vendorLat[4], vendorLong[4], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV6(
                              vendorLat[5], vendorLong[5], tmpLat, tmpLong));
                          if (double.parse(distanceV) < 5 &&
                              double.parse(distanceV2) < 5 &&
                              double.parse(distanceV3) < 5 &&
                              double.parse(distanceV4) < 5 &&
                              double.parse(distanceV5) < 5 &&
                              double.parse(distanceV6) < 5) {
                            setState(() {
                              selectedAddressIdForOrder = addressIdsList[index];
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'The items in your cart are not servicable to your current location!',
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                          }
                        } else if (cartItemCartIds.length == 7) {
                          print(getDistanceFromLatLonInKmV(
                              vendorLat[0], vendorLong[0], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV2(
                              vendorLat[1], vendorLong[1], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV3(
                              vendorLat[2], vendorLong[2], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV4(
                              vendorLat[3], vendorLong[3], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV5(
                              vendorLat[4], vendorLong[4], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV6(
                              vendorLat[5], vendorLong[5], tmpLat, tmpLong));
                          print(getDistanceFromLatLonInKmV7(
                              vendorLat[6], vendorLong[6], tmpLat, tmpLong));
                          if (double.parse(distanceV) < 5 &&
                              double.parse(distanceV2) < 5 &&
                              double.parse(distanceV3) < 5 &&
                              double.parse(distanceV4) < 5 &&
                              double.parse(distanceV5) < 5 &&
                              double.parse(distanceV6) < 5 &&
                              double.parse(distanceV7) < 5) {
                            setState(() {
                              selectedAddressIdForOrder = addressIdsList[index];
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'The items in your cart are not servicable to your current location!',
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'Please add only less than 8 items at a time!',
                              backgroundColor: Colors.black,
                              textColor: Colors.white);
                        }
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child:
                            selectedAddressIdForOrder == addressIdsList[index]
                                ? Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 10,
                                    ),
                                  )
                                : Container(),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        child: Text(
                          addressNamesList[index],
                          textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => MapPage(),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 300),
                        )).whenComplete(() {
                      getAddressList(context);
                    });
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Remove this address",
                          textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Update this address",
                          textScaleFactor: 1,
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
                              saveOrderPaymentStatus = "1";
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
                              Navigator.of(context).pop();
                              saveOrderPaymentMode = "COD";
                              saveOrderPaymentStatus = "0";
                              print(saveOrderPaymentMode);
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
                                saveOrder2(context).whenComplete((){
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
                              });
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
