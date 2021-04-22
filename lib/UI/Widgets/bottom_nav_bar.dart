//import 'dart:io';
//import 'package:carousel_slider/carousel_slider.dart';
//import 'package:dabbawala/UI/cart_page.dart';
//import 'package:dabbawala/UI/home_page.dart';
//import 'package:dabbawala/UI/my_account_page.dart';
//import 'package:dabbawala/UI/schedule_page.dart';
//import 'package:dabbawala/UI/wallet_page.dart';
//import 'package:dabbawala/main.dart';
//import 'package:flutter/material.dart';
//import 'package:dabbawala/UI/data/bottom_nav_data.dart' as bottomnav;
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:geocoder/geocoder.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:http/http.dart' as http;
//import 'package:dabbawala/UI/data/globals_data.dart' as globals;
//import 'package:dabbawala/UI/data/home_data.dart' as home;
//import 'dart:convert';
//import 'package:location/location.dart';
//import 'package:shimmer/shimmer.dart';
//import 'package:dabbawala/UI/cart_page.dart' as cart;
//
//var walletBalance;
//
//List<String> cartItemCartIds;
//List<String> cartItemNames;
//List<String> cartItemPrices;
//List<String> cartItemDescription;
//
//var finalAmount;
//
//List<String> addressIdsList;
//List<String> addressNamesList;
//
//bool show = false;
//
//Location location = new Location();
//LocationData _locationData;
//
//var lat;
//var long;
//
//var addresses;
//var first;
//
//var tempAddress;
//
//var ordersMap = Map();
//
//class BottomNavBar extends StatefulWidget {
//  @override
//  _BottomNavBarState createState() => _BottomNavBarState();
//}
//
//class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin{
//
//  Future<String> getWallet(context) async {
//
//    String url = globals.apiUrl + "getcustomerwallet.php";
//
//    http.post(url, body: {
//
//      "userID" : storedUserId.toString(),
//
//    }).then((http.Response response) async {
//      final int statusCode = response.statusCode;
//
//      if (statusCode < 200 || statusCode > 400 || json == null) {
//        throw new Exception("Error fetching data");
//
//      }
//
//      var responseArrayGetWallet = jsonDecode(response.body);
//      print(responseArrayGetWallet);
//
//      var responseArrayGetWalletMsg = responseArrayGetWallet['message'].toString();
//      print(responseArrayGetWalletMsg);
//
//      if(statusCode == 200){
//        if(responseArrayGetWalletMsg == "Item Found"){
//
//          setState(() {
//            walletBalance = responseArrayGetWallet['data']['customerwalletBalance'].toString();
//          });
//          print(walletBalance);
//          if(int.parse(walletBalance.toString()) > 0){
//            setState(() {
//              useWalletBalance = true;
//            });
//          }else{
//            setState(() {
//              useWalletBalance = false;
//            });
//          }
//
//          getCartItems(context);
//
//        }else{
//
//          Fluttertoast.showToast(msg: 'You have 0 balance currently', backgroundColor: Colors.black, textColor: Colors.white);
//
//          setState(() {
//            walletBalance = "0";
//          });
//          getCartItems(context);
//
//        }
//      }
//
//    }
//
//    );
//
//  }
//
//  Future<String> getCartItems(context) async {
//
//    setState(() {
//      itemCartItemId = [];
//      ordersMap = Map();
//    });
//
//    print(storedUserId.toString());
//    print(tempCartId.toString());
//
//    String url = globals.apiUrl + "getcart.php";
//
//    http.post(url, body: {
//
//      "userID" : storedUserId.toString(),
//      "cartID" : "",
//
//    }).then((http.Response response) async {
//      final int statusCode = response.statusCode;
//
//      if (statusCode < 200 || statusCode > 400 || json == null) {
//        throw new Exception("Error fetching data");
//      }
//
//      var responseArrayGetCart = jsonDecode(response.body);
//      print(responseArrayGetCart);
//
//      var responseArrayGetCartMsg = responseArrayGetCart['message'].toString();
//      print(responseArrayGetCartMsg);
//
//      if(statusCode == 200){
//        if(responseArrayGetCartMsg == "Item Found"){
//
//          setState(() {
//            cartItemCartIds = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemcartID'].toString());
//            cartItemIds = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemcartItemID'].toString());
//            cartItemVendorIds = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemVendorid'].toString());
//            cartItemNames = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemName'].toString());
//            cartItemPrices = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemPrice'].toString());
//            cartItemDescription = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemDescription'].toString());
//            cartDeliveryPartnerfeeList = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['vendorDeliverypartner'].toString());
//            cartTaxesPerItemList = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['vendorTax'].toString());
//            itemCartItemId = List.generate(responseArrayGetCart['data'].length, (index) => responseArrayGetCart['data'][index]['itemcartItemID'].toString());
//
//            itemCartItemId.forEach((element) {
//              if(!ordersMap.containsKey(element)) {
//                ordersMap[element] = 1;
//              } else {
//                ordersMap[element] +=1;
//              }
//            });
//
//            deliveryFees = responseArrayGetCart['deliveryfees'].toString();
//            taxFees = responseArrayGetCart['taxfees'].toString();
//            packingCharge = responseArrayGetCart['packingfees'].toString();
//
//            cart.totalItems = cartItemPrices.length.toString();
//            finalAmount = responseArrayGetCart['totalamt'].toString();
//            tempAmt = responseArrayGetCart['totalamt'].toString();
////            if(walletBalance == "0"){
////
////            }else{
//            tempAmt2 = (int.parse(tempAmt.toString())+ int.parse(deliveryFees.toString()) + int.parse(taxFees.toString()) + int.parse(packingCharge.toString()) -int.parse(walletBalance.toString())).toString();
//            //}
//
//            finalDeliveryCharge = (cartDeliveryPartnerfeeList[0]*cartDeliveryPartnerfeeList.length);
//            print("deliverycharge:::"+finalDeliveryCharge.toString());
//
//          });
//          print(cartItemCartIds.toList());
//          print(cartItemIds.toList());
//          print(cartItemVendorIds.toList());
//          print(cartItemNames.toList());
//          print(cartItemPrices.toList());
//          print(cartItemDescription.toList());
//          print(cartDeliveryPartnerfeeList.toList());
//          print(cartTaxesPerItemList.toList());
//          print(itemCartItemId.toList());
//          print(ordersMap);
//          print(totalPrice);
//          print(finalAmount);
//
//          print("tempAmt"+tempAmt.toString());
//          print("tempAmt2"+tempAmt2.toString());
//
//          print("DELIVERY FEES ::::::"+deliveryFees.toString());
//          print("TAX FEES ::::::"+taxFees.toString());
//          print("PACKING FEES ::::::"+packingCharge.toString());
//
//          getCartAdons(context);
//
//        }else{
//
//          //Fluttertoast.showToast(msg: 'No items found', backgroundColor: Colors.black, textColor: Colors.white);
//          setState(() {
//            cartItemCartIds = null;
//            ordersMap = Map();
//          });
//
//        }
//      }
//    });
//  }
//  Future<String> getCartAdons(context) async {
//
//    print(storedUserId.toString());
//    print(tempCartId.toString());
//
//    String url = globals.apiUrl + "getadsoncartbyuserid.php";
//
//    http.post(url, body: {
//
//      "userID" : storedUserId.toString(),
//
//    }).then((http.Response response) async {
//      final int statusCode = response.statusCode;
//
//      if (statusCode < 200 || statusCode > 400 || json == null) {
//        throw new Exception("Error fetching data");
//
//      }
//
//      var responseArrayGetCartA = jsonDecode(response.body);
//      print(responseArrayGetCartA);
//
//      var responseArrayGetCartAMsg = responseArrayGetCartA['message'].toString();
//      print(responseArrayGetCartAMsg);
//
//      if(statusCode == 200){
//        if(responseArrayGetCartAMsg == "Item Found"){
//
//          setState(() {
//            cartAdOnIdsList = List.generate(responseArrayGetCartA['data'].length, (index) => responseArrayGetCartA['data'][index]['adsoncartID'].toString());
//            cartAdOnNamesList = List.generate(responseArrayGetCartA['data'].length, (index) => responseArrayGetCartA['data'][index]['itemadsonName'].toString());
//            cartAdOnPricesList = List.generate(responseArrayGetCartA['data'].length, (index) => responseArrayGetCartA['data'][index]['itemadsonPrice'].toString());
//            int sum = cartAdOnPricesList.fold(0, (previous, current) => int.parse(previous.toString()) + int.parse(current.toString()));
//            print("adons total :" + sum.toString());
//            finalAmountWithAdOns = int.parse(finalAmount.toString())+int.parse(sum.toString());
//
////            if(walletBalance == "0"){
////
////            }else{
//            finalAmount2 = (int.parse(finalAmountWithAdOns.toString())+ int.parse(deliveryFees.toString()) + int.parse(taxFees.toString()) + int.parse(packingCharge.toString()) -int.parse(walletBalance.toString())).toString();
//            //}
//          });
//
//          print(cartAdOnIdsList.toList());
//          print(cartAdOnNamesList.toList());
//          print(cartAdOnPricesList.toList());
//          print("final amount : "+finalAmountWithAdOns.toString());
//          print(finalAmount2);
//
//        }else{
//
//          setState(() {
//            cartAdOnIdsList = [];
//            cartAdOnNamesList = [];
//            cartAdOnPricesList = [];
//          });
//
//        }
//      }
//    });
//  }
//
//  void updateCount(int count) {
//    setState((){
//      if(cart.totalItems == null || cart.totalItems == "null" || cart.totalItems == 0 || cart.totalItems == "0"){
////        setState(() {
////          cart.totalItems = 1;
////        });
//        getCartItems(context);
//      }else{
//        setState(() {
//          cart.totalItems = int.parse(cart.totalItems.toString())+1;
//        });
//        //getCartItems(context);
//      }
//    });
//    print(cart.totalItems);
//  }
//
//  void updateCountMinus(int count) {
//    if(cart.totalItems == 1 || cart.totalItems == "1"){
//      setState((){
//        setState(() {
//          cart.totalItems = 0;
//        });
//      });
//    }else{
//      setState((){
//        setState(() {
//          cart.totalItems = int.parse(cart.totalItems.toString())-1;
//        });
//      });
//    }
//    getCartItems(context);
//    print(cart.totalItems);
//  }
//
//  void updateCountToZero(int count) {
//    setState((){
//      setState(() {
//        cart.totalItems = 0;
//      });
//    });
//    getCartItems(context);
//    print(cart.totalItems);
//  }
//
//  void _onItemTapped(int index){
//    setState(() {
//      bottomnav.selectedIndex = index;
//    });
//    if(bottomnav.selectedIndex == 1 || bottomnav.selectedIndex == 0){
//      updateCountToZero(0);
//      //getCartItems(context);
//      build(context);
//    }
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    //getAddressList(context);
//    itemCartItemId = null;
//    getWallet(context);
//    setState(() {
//      show = false;
//    });
//    Future.delayed(Duration(seconds: 2), () async {
//      setState(() {
//        show = true;
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    List<Widget> pages = <Widget>[
//      HomePage(updateCart: updateCount, updateCartMinus: updateCountMinus,),
//      CartPage(updateCartMinus: updateCountMinus, updateToZeroo: updateCountToZero, getCarttt: getCartItems),
//      WalletPage(),
//      MyAccountPage(),
//    ];
//
//    return Scaffold(
//      body: WillPopScope(
//        onWillPop: ()=>
//            showDialog(
//              context: context,
//              builder: (context) =>
//              new AlertDialog(
//                title: new Text('Are you sure?'),
//                content: new Text('Do you want to exit the App'),
//                actions: <Widget>[
//                  new GestureDetector(
//                    onTap: () => exit(0),
//                    child: Padding(
//                      padding: const EdgeInsets.all(15.0),
//                      child: Text('Yes'),
//                    ),
//                  ),
//                  SizedBox(height: 16,),
//                  GestureDetector(
//                    onTap: () => Navigator.of(context).pop(false),
//                    child: Padding(
//                      padding: const EdgeInsets.all(15.0),
//                      child: Text('No'),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//        child: Center(
//          child: pages.elementAt(bottomnav.selectedIndex.toInt()),
//        ),
//      ),
//      bottomNavigationBar: buildBottomNavigationBar(context),
//    );
//  }
//
//  Widget buildBottomNavigationBar(BuildContext context){
//    return BottomNavigationBar(
//      elevation: 0,
//      backgroundColor: Colors.white,
//      currentIndex: bottomnav.selectedIndex,
//      type: BottomNavigationBarType.fixed,
//      unselectedItemColor: Colors.grey,
//      selectedItemColor: Colors.blue[900],
//      onTap: _onItemTapped,
//      items: <BottomNavigationBarItem>[
//        BottomNavigationBarItem(
//            icon: Icon(Icons.home),
//            title: Text('Home',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//              fontWeight: FontWeight.w400,
//              color: Colors.black,
//            ),)
//
//        ),
//        // BottomNavigationBarItem(
//        //     icon: Icon(Icons.calendar_today),
//        //     title: Text('Schedules')
//        //
//        // ),
//        BottomNavigationBarItem(
//            icon: cartItemCartIds == null || cart.totalItems.toString() == "0" ? Icon(Icons.shopping_cart_rounded) : Stack(
//              children: [
//                Icon(Icons.shopping_cart_rounded),
//                Padding(
//                  padding: const EdgeInsets.only(left: 15),
//                  child: Container(
//                    width: 8,
//                      height: 8,
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.all(Radius.circular(50)),
//                        color: Colors.red,
//                      ),
////                    child: Center(
////                      child: Text(cart.totalItems.toString(),
////                        style: TextStyle(color: Colors.white, fontSize: 10),
////                      ),
////                    ),
//                  ),
//                ),
//              ],
//            ),
//            title: Text('Cart',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//              fontWeight: FontWeight.w400,
//              color: Colors.black,
//    ))
//
//        ),
//
//        BottomNavigationBarItem(
//          icon: Icon(Icons.account_balance_wallet_rounded),
//          title: Text('Wallet',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//            fontWeight: FontWeight.w400,
//            color: Colors.black,
//          ))
//
//        ),
//        BottomNavigationBarItem(
//          icon: Icon(Icons.person),
//          title: Text('My Acount',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
//            fontWeight: FontWeight.w400,
//            color: Colors.black,
//          ))
//        ),
//      ],
//    );
//  }
//
//}
//
//
