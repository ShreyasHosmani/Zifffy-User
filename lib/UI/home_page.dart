import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dabbawala/UI/Widgets/switch_widget_veg_nonveg.dart';
import 'package:dabbawala/UI/add_to_cart_page.dart';
import 'package:dabbawala/UI/cart_page.dart';
import 'package:dabbawala/UI/choose_ad_ons.dart';
import 'package:dabbawala/UI/my_account_page.dart';
import 'package:dabbawala/UI/wallet_page.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'data/globals_data.dart';
import 'data/home_data.dart' as home;
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:dabbawala/UI/data/home_data.dart' as home;
import 'dart:convert';
import 'package:dabbawala/UI/Widgets/bottom_nav_bar.dart' as bm;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cart_page.dart' as cart;
import 'package:dabbawala/UI/data/bottom_nav_data.dart' as bottomnav;

bool permission = true;

bool showLoading = false;

var selectedPlace;
List<String> cuisineIds;
List<String> cuisineNames;

ProgressDialog prGetItems;

List<String> itemIdT;
List<String> itemNameT;
List<String> bannerImages;

List<String> itemCartItemId;

List<int> counters;
List<int> counters2;

var tempName;
var tempEmail;
var tempPhone;

int counter = 0;
var selectedItemType;
var selectedVegOrNonVeg;
var selectedItemId;
var selectedCuisine;
var tempCartId;
ProgressDialog prAddToCart;

var kInitialPosition = LatLng(lat, long);

var selectedItemIdForSearch;

bool showSearchedItem = false;

Location location = new Location();
LocationData _locationData;

var addresses;
var first;

var tempAddress;
var responseArrayGetAddresses = null;

var walletBalance;

List<String> cartItemCartIds;
List<String> cartItemNames;
List<String> cartItemPrices;
List<String> cartItemDescription;

var finalAmount;

List<String> addressIdsList;
List<String> addressNamesList;

bool show = false;

//Location location = new Location();
//LocationData _locationData;

var lat;
var long;

//var addresses;
//var first;
//
//var tempAddress;

var ordersMap = Map();

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {

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
    setState(() {
      itemCartItemId = [];
      ordersMap = Map();
    });

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
            itemCartItemId = List.generate(
                responseArrayGetCart['data'].length,
                (index) => responseArrayGetCart['data'][index]['itemcartItemID']
                    .toString());

            itemCartItemId.forEach((element) {
              if (!ordersMap.containsKey(element)) {
                ordersMap[element] = 1;
              } else {
                ordersMap[element] += 1;
              }
            });

            deliveryFees = responseArrayGetCart['deliveryfees'].toString();
            taxFees = responseArrayGetCart['taxfees'].toString();
            packingCharge = responseArrayGetCart['packingfees'].toString();

            cart.totalItems = cartItemPrices.length.toString();
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
          print(itemCartItemId.toList());
          print(ordersMap);
          //print(totalPrice);
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
            cart.totalItems = 0;
            ordersMap = Map();
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

          print(cartAdOnIdsList.toList());
          print(cartAdOnNamesList.toList());
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

  void updateCount(int count) {
    setState(() {
      if (cart.totalItems == null ||
          cart.totalItems == "null" ||
          cart.totalItems == 0 ||
          cart.totalItems == "0") {
        setState(() {
          cart.totalItems = 1;
        });
        //getCartItems(context);
      } else {
        setState(() {
          cart.totalItems = int.parse(cart.totalItems.toString()) + 1;
        });
        getCartItems(context);
      }
    });
    print(cart.totalItems);
  }

  void updateCountMinus(int count) {
    if (cart.totalItems == 1 ||
        cart.totalItems == "1" ||
        cart.totalItems == 0 ||
        cart.totalItems == "0") {
      //setState((){
      setState(() {
        cart.totalItems = 0;
      });
      //});
      //getCartItems(context);
    } else {
      //setState((){
      setState(() {
        cart.totalItems = int.parse(cart.totalItems.toString()) - 1;
      });
      //getCartItems(context);
      //});
    }
    print(cart.totalItems);
  }

  void updateCountToZero(int count) {
    setState(() {
      setState(() {
        cart.totalItems = 0;
      });
    });
    //getCartItems(context);
    print(cart.totalItems);
  }

  void _onItemTapped(int index) {
    setState(() {
      bottomnav.selectedIndex = index;
    });
    if (bottomnav.selectedIndex == 1 || bottomnav.selectedIndex == 0) {
      //updateCountToZero(0);
      getCartItems(context);
      build(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getAddressList(context);
    itemCartItemId = null;
    getWallet(context);
    setState(() {
      show = false;
    });
    Future.delayed(Duration(seconds: 2), () async {
      setState(() {
        show = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    List<Widget> pages = <Widget>[
      HomePage(
        updateCart: updateCount,
        updateCartMinus: updateCountMinus,
      ),
      CartPage(
          updateCartMinus: updateCountMinus,
          updateToZeroo: updateCountToZero,
          getCarttt: getCartItems),
      WalletPage(),
      MyAccountPage(),
    ];

    return Scaffold(
      body: WillPopScope(
        onWillPop: () => showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => exit(0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Yes'),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('No'),
                ),
              ),
            ],
          ),
        ),
        child: Center(
          child: pages.elementAt(bottomnav.selectedIndex.toInt()),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: Colors.white,
      currentIndex: bottomnav.selectedIndex,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.blue[900],
      onTap: _onItemTapped,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              textScaleFactor: 1,
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            )),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.calendar_today),
        //     title: Text('Schedules')
        //
        // ),
        BottomNavigationBarItem(
            icon: cart.totalItems == "0" || cart.totalItems == 0 || cart.totalItems == null || cart.totalItems == "null"
                ? Icon(Icons.shopping_cart_rounded)
                : Stack(
                    children: [
                      Icon(Icons.shopping_cart_rounded),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              cart.totalItems.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            title: Text('Cart',
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ))),

        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            title: Text('Wallet',
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ))),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('My Acount',
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ))),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  final ValueChanged<int> updateCart;
  final ValueChanged<int> updateCartMinus;

  HomePage({this.updateCart, this.updateCartMinus});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          //print(totalPrice);
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
            widget.updateCartMinus(0);
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

          print(cartAdOnIdsList.toList());
          print(cartAdOnNamesList.toList());
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

  Future<String> getAddressList(context) async {
    String url = globals.apiUrl + "getcustomeraddress.php";

    http.post(url, body: {
      "customerID": storedUserId.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      responseArrayGetAddresses = jsonDecode(response.body);
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
          });
          print(addressIdsList.toList());
          print(addressNamesList.toList());

          try {
            _locationData = await location.getLocation();
            print(_locationData.toString());
          } on PlatformException catch (e) {
            if (e.code == 'PERMISSION_DENIED') {
              setState(() {
                permission = false;
              });
              print("permission value : " + permission.toString());
            } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
              setState(() {
                permission = false;
              });
              print("permission value : " + permission.toString());
            }
          }

          setState(() {
            lat = _locationData.latitude;
            long = _locationData.longitude;
          });

          final coordinates = new Coordinates(lat, long);
          addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          first = addresses.first;
          print("${first.featureName} : ${first.addressLine}");

          setState(() {
            tempAddress = "${first.featureName} : ${first.addressLine}";
          });

          print(tempAddress);

          getItemListAccToLatLong(context);
        } else {
          //Fluttertoast.showToast(msg: 'No saved location found, using current location...', backgroundColor: Colors.black, textColor: Colors.white);
          setState(() {
            addressIdsList = null;
          });

          try {
            _locationData = await location.getLocation();
            print(_locationData.toString());
          } on PlatformException catch (e) {
            if (e.code == 'PERMISSION_DENIED') {
              setState(() {
                permission = false;
              });
              print("permission value : " + permission.toString());
            } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
              setState(() {
                permission = false;
              });
              print("permission value : " + permission.toString());
            }
          }

          setState(() {
            lat = _locationData.latitude;
            long = _locationData.longitude;
          });

          final coordinates = new Coordinates(lat, long);
          addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          first = addresses.first;
          print("${first.featureName} : ${first.addressLine}");

          setState(() {
            tempAddress = "${first.featureName} : ${first.addressLine}";
          });

          print(tempAddress);

          getItemListAccToLatLong(context);
        }
      }
    });
  }

  Future<String> getItemListAccToLatLong(context) async {
    String url = globals.apiUrl + "getnearbyvendorsbylatlong.php";

    http.post(url, body: {
      "latitude": lat.toString(),
      "longitude": long.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }
      home.responseArrayGetItems = jsonDecode(response.body);
      print(home.responseArrayGetItems);
      home.getItemsResponse = home.responseArrayGetItems['status'].toString();
      home.getItemsMessage = home.responseArrayGetItems['message'].toString();
      if (statusCode == 200) {
        if (home.getItemsMessage == "Item Found") {
          prGetItems.hide();
          setState(() {
            home.itemId = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]['itemID']);
            home.itemName = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemName']);
            home.itemPrice = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemPrice']);
            home.image = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['imageName']);
            home.itemDescription = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemDescription']);
            home.vendorName = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['vendorName']);
            home.itemErt = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemAvabilityend']);
            counters = List.generate(
                home.itemId.length,
                (index) => ordersMap.containsKey(home.itemId[index])
                    ? ordersMap[home.itemId[index]]
                    : 0);
          });
          print(home.itemId);
          print(home.itemName);
          print(home.itemPrice);
          print(home.image);
          print(home.itemDescription);
          print(home.vendorName);
          print(home.itemErt);
          print(counters);

          getItemListTwo(context);

          setState(() {
            showLoading = false;
          });
        } else {
          prGetItems.hide();
          setState(() {
            home.itemId = null;
          });

          setState(() {
            showLoading = false;
          });
        }
      }
    });
  }

  Future<String> getItemList(context) async {
    String url = globals.apiUrl + "getallitemlist.php";

    http.post(url, body: {}).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }
      home.responseArrayGetItems = jsonDecode(response.body);
      print(home.responseArrayGetItems);
      home.getItemsResponse = home.responseArrayGetItems['status'].toString();
      home.getItemsMessage = home.responseArrayGetItems['message'].toString();
      if (statusCode == 200) {
        if (home.getItemsMessage == "Item Found") {
          prGetItems.hide();
          setState(() {
            home.itemId = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]['itemID']);
            home.itemName = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemName']);
            home.itemPrice = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemPrice']);
            home.image = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['imageName']);
            home.itemDescription = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemDescription']);
            home.vendorName = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['vendorName']);
            home.itemErt = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemAvabilityend']);
            counters = List.generate(
                home.itemId.length,
                (index) => ordersMap.containsKey(home.itemId[index])
                    ? ordersMap[home.itemId[index]]
                    : 0);
          });
          print(home.itemId);
          print(home.itemName);
          print(home.itemPrice);
          print(home.image);
          print(home.itemDescription);
          print(home.vendorName);
          print(home.itemErt);
          print(counters);
        } else {
          prGetItems.hide();
          setState(() {
            home.itemId = null;
          });
        }
      }
    });
  }

  Future<String> getItemListTwo(context) async {
    String url = globals.apiUrl + "getnearbyvendorsbylatlong.php";

    http.post(url, body: {
      "latitude": lat.toString(),
      "longitude": long.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }
      home.responseArrayGetItems = jsonDecode(response.body);
      print(home.responseArrayGetItems);
      home.getItemsResponse = home.responseArrayGetItems['status'].toString();
      home.getItemsMessage = home.responseArrayGetItems['message'].toString();
      if (statusCode == 200) {
        if (home.getItemsMessage == "Item Found") {
          prGetItems.hide();
          setState(() {
            home.itemId2 = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]['itemID']);
            home.itemName2 = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemName']);
            home.itemNameTwo = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemName']);
            home.itemPrice2 = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemPrice']);
            home.image2 = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['imageName']);
            home.itemDescription2 = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemDescription']);
            home.vendorName2 = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['vendorName']);
            home.itemErt2 = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemAvabilityend']);
            counters2 = List.generate(
                home.itemId2.length,
                (index) => ordersMap.containsKey(home.itemId2[index])
                    ? ordersMap[home.itemId2[index]]
                    : 0);
          });
          print(home.itemId2);
          print(home.itemName2);
          print(home.itemNameTwo);
          print(home.itemPrice2);
          print(home.image2);
          print(home.itemDescription2);
          print(home.vendorName2);
          print(home.itemErt2);
          print(counters2);
        } else {
          prGetItems.hide();
          setState(() {
            home.itemId2 = null;
          });
        }
      }
    });
  }

  Future<String> getItemListAccordingToBLSD(context) async {
    String url = globals.apiUrl + "getitemsbytype.php";

    http.post(url, body: {
      "itemtype": selectedItemType.toString(),
      "latitude": lat.toString(),
      "longitude": long.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }
      home.responseArrayGetItems = jsonDecode(response.body);
      print(home.responseArrayGetItems);
      home.getItemsResponse = home.responseArrayGetItems['status'].toString();
      home.getItemsMessage = home.responseArrayGetItems['message'].toString();
      if (statusCode == 200) {
        if (home.getItemsMessage == "Item Found") {
          prGetItems.hide();
          setState(() {
            home.itemId = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]['itemID']);
            home.itemName = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemName']);
            home.itemPrice = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemPrice']);
            home.image = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['imageName']);
            home.itemDescription = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemDescription']);
            home.vendorName = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['vendorName']);
            home.itemErt = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemAvabilityend']);
            counters = List.generate(
                home.itemId.length,
                (index) => ordersMap.containsKey(home.itemId[index])
                    ? ordersMap[home.itemId[index]]
                    : 0);
          });
          print(home.itemId);
          print(home.itemName);
          print(home.itemPrice);
          print(home.image);
          print(home.itemDescription);
          print(home.vendorName);
          List<String> itemErt;
          print(counters);
        } else {
          prGetItems.hide();
          setState(() {
            home.itemId = null;
          });
        }
      }
    });
  }

  Future<String> getItemListAccordingToVegNonVeg(context) async {
    String url = globals.apiUrl + "getitemsbycategory.php";

    http.post(url, body: {
      "category": selectedVegOrNonVeg.toString(),
      "latitude": lat.toString(),
      "longitude": long.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }
      home.responseArrayGetItems = jsonDecode(response.body);
      print(home.responseArrayGetItems);
      home.getItemsResponse = home.responseArrayGetItems['status'].toString();
      home.getItemsMessage = home.responseArrayGetItems['message'].toString();
      if (statusCode == 200) {
        if (home.getItemsMessage == "Item Found") {
          prGetItems.hide();
          setState(() {
            home.itemId = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]['itemID']);
            home.itemName = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemName']);
            home.itemPrice = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['itemPrice']);
            home.image = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['imageName']);
            home.itemDescription = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemDescription']);
            home.vendorName = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) =>
                    home.responseArrayGetItems['data'][index]['vendorName']);
            home.itemErt = List.generate(
                home.responseArrayGetItems['data'].length,
                (index) => home.responseArrayGetItems['data'][index]
                    ['itemAvabilityend']);
            counters = List.generate(
                home.itemId.length,
                (index) => ordersMap.containsKey(home.itemId[index])
                    ? ordersMap[home.itemId[index]]
                    : 0);
          });
          print(home.itemId);
          print(home.itemName);
          print(home.itemPrice);
          print(home.image);
          print(home.itemDescription);
          print(home.vendorName);
          List<String> itemErt;
          print(counters);
        } else {
          prGetItems.hide();
          setState(() {
            home.itemId = null;
          });
        }
      }
    });
  }

  /*
  Future<String> getItemListAccordingToCuisine(context) async {

    String url = globals.apiUrl + "getitemsbycuisine.php";

    if(selectedCuisine.length == 9){
      http.post(url, body: {

        "cuisineid[0]" : selectedCuisine[0].toString(),
        "cuisineid[1]" : selectedCuisine[1].toString(),
        "cuisineid[2]" : selectedCuisine[2].toString(),
        "cuisineid[3]" : selectedCuisine[3].toString(),
        "cuisineid[4]" : selectedCuisine[4].toString(),
        "cuisineid[5]" : selectedCuisine[5].toString(),
        "cuisineid[6]" : selectedCuisine[6].toString(),
        "cuisineid[7]" : selectedCuisine[7].toString(),
        "cuisineid[8]" : selectedCuisine[8].toString(),

      }).then((http.Response response) async {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error fetching data");

        }
        home.responseArrayGetItems = jsonDecode(response.body);
        print(home.responseArrayGetItems);
        home.getItemsResponse = home.responseArrayGetItems['status'].toString();
        home.getItemsMessage = home.responseArrayGetItems['message'].toString();
        if(statusCode == 200){
          if(home.getItemsMessage == "Item Found"){
            setState(() {
              home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index] == null || home.responseArrayGetItems['data'][0][index] == [] ? "null" : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemPrice']);
              home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['imageName']);
              home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemDescription']);
              home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['vendorName']);
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            print(counters);

            setState(() {
              selectedCuisine = [];
            });
            print(selectedCuisine.toList());

          }else{
            setState(() {
              home.itemId = null;
            });

          }
        }
      });
    }else if(selectedCuisine.length == 8){
      http.post(url, body: {

        "cuisineid[0]" : selectedCuisine[0].toString(),
        "cuisineid[1]" : selectedCuisine[1].toString(),
        "cuisineid[2]" : selectedCuisine[2].toString(),
        "cuisineid[3]" : selectedCuisine[3].toString(),
        "cuisineid[4]" : selectedCuisine[4].toString(),
        "cuisineid[5]" : selectedCuisine[5].toString(),
        "cuisineid[6]" : selectedCuisine[6].toString(),
        "cuisineid[7]" : selectedCuisine[7].toString(),

      }).then((http.Response response) async {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error fetching data");

        }
        home.responseArrayGetItems = jsonDecode(response.body);
        print(home.responseArrayGetItems);
        home.getItemsResponse = home.responseArrayGetItems['status'].toString();
        home.getItemsMessage = home.responseArrayGetItems['message'].toString();
        if(statusCode == 200){
          if(home.getItemsMessage == "Item Found"){
            setState(() {
              home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index] == null || home.responseArrayGetItems['data'][0][index] == [] ? "null" : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemPrice']);
              home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['imageName']);
              home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemDescription']);
              home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['vendorName']);
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            print(counters);

            setState(() {
              selectedCuisine = [];
            });
            print(selectedCuisine.toList());

          }else{
            setState(() {
              home.itemId = null;
            });

          }
        }
      });
    }else if(selectedCuisine.length == 7){
      http.post(url, body: {

        "cuisineid[0]" : selectedCuisine[0].toString(),
        "cuisineid[1]" : selectedCuisine[1].toString(),
        "cuisineid[2]" : selectedCuisine[2].toString(),
        "cuisineid[3]" : selectedCuisine[3].toString(),
        "cuisineid[4]" : selectedCuisine[4].toString(),
        "cuisineid[5]" : selectedCuisine[5].toString(),
        "cuisineid[6]" : selectedCuisine[6].toString(),

      }).then((http.Response response) async {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error fetching data");

        }
        home.responseArrayGetItems = jsonDecode(response.body);
        print(home.responseArrayGetItems);
        home.getItemsResponse = home.responseArrayGetItems['status'].toString();
        home.getItemsMessage = home.responseArrayGetItems['message'].toString();
        if(statusCode == 200){
          if(home.getItemsMessage == "Item Found"){
            setState(() {
              home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index] == null || home.responseArrayGetItems['data'][0][index] == [] ? "null" : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemPrice']);
              home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['imageName']);
              home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemDescription']);
              home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['vendorName']);
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            print(counters);

            setState(() {
              selectedCuisine = [];
            });
            print(selectedCuisine.toList());

          }else{
            setState(() {
              home.itemId = null;
            });

          }
        }
      });
    }else if(selectedCuisine.length == 6){
      http.post(url, body: {

        "cuisineid[0]" : selectedCuisine[0].toString(),
        "cuisineid[1]" : selectedCuisine[1].toString(),
        "cuisineid[2]" : selectedCuisine[2].toString(),
        "cuisineid[3]" : selectedCuisine[3].toString(),
        "cuisineid[4]" : selectedCuisine[4].toString(),
        "cuisineid[5]" : selectedCuisine[5].toString(),

      }).then((http.Response response) async {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error fetching data");

        }
        home.responseArrayGetItems = jsonDecode(response.body);
        print(home.responseArrayGetItems);
        home.getItemsResponse = home.responseArrayGetItems['status'].toString();
        home.getItemsMessage = home.responseArrayGetItems['message'].toString();
        if(statusCode == 200){
          if(home.getItemsMessage == "Item Found"){
            setState(() {
              home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index] == null || home.responseArrayGetItems['data'][0][index] == [] ? "null" : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemPrice']);
              home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['imageName']);
              home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemDescription']);
              home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['vendorName']);
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            print(counters);

            setState(() {
              selectedCuisine = [];
            });
            print(selectedCuisine.toList());

          }else{
            setState(() {
              home.itemId = null;
            });

          }
        }
      });
    }else if(selectedCuisine.length == 5){
      http.post(url, body: {

        "cuisineid[0]" : selectedCuisine[0].toString(),
        "cuisineid[1]" : selectedCuisine[1].toString(),
        "cuisineid[2]" : selectedCuisine[2].toString(),
        "cuisineid[3]" : selectedCuisine[3].toString(),
        "cuisineid[4]" : selectedCuisine[4].toString(),

      }).then((http.Response response) async {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error fetching data");

        }
        home.responseArrayGetItems = jsonDecode(response.body);
        print(home.responseArrayGetItems);
        home.getItemsResponse = home.responseArrayGetItems['status'].toString();
        home.getItemsMessage = home.responseArrayGetItems['message'].toString();
        if(statusCode == 200){
          if(home.getItemsMessage == "Item Found"){
            setState(() {
              home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index] == null || home.responseArrayGetItems['data'][0][index] == [] ? "null" : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemPrice']);
              home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['imageName']);
              home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemDescription']);
              home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['vendorName']);
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            print(counters);

            setState(() {
              selectedCuisine = [];
            });
            print(selectedCuisine.toList());

          }else{
            setState(() {
              home.itemId = null;
            });

          }
        }
      });
    }else if(selectedCuisine.length == 4){
      http.post(url, body: {

        "cuisineid[0]" : selectedCuisine[0].toString(),
        "cuisineid[1]" : selectedCuisine[1].toString(),
        "cuisineid[2]" : selectedCuisine[2].toString(),
        "cuisineid[3]" : selectedCuisine[3].toString(),

      }).then((http.Response response) async {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error fetching data");

        }
        home.responseArrayGetItems = jsonDecode(response.body);
        print(home.responseArrayGetItems);
        home.getItemsResponse = home.responseArrayGetItems['status'].toString();
        home.getItemsMessage = home.responseArrayGetItems['message'].toString();
        if(statusCode == 200){
          if(home.getItemsMessage == "Item Found"){
            setState(() {
              home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index] == null || home.responseArrayGetItems['data'][0][index] == [] ? "null" : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemPrice']);
              home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['imageName']);
              home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemDescription']);
              home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['vendorName']);
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            print(counters);

            setState(() {
              selectedCuisine = [];
            });
            print(selectedCuisine.toList());

          }else{
            setState(() {
              home.itemId = null;
            });

          }
        }
      });
    }else if(selectedCuisine.length == 3){
      http.post(url, body: {

        "cuisineid[0]" : selectedCuisine[0].toString(),
        "cuisineid[1]" : selectedCuisine[1].toString(),
        "cuisineid[2]" : selectedCuisine[2].toString(),

      }).then((http.Response response) async {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error fetching data");

        }
        home.responseArrayGetItems = jsonDecode(response.body);
        print(home.responseArrayGetItems);
        home.getItemsResponse = home.responseArrayGetItems['status'].toString();
        home.getItemsMessage = home.responseArrayGetItems['message'].toString();
        if(statusCode == 200){
          if(home.getItemsMessage == "Item Found"){
            setState(() {
              home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index] == null || home.responseArrayGetItems['data'][0][index] == [] ? "null" : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemPrice']);
              home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['imageName']);
              home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemDescription']);
              home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['vendorName']);
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            print(counters);

            setState(() {
              selectedCuisine = [];
            });
            print(selectedCuisine.toList());

          }else{
            setState(() {
              home.itemId = null;
            });

          }
        }
      });
    }else if(selectedCuisine.length == 2){
      http.post(url, body: {

        "cuisineid[0]" : selectedCuisine[0].toString(),
        "cuisineid[1]" : selectedCuisine[1].toString(),

      }).then((http.Response response) async {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error fetching data");

        }
        home.responseArrayGetItems = jsonDecode(response.body);
        print(home.responseArrayGetItems);
        home.getItemsResponse = home.responseArrayGetItems['status'].toString();
        home.getItemsMessage = home.responseArrayGetItems['message'].toString();
        if(statusCode == 200){
          if(home.getItemsMessage == "Item Found"){
            setState(() {
              home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index] == null || home.responseArrayGetItems['data'][0][index] == [] ? "null" : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemPrice']);
              home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['imageName']);
              home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemDescription']);
              home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['vendorName']);
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            print(counters);

            setState(() {
              selectedCuisine = [];
            });
            print(selectedCuisine.toList());

          }else{
            setState(() {
              home.itemId = null;
            });

          }
        }
      });
    }else if(selectedCuisine.length == 1){
      http.post(url, body: {

        "cuisineid[0]" : selectedCuisine[0].toString(),

      }).then((http.Response response) async {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new Exception("Error fetching data");

        }
        home.responseArrayGetItems = jsonDecode(response.body);
        print(home.responseArrayGetItems);
        home.getItemsResponse = home.responseArrayGetItems['status'].toString();
        home.getItemsMessage = home.responseArrayGetItems['message'].toString();
        if(statusCode == 200){
          if(home.getItemsMessage == "Item Found"){
            setState(() {
              home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index] == null || home.responseArrayGetItems['data'][0][index] == [] ? "null" : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemPrice']);
              home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['imageName']);
              home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][0][index]['itemDescription']);
              home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index][0]['vendorName']);
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            print(counters);

            setState(() {
              selectedCuisine = [];
            });
            print(selectedCuisine.toList());

          }else{
            setState(() {
              home.itemId = null;
            });

          }
        }
      });
    }else{

    }

  }

   */

  Future<String> getItemListAccordingToCuisine(context) async {
    String url = globals.apiUrl + "getitemsbycuisine.php";

    http.post(url, body: {
      "cuisineid[0]": selectedCuisine.toString(),
      "latitude": lat.toString(),
      "longitude": long.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }
      home.responseArrayGetItems = jsonDecode(response.body);
      print(home.responseArrayGetItems);
      home.getItemsResponse = home.responseArrayGetItems['status'].toString();
      home.getItemsMessage = home.responseArrayGetItems['message'].toString();
      if (statusCode == 200) {
        if (home.getItemsMessage == "Item Found") {
          setState(() {
            selectedCuisine = null;
          });

          if (home.responseArrayGetItems['data'][0].isEmpty) {
            print("empty....");
            setState(() {
              home.itemId = null;
            });
          } else {
            setState(() {
              home.itemId = List.generate(
                  home.responseArrayGetItems['data'][0].length,
                  (index) => home.responseArrayGetItems['data'][0][index] ==
                              null ||
                          home.responseArrayGetItems['data'][0][index] == []
                      ? "null"
                      : home.responseArrayGetItems['data'][0][index]['itemID']);
              home.itemName = List.generate(
                  home.responseArrayGetItems['data'][0].length,
                  (index) =>
                      home.responseArrayGetItems['data'][0][index]['itemName']);
              home.itemPrice = List.generate(
                  home.responseArrayGetItems['data'][0].length,
                  (index) => home.responseArrayGetItems['data'][0][index]
                      ['itemPrice']);
              home.image = List.generate(
                  home.responseArrayGetItems['data'][0].length,
                  (index) => home.responseArrayGetItems['data'][0][index]
                      ['imageName']);
              home.itemDescription = List.generate(
                  home.responseArrayGetItems['data'][0].length,
                  (index) => home.responseArrayGetItems['data'][0][index]
                      ['itemDescription']);
              home.vendorName = List.generate(
                  home.responseArrayGetItems['data'][0].length,
                  (index) => home.responseArrayGetItems['data'][0][index]
                      ['vendorName']);
              home.itemErt = List.generate(
                  home.responseArrayGetItems['data'].length,
                  (index) => home.responseArrayGetItems['data'][index]
                      ['itemAvabilityend']);
              counters = List.generate(
                  home.itemId.length,
                  (index) => ordersMap.containsKey(home.itemId[index])
                      ? ordersMap[home.itemId[index]]
                      : 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
            List<String> itemErt;
            print(counters);
          }
        } else {
          setState(() {
            home.itemId = null;
          });
        }
      }
    });
  }

  Future<String> getItemAdons(context) async {
    String url = globals.apiUrl + "getitemadsonlist.php";

    http.post(url, body: {
      "itemID": selectedItemId.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }
      home.responseArrayGetAdons = jsonDecode(response.body);
      print(home.responseArrayGetAdons);
      home.getAdonsResponse = home.responseArrayGetAdons['status'].toString();
      home.getAdonsMessage = home.responseArrayGetAdons['message'].toString();
      if (statusCode == 200) {
        if (home.getAdonsMessage == "Item Found") {
          setState(() {
            home.adonName = List.generate(
                home.responseArrayGetAdons['data'].length,
                (index) => home.responseArrayGetAdons['data'][index]
                        ['itemadsonName']
                    .toString());
            home.adonPrice = List.generate(
                home.responseArrayGetAdons['data'].length,
                (index) => home.responseArrayGetAdons['data'][index]
                        ['itemadsonPrice']
                    .toString());
          });
          print(home.adonName);
          print(home.adonPrice);
        } else {
          setState(() {
            home.adonName = null;
          });
        }
      }
    });
  }

  Future<String> addToCart(context) async {
    String url = globals.apiUrl + "addcart.php";

    http.post(url, body: {
      "itemID": selectedItemId.toString(),
      "userID": storedUserId.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayAddToCart = jsonDecode(response.body);
      print(responseArrayAddToCart);

      var responseArrayAddToCartMsg =
          responseArrayAddToCart['message'].toString();
      print(responseArrayAddToCartMsg);

      if (statusCode == 200) {
        if (responseArrayAddToCartMsg == "Successfully") {
          Fluttertoast.showToast(
              msg: 'Added to cart',
              backgroundColor: Colors.black,
              textColor: Colors.white);

          setState(() {
            tempCartId = responseArrayAddToCart['data'].toString();
          });
          print(tempCartId);
          getWallet(context);
        } else {
          Fluttertoast.showToast(
              msg: 'Some error occured',
              backgroundColor: Colors.black,
              textColor: Colors.white);
        }
      }
    });
  }

  Future<String> removeFromCart(context) async {
    String url = globals.apiUrl + "removeitembyuseranditem.php";

    http.post(url, body: {
      "userID": storedUserId.toString(),
      "itemID": selectedItemId.toString(),
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
          prAddToCart.hide();
          getCartItems(context);
        } else {
          prAddToCart.hide();
          Fluttertoast.showToast(
              msg: 'Some error occured',
              backgroundColor: Colors.black,
              textColor: Colors.white);
        }
      }
    });
  }

  Future<String> addAddOnsToCart(context) async {
    print(tempCartId);

    String url = globals.apiUrl + "addcartadson.php";

    http.post(url, body: {
      "cartID": "$tempCartId",
      "adsonID[0]": "1",
      "adsonID[1]": "2",
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayAddAdsOn = jsonDecode(response.body);
      print(responseArrayAddAdsOn);

      var responseArrayAddAdsOnMsg =
          responseArrayAddAdsOn['message'].toString();
      print(responseArrayAddAdsOnMsg);

      if (statusCode == 200) {
        if (responseArrayAddAdsOnMsg == "Successfully") {
          Fluttertoast.showToast(
              msg: 'Added to cart',
              backgroundColor: Colors.black,
              textColor: Colors.white);
        } else {
          Fluttertoast.showToast(
              msg: 'Some error occured',
              backgroundColor: Colors.black,
              textColor: Colors.white);
        }
      }
    });
  }

  Future<String> getProfile(context) async {
    String url = globals.apiUrl + "getprofile.php";

    http.post(url, body: {
      "customerID": storedUserId.toString(),
    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayGetProfile = jsonDecode(response.body);
      print(responseArrayGetProfile);

      var responseArrayGetProfileMsg =
          responseArrayGetProfile['message'].toString();
      print(responseArrayGetProfileMsg);

      //if(statusCode == 200){
      if (responseArrayGetProfileMsg == "Item Found") {
        setState(() {
          tempName =
              responseArrayGetProfile['data']['customerFullname'].toString();
          tempEmail =
              responseArrayGetProfile['data']['customerEmail'].toString();
          tempPhone =
              responseArrayGetProfile['data']['customerMobileno'].toString();
        });
        print(tempName);
        print(tempEmail);
        print(tempPhone);
      } else {
        Fluttertoast.showToast(
            msg: 'Some error occured',
            backgroundColor: Colors.black,
            textColor: Colors.white);
      }
      //}
    });
  }

  Future<String> deleteCart(context) async {
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
          print("deleted cart successfully...");
        } else {
          print("cart was empty...");
        }
      }
    });
  }

  Future<String> getBannerImages(context) async {
    String url =
        "https://admin.dabbawala.ml/mobileapi/user/getoffersandbanner.php";

    http.post(url, body: {}).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }
      var responseArrayGetImages = jsonDecode(response.body);
      print(responseArrayGetImages);

      var responseArrayGetImagesMsg =
          responseArrayGetImages['message'].toString();
      print(responseArrayGetImagesMsg);

      if (statusCode == 200) {
        if (responseArrayGetImagesMsg == "Item Found") {
          setState(() {
            bannerImages = List.generate(
                responseArrayGetImages['data'].length,
                (index) =>
                    domainUrl +
                    responseArrayGetImages['data'][index]['imageName']
                        .toString());
          });
          print(bannerImages);
        } else {
          setState(() {
            bannerImages = null;
          });
        }
      }
    });
  }

  Future<String> getCuisines(context) async {
    String url =
        "https://admin.dabbawala.ml/mobileapi/vendor/getallcuisine.php";

    http.post(url, body: {}).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }
      var responseArrayGetCusines = jsonDecode(response.body);
      print(responseArrayGetCusines);

      var responseArrayGetCusinesMsg =
          responseArrayGetCusines['message'].toString();
      print(responseArrayGetCusinesMsg);

      if (statusCode == 200) {
        if (responseArrayGetCusinesMsg == "Cuisine Found") {
          //prGetItems.hide();
          setState(() {
            cuisineIds = List.generate(
                responseArrayGetCusines['data'].length,
                (index) => responseArrayGetCusines['data'][index]['cuisineID']
                    .toString());
            cuisineNames = List.generate(
                responseArrayGetCusines['data'].length,
                (index) => responseArrayGetCusines['data'][index]['cuisineName']
                    .toString());
          });
          print(cuisineIds.toList());
          print(cuisineNames.toList());
        } else {
          //prGetItems.hide();
          setState(() {});
        }
      }
    });
  }

  void toggleSwitch(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        selectedVegOrNonVeg = "Veg";
      });
      print(selectedVegOrNonVeg);
      prGetItems.show();
      getItemListAccordingToVegNonVeg(context);
    } else {
      setState(() {
        switchControl = false;
        selectedVegOrNonVeg = "Nonveg";
      });
      print(selectedVegOrNonVeg);
      prGetItems.show();
      getItemListAccordingToVegNonVeg(context);
    }
  }

  Widget appBarTitle = new Text(
    "Zifffy",
    style: GoogleFonts.nunitoSans(
      color: Colors.black,
    ),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.black,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      showLoading = true;
    });
    setState(() {
//      if(lat == null || long == null){
//
//      }else{
//        kInitialPosition = LatLng(lat, long);
//      }
      permission = true;
      showSearchedItem = false;
      switchControl = true;
      selectedItemType = null;
      selectedVegOrNonVeg = null;
      selectedCuisine = [];
      selectedItemIdForSearch = null;
    });
    getProfile(context);
    if (responseArrayGetAddresses == null ||
        responseArrayGetAddresses == "null") {
      getAddressList(context);
      //getItemListAccToLatLong(context);
      //getItemList(context);
      //getItemListTwo(context);
      getBannerImages(context);
      getCuisines(context);
      //deleteCart(context);
    } else {
      //getCartItems(context);
      Future.delayed(Duration(seconds: 3), () async {
        getItemListAccToLatLong(context);
      });
    }
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    getCuisines(context);
    getItemListTwo(context);
  }

  Future<Null> rebuild(BuildContext context) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      rebuild(context);
    });
    prAddToCart = ProgressDialog(context);
    prGetItems = ProgressDialog(context);
    return WillPopScope(
      onWillPop: () => showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit the App'),
          actions: <Widget>[
            new GestureDetector(
              onTap: () => exit(0),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Yes'),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('No'),
              ),
            ),
          ],
        ),
      ),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: buildAppBar(context),
          backgroundColor: Colors.white,
          body: bannerImages == null
              ? Center(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey.shade200,
                                        highlightColor: Colors.white,
                                        child: Text(
                                          "Quality meals with exciting offers and promos",
                                          textScaleFactor: 1,
                                          style: GoogleFonts.nunitoSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.white,
                                    child: CarouselSlider.builder(
                                      itemCount: 1,
                                      options: CarouselOptions(
                                          height: 200,
                                          viewportFraction: 1,
                                          initialPage: 0,
                                          enableInfiniteScroll: true,
                                          reverse: false,
                                          autoPlay: false,
                                          autoPlayInterval:
                                              Duration(seconds: 3),
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 800),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              //currentS = index;
                                            });
                                          }),
                                      itemBuilder:
                                          (BuildContext context, index) =>
                                              Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0),
                                        child: Card(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              //launch(home.sponsoredAdUrl[index]);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade200,
                                      highlightColor: Colors.white,
                                      child: Text(
                                        "Browse through meal timings",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.nunitoSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(width: 220, child: Divider()),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 25,
                                    width: MediaQuery.of(context).size.width,
                                    child: DefaultTabController(
                                      length: 5,
                                      child: TabBar(
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicator: null,
                                        indicatorColor: Colors.white,
                                        labelColor: Colors.black,
                                        unselectedLabelColor: Colors.black,
                                        tabs: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedItemType = null;
                                              });
                                              print(selectedItemType);
                                              prGetItems.show();
                                              getItemListAccToLatLong(context);
                                            },
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade200,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                'All',
                                                textScaleFactor: 1,
                                                style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color:
                                                      selectedItemType == null
                                                          ? Colors.blue
                                                          : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedItemType = "Breakfast";
                                              });
                                              print(selectedItemType);
                                              prGetItems.show();
                                              getItemListAccordingToBLSD(
                                                  context);
                                            },
                                            child: Tab(
                                              child: Center(
                                                child: Shimmer.fromColors(
                                                  baseColor:
                                                      Colors.grey.shade200,
                                                  highlightColor: Colors.white,
                                                  child: Text(
                                                    'Breakfast',
                                                    textScaleFactor: 1,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: selectedItemType ==
                                                              "Breakfast"
                                                          ? Colors.blue
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedItemType = "Lunch";
                                              });
                                              print(selectedItemType);
                                              prGetItems.show();
                                              getItemListAccordingToBLSD(
                                                  context);
                                            },
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade200,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                'Lunch',
                                                textScaleFactor: 1,
                                                style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: selectedItemType ==
                                                          "Lunch"
                                                      ? Colors.blue
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedItemType = "Snacks";
                                              });
                                              print(selectedItemType);
                                              prGetItems.show();
                                              getItemListAccordingToBLSD(
                                                  context);
                                            },
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade200,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                'Snacks',
                                                textScaleFactor: 1,
                                                style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: selectedItemType ==
                                                          "Snacks"
                                                      ? Colors.blue
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedItemType = "Dinner";
                                              });
                                              print(selectedItemType);
                                              prGetItems.show();
                                              getItemListAccordingToBLSD(
                                                  context);
                                            },
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade200,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                'Dinner',
                                                textScaleFactor: 1,
                                                style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: selectedItemType ==
                                                          "Dinner"
                                                      ? Colors.blue
                                                      : Colors.black,
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
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade200,
                                        highlightColor: Colors.white,
                                        child: Text(
                                          "Non-veg",
                                          textScaleFactor: 1,
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 16,
                                              color: Colors.red[700],
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        child: Transform.scale(
                                            scale: 1,
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade200,
                                              highlightColor: Colors.white,
                                              child: Switch(
                                                onChanged: toggleSwitch,
                                                value: switchControl,
                                                activeColor: Color(0xffb9ce82),
                                                activeTrackColor:
                                                    Colors.grey.shade300,
                                                //.shade300,
                                                inactiveThumbColor:
                                                    Colors.red[900],
                                                inactiveTrackColor:
                                                    Colors.grey.shade300,
                                              ),
                                            )),
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade200,
                                        highlightColor: Colors.white,
                                        child: Text(
                                          "Veg",
                                          textScaleFactor: 1,
                                          style: GoogleFonts.nunitoSans(
                                              fontSize: 16,
                                              color: Colors.green[700],
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade200,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                7,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.white,
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      child: Text(
                                        "Fetching location",
                                        textScaleFactor: 1,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunitoSans(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        home.heartIcon = 1;
                                      });
                                    },
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade200,
                                      highlightColor: Colors.white,
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : permission == false
                  ? Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Text(
                            "Location permission was denied! Please go into settings and enable location for Ziffy as this app needs location to fetch nearby food items.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: refreshList,
                      key: refreshKey,
                      child: SingleChildScrollView(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 70,
                                ),
                                buildMealsCarouselSlider(context),
                                SizedBox(
                                  height: 0,
                                ),
                                buildTabBar(context),
                                SizedBox(
                                  height: 0,
                                ),
                                buildFilterBox(context),
                                buildHomeItems(context),
                              ],
                            ),
                            buildLocationContainer(context)
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return AppBar(
      leading: Image.asset("assets/images/zifffyuserlogo.png"),
      backgroundColor: Colors.white,
      title: appBarTitle,
      centerTitle: false,
      elevation: 1,
      actions: [
        new IconButton(
          icon: actionIcon,
          color: Colors.black,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(
                  Icons.close,
                  color: Colors.black,
                );
                this.appBarTitle = SearchableDropdown.single(
                    items: home.itemNameTwo == null
                        ? []
                        : home.itemNameTwo.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value.toString(),
                                textScaleFactor: 1,
                              ),
                              /*
                     Padding(
                       padding: const EdgeInsets.only(top: 15),
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             selectedItemId = home.itemId2[int.parse(selectedItemIdForSearch)].toString();
                           });
                           print(selectedItemId);
                           //addToCart(context);
                           //getItemAdons(context);
                           //slideSheetAddOns();
                         },
                         child: Container(
                             padding: EdgeInsets.only(left: 10, right: 10),
                             width: MediaQuery.of(context).size.width,
                             height: 120,
                             decoration: BoxDecoration(
                               color: Colors.white,
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Container(
                                   width: MediaQuery.of(context).size.width/2.5,
                                   height: MediaQuery.of(context).size.height/7,
                                   decoration: BoxDecoration(
                                     borderRadius:
                                     BorderRadius.all(Radius.circular(15)),
                                   ),
                                   child: Image.network(domainUrl+home.image2[int.parse(selectedItemIdForSearch)].toString(),
                                     fit: BoxFit.fill,
                                   ),
                                 ),
                                 SizedBox(width: 10,),
                                 Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.only(right: 0, top: 0),
                                         child: Container(
                                           width: 150,
                                           child: Text(
                                             home.itemNameTwo[int.parse(selectedItemIdForSearch)],
                                             maxLines: 2,
                                             style: GoogleFonts.nunitoSans(
                                                 color: Colors.black,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 14),
                                           ),
                                         ),
                                       ),
                                       SizedBox(height: 0,),
                                       Container(
                                         width: 150,
                                         child: Text(
                                           home.itemDescription2[int.parse(selectedItemIdForSearch)],
                                           maxLines: 2,
                                           style: GoogleFonts.nunitoSans(
                                             color: Colors.grey,
                                             fontSize: 12.5,),
                                         ),
                                       ),
                                       SizedBox(height: 3,),
                                       Padding(
                                         padding: const EdgeInsets.only(right: 39),
                                         child: Text(
                                           home.vendorName2[int.parse(selectedItemIdForSearch)],
                                           style: GoogleFonts.nunitoSans(
                                               color: Colors.orange[800],
                                               fontWeight: FontWeight.bold,
                                               fontSize: 12),
                                         ),
                                       ),
                                       Spacer(),
                                       Padding(
                                         padding: const EdgeInsets.only(bottom: 5),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.end,
                                           children: [
                                             counters2[selectedItemIdForSearch] > 0 ? Row(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               crossAxisAlignment: CrossAxisAlignment.center,
                                               children: [
                                                 InkWell(
                                                     onTap: (){
                                                       if(counters2[int.parse(selectedItemIdForSearch)] > 0){
                                                         setState(() {
                                                           counters2[int.parse(selectedItemIdForSearch)]--;
                                                         });
                                                         print(counters2[int.parse(selectedItemIdForSearch)]);
                                                         setState(() {
                                                           selectedItemId = home.itemId2[int.parse(selectedItemIdForSearch)].toString();
                                                         });
                                                         print(selectedItemId);
                                                         prAddToCart.show();
                                                         removeFromCart(context);
                                                       }else{

                                                       }
                                                     },
                                                     child: Padding(
                                                       padding: const EdgeInsets.only(right: 5),
                                                       child: Icon(Icons.remove, color: Colors.grey, size: 20,),
                                                     )),
                                                 Container(
                                                   decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.all(Radius.circular(5)),
                                                       border: Border.all(color: Colors.grey)
                                                   ),
                                                   child: Center(
                                                     child: Padding(
                                                       padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                       child: Text(counters2[int.parse(selectedItemIdForSearch)].toString(),
                                                         style: GoogleFonts.nunitoSans(
                                                           color: Colors.black,
                                                           fontSize: 12,
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                                 InkWell(
                                                     onTap: (){
                                                       setState(() {
                                                         counters2[int.parse(selectedItemIdForSearch)]++;
                                                       });
                                                       print(counters2[int.parse(selectedItemIdForSearch)]);
                                                       setState(() {
                                                         selectedItemId = home.itemId2[int.parse(selectedItemIdForSearch)].toString();
                                                       });
                                                       print(selectedItemId);
                                                       prAddToCart.show();
                                                       getItemAdons(context);
                                                       addToCart(context).whenComplete((){
                                                         Future.delayed(Duration(seconds: 3), () async {
                                                           if(home.adonName == null){
                                                             prAddToCart.hide();
                                                           }else{
                                                             prAddToCart.hide();
                                                             Navigator.push(
                                                                 context,
                                                                 PageRouteBuilder(
                                                                   pageBuilder: (c, a1, a2) => ChooseAdOns(selectedItemId, tempCartId, home.itemPrice2[int.parse(selectedItemIdForSearch)]),
                                                                   transitionsBuilder: (c, anim, a2, child) =>
                                                                       FadeTransition(opacity: anim, child: child),
                                                                   transitionDuration: Duration(milliseconds: 300),
                                                                 )
                                                             );
                                                           }
                                                         });
                                                       });
                                                     },
                                                     child: Padding(
                                                       padding: const EdgeInsets.only(right: 5),
                                                       child: Icon(Icons.add, color: Colors.grey, size: 20,),
                                                     )),
                                               ],
                                             ) : InkWell(
                                               onTap: (){
                                                 setState(() {
                                                   selectedItemId = home.itemId2[int.parse(selectedItemIdForSearch)].toString();
                                                   counters2[int.parse(selectedItemIdForSearch)]++;
                                                 });
                                                 print(selectedItemId);
                                                 print(counters2[int.parse(selectedItemIdForSearch)]);
                                                 prAddToCart.show();
                                                 getItemAdons(context);
                                                 addToCart(context).whenComplete((){
                                                   Future.delayed(Duration(seconds: 3), () async {
                                                     if(home.adonName == null){
                                                       prAddToCart.hide();
                                                     }else{
                                                       prAddToCart.hide();
                                                       Navigator.push(
                                                           context,
                                                           PageRouteBuilder(
                                                             pageBuilder: (c, a1, a2) => ChooseAdOns(selectedItemId, tempCartId, home.itemPrice2[int.parse(selectedItemIdForSearch)]),
                                                             transitionsBuilder: (c, anim, a2, child) =>
                                                                 FadeTransition(opacity: anim, child: child),
                                                             transitionDuration: Duration(milliseconds: 300),
                                                           )
                                                       );
                                                     }
                                                   });
                                                 });
                                                 /*
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
                                                              height: MediaQuery.of(context).size.height,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(15),
                                                                    topRight: Radius.circular(15)),
                                                                color: Colors.white,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Text(
                                                                    'Add-Ons ?',
                                                                    style: GoogleFonts.nunitoSans(
                                                                        fontWeight: FontWeight.bold, fontSize: 20),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  ListView.builder(
                                                                    shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    padding: EdgeInsets.all(0.0),
                                                                    scrollDirection: Axis.vertical,
                                                                    itemCount: home.adonName == null ? 0 : home.adonName.length,
                                                                    itemBuilder: (context, index) => Padding(
                                                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(home.adonName[index] == null || home.adonName[index] == "null" ? "loading" : home.adonName[index] + " (Rs " + home.adonPrice[index] + ")"),
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 18,
                                                                                height:
                                                                                MediaQuery.of(context).size.height / 40,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(
                                                                                        bottomLeft: Radius.circular(50),
                                                                                        topLeft: Radius.circular(50)),
                                                                                    color: Colors.deepPurple[700]),
                                                                                child: GestureDetector(
                                                                                    onTap: () {
                                                                                      if(counter>0){
                                                                                        setState(() {
                                                                                          counter--;
                                                                                        });
                                                                                      }
                                                                                      else{

                                                                                      }
                                                                                    },
                                                                                    child: Icon(
                                                                                      Icons.remove,
                                                                                      color: Colors.white,
                                                                                      size: 16,
                                                                                    )),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 18,
                                                                                height:
                                                                                MediaQuery.of(context).size.height / 40,
                                                                                color: Colors.white,
                                                                                child:
                                                                                Center(child: Text(counter.toString())),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 18,
                                                                                height:
                                                                                MediaQuery.of(context).size.height / 40,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(
                                                                                        bottomRight: Radius.circular(50),
                                                                                        topRight: Radius.circular(50)),
                                                                                    color: Colors.deepPurple[700]),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      counter++;
                                                                                    });
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.add,
                                                                                    color: Colors.white,
                                                                                    size: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10),
                                                                    child: Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Text(
                                                                        'Special instructions',
                                                                        style: GoogleFonts.nunitoSans(
                                                                            fontWeight: FontWeight.bold, fontSize: 14),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width / 1.06,
                                                                          height: MediaQuery.of(context).size.height / 9,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.grey),
                                                                              borderRadius:
                                                                              BorderRadius.all(Radius.circular(5))),
                                                                          child: TextField(
                                                                            decoration: InputDecoration(
                                                                              contentPadding:
                                                                              EdgeInsets.only(left: 10, top: 5),
                                                                              border: InputBorder.none,
                                                                            ),
                                                                            maxLines: 5,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Total Price : ',
                                                                          style: GoogleFonts.nunitoSans(
                                                                              fontWeight: FontWeight.w600, fontSize: 18),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 3),
                                                                          child: Container(
                                                                            width: 60,
                                                                            height: 30,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius:
                                                                              BorderRadius.all(Radius.circular(5)),
                                                                              //border: Border.all(color: Colors.black)
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                'Rs 225',
                                                                                style: GoogleFonts.nunitoSans(
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: (){
                                                                            Navigator.of(context).pop();
                                                                            //addAddOnsToCart(context);
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width / 2.3,
                                                                            height: MediaQuery.of(context).size.height / 20,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius.all(Radius.circular(7)),
                                                                                color: Colors.grey[300]),
                                                                            child: Center(
                                                                              child: Text(
                                                                                'Cancel',
                                                                                style: GoogleFonts.nunitoSans(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18,
                                                                                    color: Colors.black),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap: (){
                                                                            Navigator.push(
                                                                                context,
                                                                                PageRouteBuilder(
                                                                                  pageBuilder: (c, a1, a2) =>CartPage(),
                                                                                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                                                  transitionDuration: Duration(milliseconds: 300),
                                                                                )
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width / 2.3,
                                                                            height: MediaQuery.of(context).size.height / 20,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius.all(Radius.circular(7)),
                                                                                color: Colors.blue[700]),
                                                                            child: Center(
                                                                              child: Text(
                                                                                'Proceed',
                                                                                style: GoogleFonts.nunitoSans(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18,
                                                                                    color: Colors.white),
                                                                              ),
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
                                                        ) ;

                                                      });
                                                }).whenComplete((){
                                              getItemAdons(context).whenComplete((){
                                                Future.delayed(Duration(seconds: 3), () async {
                                                  print("setting state");
                                                  setState(() {

                                                  });
                                                });
                                              });
                                            });

                                             */
                                               },
                                               child: Container(
                                                 height: 30,
                                                 width: 60,
                                                 decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.all(Radius.circular(5)),
                                                     border: Border.all(color: Colors.grey)
                                                 ),
                                                 child: Center(
                                                   child: Text("Add +",
                                                     style: GoogleFonts.nunitoSans(
                                                       color: Colors.black,
                                                       fontSize: 10,
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             SizedBox(width: 10,),
                                             Text(
                                               globals.currencySymbl+home.itemPrice2[int.parse(selectedItemIdForSearch)],
                                               style: GoogleFonts.nunitoSans(
                                                   color: Colors.black,
                                                   fontSize: 16,
                                                   fontWeight: FontWeight.bold),
                                             ),
                                           ],
                                         ),
                                       ),
                                       /*
                                  GestureDetector(
                                    onTap: () {
                                      homePageApiProvider.getItemAdons(context);
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                Colors.black.withOpacity(0.5),
                                                blurRadius: 5)
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.green[500]),
                                      child: Center(
                                        child: Text(
                                          'Add',
                                          style: GoogleFonts.nunitoSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),

                                   */
                                     ]),
                               ],
                             )),
                       ),
                     )

                      */
                            );
                          }).toList(),
                    value: "Search by item name...",
                    hint: "Search dishes",
                    searchHint: "Search dishes",
                    clearIcon: Icon(null),
//                  onClear: (){
//                    setState(() {
//                      selectedCategory = null;
//                    });
//                  },
                    onChanged: (value) {
                      setState(() {
                        int idx = home.itemNameTwo.indexOf(value);
                        print("idx:" + idx.toString());
                        selectedItemIdForSearch = idx.toString();
                        showSearchedItem = true;
                      });
                      print(selectedItemIdForSearch);
                    },
                    isExpanded: true);
              } else {
                setState(() {
                  showSearchedItem = false;
                });
                this.actionIcon = new Icon(
                  Icons.search,
                  color: Colors.black,
                );
                this.appBarTitle = new Text(
                  "Zifffy",
                  textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                    color: Colors.black,
                  ),
                );
              }
            });
          },
        ),
      ],
    );
  }

  buildLocationContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => PlacePicker(
//              apiKey: "AIzaSyB2TWHONvLIUNBz29hs82Ff7ZBWYa3Zy3Y",   // Put YOUR OWN KEY here.
//              onPlacePicked: (result) {
//                print(result.address);
//                Navigator.of(context).pop();
//              },
//              initialPosition: HomePage.kInitialPosition,
//              useCurrentLocation: true,
//            ),
//          ),
//        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlacePicker(
                apiKey: "AIzaSyAaHgfDzwtlUYxsaBZfqNCTbROLVhhw_N4",
                initialPosition: kInitialPosition,
                useCurrentLocation: true,
                selectInitialPosition: true,
                usePlaceDetailSearch: true,
//                onPlacePicked: (result) {
//                  selectedPlace = result;
//                  print(selectedPlace);
//                  Navigator.of(context).pop();
//                  setState(() {});
//                },
                onPlacePicked: (result) {
                  print(result.formattedAddress);
                  print(result.geometry.toJson());
                  setState(() {
                    tempAddress = result.formattedAddress;
                    lat =
                        result.geometry.toJson()['location']['lat'].toString();
                    long =
                        result.geometry.toJson()['location']['lng'].toString();
                  });
                  print(lat);
                  print(long);
                  Navigator.of(context).pop();
                },
                //forceSearchOnZoomChanged: true,
                //automaticallyImplyAppBarLeading: false,
                //autocompleteLanguage: "ko",
                //region: 'au',
                //selectInitialPosition: true,
                /*
                selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                  print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                  return isSearchBarFocused
                      ? Container()
                      : FloatingCard(
                    bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                    leftPosition: 0.0,
                    rightPosition: 0.0,
                    width: 500,
                    borderRadius: BorderRadius.circular(12.0),
                    child: state == SearchingState.Searching
                        ? Center(child: CircularProgressIndicator())
                        : RaisedButton(
                      child: Text("Pick Here"),
                      onPressed: () {
                        // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                        //            this will override default 'Select here' Button.
//                        print(selectedPlace.addressComponents);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },

                 */
                // pinBuilder: (context, state) {
                //   if (state == PinState.Idle) {
                //     return Icon(Icons.favorite_border);
                //   } else {
                //     return Icon(Icons.favorite);
                //   }
                // },
              );
            },
          ),
        ).whenComplete(() {
          getItemListAccToLatLong(context);
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Text(
                  tempAddress == null || tempAddress == "null"
                      ? "Fetching location..."
                      : tempAddress,
                  textScaleFactor: 1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Spacer(),
              addressIdsList == null || addressIdsList == "null"
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          home.heartIcon = 1;
                        });
                      },
                      child: home.heartIcon == 1
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  home.heartIcon = 0;
                                });
                              },
                              child: Icon(
                                Icons.favorite_outline,
                                color: Colors.red,
                              ),
                            ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMealsCarouselSlider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var cdx = prefs.getString('cdx');
                var iid = prefs.getString('iid');
                print("cdx" + cdx);
                print("iid" + iid);
              },
              child: Text(
                "Quality meals with exciting offers and promos",
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CarouselSlider.builder(
            itemCount: bannerImages == null ? 0 : bannerImages.length,
            options: CarouselOptions(
                height: 200,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: bannerImages.length == 1 || bannerImages.length < 1
                    ? false
                    : true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    //currentS = index;
                  });
                }),
            itemBuilder: (BuildContext context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: GestureDetector(
                  onTap: () {
                    //launch(home.sponsoredAdUrl[index]);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        image: DecorationImage(
                          image: NetworkImage(bannerImages[index]),
                          //home.sponsoredAdImages[index]),
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ),
            ),
          ),
          /*
          Container(
              width: MediaQuery.of(context).size.width,
              height: 165,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    height: 150,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage("https://images.pexels.com/photos/2474661/pexels-photo-2474661.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                              fit: BoxFit.fill,
                            )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7, top: 5),
                          child: Text("Paneer kadhai meal",
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7, top: 0),
                          child: Text("Paneer kadai, 2 roti, 1 steam rice, 1 jamun",
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: Container(
                            height: 25,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.grey)
                            ),
                            child: Center(
                              child: Text("Add +",
                                textScaleFactor: 1,
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    height: 150,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: NetworkImage("https://i.pinimg.com/originals/f1/5c/da/f15cda34750f8b13cbe072096843422b.jpg"),
                                fit: BoxFit.fill,
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7, top: 5),
                          child: Text("South Indian meal",
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7, top: 0),
                          child: Text("1 dosa, 3 idli, 1 sambar, 1 chutney, 2 medu wada",
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: Container(
                            height: 25,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.grey)
                            ),
                            child: Center(
                              child: Text("Add +",
                                textScaleFactor: 1,
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    height: 150,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: NetworkImage("https://cdn.guidingtech.com/imager/assets/189869/HD-Mouth-Watering-Food-Wallpapers-for-Desktop-12_4d470f76dc99e18ad75087b1b8410ea9.jpg?1573743472"),
                                fit: BoxFit.fill,
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7, top: 5),
                          child: Text("Pizza Lunch Box",
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7, top: 0),
                          child: Text("1 pan crust veg pizza, 1 garlic bread sticks with cheese",
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: Container(
                            height: 25,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.grey)
                            ),
                            child: Center(
                              child: Text("Add +",
                                textScaleFactor: 1,
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20,),
                ],
              )),

           */
        ],
      ),
      /*
          CarouselSlider.builder(
              itemCount: 3,
              options: CarouselOptions(
                  height: 150,
                  viewportFraction: 0.6,
                  initialPage: 0,
                  aspectRatio: 16 / 9,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {});
                  }),
              itemBuilder: (BuildContext context, index) => Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Image.asset(
                      home.foodItems[index],
                      fit: BoxFit.fitWidth,
                    ),
                  ))),

           */
    );
  }

  Widget buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: Text(
              "Browse through meal timings",
              textScaleFactor: 1,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          SizedBox(
            height: 2,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DefaultTabController(
              length: 5,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: null,
                indicatorColor: Colors.white,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                tabs: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedItemType = null;
                      });
                      print(selectedItemType);
                      prGetItems.show();
                      getItemListAccToLatLong(context);
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            'All',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: selectedItemType == null
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            '6:30am to\n12:30am',
                            textAlign: TextAlign.center,
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                              color: selectedItemType == null
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedItemType = "Breakfast";
                      });
                      print(selectedItemType);
                      prGetItems.show();
                      getItemListAccordingToBLSD(context);
                    },
                    child: Tab(
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              'Breakfast',
                              textScaleFactor: 1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: selectedItemType == "Breakfast"
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              '6:30am to\n11am',
                              textAlign: TextAlign.center,
                              textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                                color: selectedItemType == null
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedItemType = "Lunch";
                      });
                      print(selectedItemType);
                      prGetItems.show();
                      getItemListAccordingToBLSD(context);
                    },
                    child: Tab(
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              'Lunch',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: selectedItemType == "Lunch"
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              '12pm to\n2:30pm',
                              textAlign: TextAlign.center,
                              textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                                color: selectedItemType == null
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedItemType = "Snacks";
                      });
                      print(selectedItemType);
                      prGetItems.show();
                      getItemListAccordingToBLSD(context);
                    },
                    child: Tab(
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              'Snacks',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: selectedItemType == "Snacks"
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              '4pm to\n7:30pm',
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                                color: selectedItemType == null
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedItemType = "Dinner";
                      });
                      print(selectedItemType);
                      prGetItems.show();
                      getItemListAccordingToBLSD(context);
                    },
                    child: Tab(
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              'Dinner',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: selectedItemType == "Dinner"
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              '7pm to \n12:30am',
                              textAlign: TextAlign.center,
                              textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                                color: selectedItemType == null
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
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
    );
  }

  Widget buildFilterBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Non-veg",
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    color: Colors.red[700],
                    fontWeight: FontWeight.w600),
              ),
              Container(
                child: Transform.scale(
                    scale: 1,
                    child: Switch(
                      onChanged: toggleSwitch,
                      value: switchControl,
                      activeColor: Color(0xffb9ce82),
                      activeTrackColor: Colors.grey.shade300,
                      //.shade300,
                      inactiveThumbColor: Colors.red[900],
                      inactiveTrackColor: Colors.grey.shade300,
                    )),
              ),
              Text(
                "Veg",
                textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          GestureDetector(
              onTap: () {
                slideSheet();
              },
              child: Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 7,
                      height: MediaQuery.of(context).size.height / 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 1)
                          ]),
                      child: Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.black,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 17, top: 3),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 50,
                      height: MediaQuery.of(context).size.height / 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.red),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget buildHomeItems(BuildContext context) {
    return showSearchedItem == false
        ? home.itemId == null
            ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    "We are not there yet, but we are expanding. Keep and eye.",
                    textScaleFactor: 1,
                    style: GoogleFonts.nunitoSans(
                      letterSpacing: 0.5,
                    ),
                  ),
                ))
            : showLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0.0),
                    scrollDirection: Axis.vertical,
                    itemCount: home.itemId == null ? 0 : home.itemId.length,
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedItemId = home.itemId[index].toString();
                              });
                              print(selectedItemId);
                              //addToCart(context);
                              //getItemAdons(context);
                              //slideSheetAddOns();
                            },
                            child: Container(
                                padding: EdgeInsets.only(left: 5, right: 2),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width / 3,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      /* child: Image.network(domainUrl+home.image[index].toString(),
                                fit: BoxFit.fill,
                              ),*/
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: domainUrl +
                                            home.image[index].toString(),
                                        placeholder: (context, url) => Center(
                                          child: new CircularProgressIndicator(
                                            strokeWidth: 1,
                                            backgroundColor: Colors.grey,
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.black,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 0, top: 0),
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                EdgeInsets.all(1.0),
                                                child: Text(
                                                  home.itemName[index],
                                                  textAlign:
                                                  TextAlign.start,
                                                  textScaleFactor: 1,
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: GoogleFonts
                                                      .nunitoSans(
                                                      color: Colors
                                                          .black,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 39),
                                            child: Text(
                                              home.vendorName[index],
                                              textScaleFactor: 1,
                                              style: GoogleFonts.nunitoSans(
                                                  color: Colors.orange[800],
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 39),
                                            child: Text(
                                              "Available Until : " +
                                                  DateFormat.jm()
                                                      .format(DateTime.parse(
                                                      "2021-01-01T" +
                                                          home.itemErt[
                                                          index]))
                                                      .toString(),
                                              textScaleFactor: 1,
                                              style: GoogleFonts.nunitoSans(
                                                  color: Colors.blue,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                counters[index] > 0
                                                    ? Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          if (counters[
                                                          index] >
                                                              0) {
                                                            widget.updateCartMinus(int.parse(cart
                                                                .totalItems
                                                                .toString()));
                                                            setState(
                                                                    () {
                                                                  selectedItemId = home
                                                                      .itemId[index]
                                                                      .toString();
                                                                });
                                                            print(
                                                                selectedItemId);
                                                            setState(
                                                                    () {
                                                                  counters[
                                                                  index]--;
                                                                });
                                                            print(counters[
                                                            index]);
                                                            prAddToCart
                                                                .show();
                                                            removeFromCart(
                                                                context)
                                                                .whenComplete(
                                                                    () {
                                                                  setState(
                                                                          () {});
                                                                });
                                                          } else {}
                                                        },
                                                        child:
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              right:
                                                              5),
                                                          child: Icon(
                                                            Icons
                                                                .remove,
                                                            color: Colors
                                                                .grey,
                                                            size: 30,
                                                          ),
                                                        )),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.all(Radius.circular(
                                                              5)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .grey)),
                                                      child: Center(
                                                        child:
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              left:
                                                              10,
                                                              right:
                                                              10,
                                                              top: 5,
                                                              bottom:
                                                              5),
                                                          child: Text(
                                                            counters[
                                                            index]
                                                                .toString(),
                                                            textScaleFactor:
                                                            1,
                                                            style: GoogleFonts
                                                                .nunitoSans(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          setState(
                                                                  () {
                                                                widget.updateCart(cart.totalItems == null ||
                                                                    cart.totalItems ==
                                                                        "null"
                                                                    ? 0
                                                                    : int.parse(cart
                                                                    .totalItems
                                                                    .toString()));
                                                                counters[
                                                                index]++;
                                                              });
                                                          print(cart
                                                              .totalItems);
                                                          print(counters[
                                                          index]);
                                                          setState(
                                                                  () {
                                                                selectedItemId = home
                                                                    .itemId[
                                                                index]
                                                                    .toString();
                                                              });
                                                          print(
                                                              selectedItemId);
                                                          //prAddToCart.show();
                                                          getItemAdons(
                                                              context);
                                                          addToCart(
                                                              context)
                                                              .whenComplete(
                                                                  () {
                                                                Navigator.push(
                                                                    context,
                                                                    PageRouteBuilder(
                                                                      pageBuilder: (c, a1, a2) => AddToCartPage(
                                                                          selectedItemId,
                                                                          tempCartId,
                                                                          home.itemPrice[index],
                                                                          home.itemName[index],
                                                                          home.itemDescription[index],
                                                                          home.itemPrice[index],
                                                                          home.vendorName[index]),
                                                                      transitionsBuilder: (c, anim, a2, child) =>
                                                                          FadeTransition(opacity: anim, child: child),
                                                                      transitionDuration:
                                                                      Duration(milliseconds: 300),
                                                                    )).whenComplete(() {
                                                                  getCartItems(context)
                                                                      .whenComplete(() {
                                                                    Future.delayed(
                                                                        Duration(seconds: 2),
                                                                            () async {
                                                                          setState(() {});
                                                                        });
                                                                  });
                                                                });
                                                              });
                                                        },
                                                        child:
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              right:
                                                              5),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors
                                                                .grey,
                                                            size: 30,
                                                          ),
                                                        )),
                                                  ],
                                                )
                                                    : InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      widget
                                                          .updateCart(
                                                          0);
                                                      selectedItemId = home
                                                          .itemId[
                                                      index]
                                                          .toString();
                                                      counters[
                                                      index]++;
                                                    });

                                                    SharedPreferences
                                                    prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                    prefs.setString(
                                                        'cdx',
                                                        counters[
                                                        index]
                                                            .toString());
                                                    prefs.setString(
                                                        'iid',
                                                        home.itemId[
                                                        index]
                                                            .toString());

                                                    print(cart
                                                        .totalItems);
                                                    print(
                                                        selectedItemId);
                                                    print(counters[
                                                    index]);
                                                    //prAddToCart.show();
                                                    getItemAdons(
                                                        context);
                                                    addToCart(context)
                                                        .whenComplete(
                                                            () {
                                                          Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (c, a1, a2) => AddToCartPage(
                                                                    selectedItemId,
                                                                    tempCartId,
                                                                    home.itemPrice[index],
                                                                    home.itemName[index],
                                                                    home.itemDescription[index],
                                                                    home.itemPrice[index],
                                                                    home.vendorName[index]),
                                                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(
                                                                    opacity: anim,
                                                                    child: child),
                                                                transitionDuration:
                                                                Duration(milliseconds: 300),
                                                              ))
                                                              .whenComplete(
                                                                  () {
                                                                //Fluttertoast.showToast(msg: 'Fetching...');
                                                                getCartItems(
                                                                    context)
                                                                    .whenComplete(
                                                                        () {
                                                                      Future.delayed(
                                                                          Duration(
                                                                              seconds:
                                                                              2),
                                                                              () async {
                                                                            setState(
                                                                                    () {});
                                                                          });
                                                                    });
                                                              });
                                                        });
                                                  },
                                                  child: Container(
                                                    height: 32,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5)),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey)),
                                                    child: Center(
                                                      child: Text(
                                                        "Add",
                                                        textScaleFactor:
                                                        1,
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                          color: Colors
                                                              .white,
                                                          fontSize:
                                                          17,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  currencySymbl +
                                                      home.itemPrice[index],
                                                  textScaleFactor: 1,
                                                  style: GoogleFonts
                                                      .nunitoSans(
                                                      color:
                                                      Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),),
                                  ],
                                ),),
                          ),
                        ))
        : Padding(
            padding: const EdgeInsets.only(top: 15),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedItemId = home
                      .itemId2[int.parse(selectedItemIdForSearch)]
                      .toString();
                });
                print(selectedItemId);
                //addToCart(context);
                //getItemAdons(context);
                //slideSheetAddOns();
              },
              child: Container(
                  padding: EdgeInsets.only(left: 5, right: 2),
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        /* child: Image.network(
                          domainUrl +
                              home.image2[int.parse(selectedItemIdForSearch)]
                                  .toString(),
                          fit: BoxFit.fill,
                        ),*/
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: domainUrl +
                              home.image2[int.parse(selectedItemIdForSearch)]
                                  .toString(),
                          placeholder: (context, url) => Center(
                            child: new CircularProgressIndicator(
                              strokeWidth: 1,
                              backgroundColor: Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 0, top: 0),
                                child: Container(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.all(1.0),
                                    child: Text(
                                      home.itemNameTwo[
                                      int.parse(selectedItemIdForSearch)],
                                      textAlign:
                                      TextAlign.start,
                                      textScaleFactor: 1,
                                      maxLines: 2,
                                      overflow: TextOverflow
                                          .ellipsis,
                                      style: GoogleFonts
                                          .nunitoSans(
                                          color: Colors
                                              .black,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 39),
                                child: Text(
                                  home.vendorName2[
                                  int.parse(selectedItemIdForSearch)],
                                  textScaleFactor: 1,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.orange[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 39),
                                child: Text(
                                  "Available Until : " +
                                      DateFormat.jm().format(DateTime.parse(
                                          "2021-01-01T" +
                                              home.itemErt2[int.parse(
                                                  selectedItemIdForSearch)]
                                                  .toString())),
                                  textScaleFactor: 1,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    counters2[int.parse(
                                        selectedItemIdForSearch)] >
                                        0
                                        ? Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              if (counters2[int.parse(
                                                  selectedItemIdForSearch)] >
                                                  0) {
                                                widget.updateCartMinus(
                                                    int.parse(cart
                                                        .totalItems
                                                        .toString()));
                                                setState(() {
                                                  selectedItemId = home
                                                      .itemId2[int.parse(
                                                      selectedItemIdForSearch)]
                                                      .toString();
                                                });
                                                print(selectedItemId);
                                                setState(() {
                                                  counters2[int.parse(
                                                      selectedItemIdForSearch)]--;
                                                });
                                                print(counters2[int.parse(
                                                    selectedItemIdForSearch)]);
                                                prAddToCart.show();
                                                removeFromCart(context);
                                              } else {}
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  right: 5),
                                              child: Icon(
                                                Icons.remove,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            )),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                counters2[int.parse(
                                                    selectedItemIdForSearch)]
                                                    .toString(),
                                                textScaleFactor: 1,
                                                style:
                                                GoogleFonts.nunitoSans(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                widget.updateCart(
                                                    cart.totalItems ==
                                                        null ||
                                                        cart.totalItems ==
                                                            "null"
                                                        ? 0
                                                        : int.parse(cart
                                                        .totalItems
                                                        .toString()));
                                                selectedItemId = home
                                                    .itemId2[int.parse(
                                                    selectedItemIdForSearch)]
                                                    .toString();
                                              });
                                              print("cartItems::::::" +
                                                  cart.totalItems);
                                              print(selectedItemId);
                                              setState(() {
                                                counters2[int.parse(
                                                    selectedItemIdForSearch)]++;
                                              });
                                              print(counters2[int.parse(
                                                  selectedItemIdForSearch)]);
                                              prAddToCart.show();
                                              //addToCart(context).whenComplete((){
                                              addToCart(context)
                                                  .whenComplete(() {
                                                Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (c, a1,
                                                          a2) =>
                                                          ChooseAdOns(
                                                              selectedItemId,
                                                              tempCartId,
                                                              home.itemPrice2[
                                                              int.parse(
                                                                  selectedItemIdForSearch)]),
                                                      transitionsBuilder: (c,
                                                          anim,
                                                          a2,
                                                          child) =>
                                                          FadeTransition(
                                                              opacity: anim,
                                                              child: child),
                                                      transitionDuration:
                                                      Duration(
                                                          milliseconds:
                                                          300),
                                                    )).whenComplete(() {
                                                  getCartItems(context)
                                                      .whenComplete(() {
                                                    Future.delayed(
                                                        Duration(
                                                            seconds: 5),
                                                            () async {
                                                          setState(() {});
                                                        });
                                                  });
                                                });
                                              });
                                              //});
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  right: 5),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            )),
                                      ],
                                    )
                                        : InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.updateCart(cart
                                              .totalItems ==
                                              null ||
                                              cart.totalItems == "null"
                                              ? 0
                                              : int.parse(cart.totalItems
                                              .toString()));
                                          selectedItemId = home
                                              .itemId2[int.parse(
                                              selectedItemIdForSearch)]
                                              .toString();
                                          counters2[int.parse(
                                              selectedItemIdForSearch)]++;
                                        });
                                        //print("cartItems::::::"+cart.totalItems);
                                        print(selectedItemId);
                                        print(counters2[int.parse(
                                            selectedItemIdForSearch)]);
                                        prAddToCart.show();
                                        addToCart(context).whenComplete(() {
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (c, a1, a2) =>
                                                    ChooseAdOns(
                                                        selectedItemId,
                                                        tempCartId,
                                                        home.itemPrice2[
                                                        int.parse(
                                                            selectedItemIdForSearch)]),
                                                transitionsBuilder:
                                                    (c, anim, a2, child) =>
                                                    FadeTransition(
                                                        opacity: anim,
                                                        child: child),
                                                transitionDuration:
                                                Duration(
                                                    milliseconds: 300),
                                              )).whenComplete(() {
                                            getWallet(context)
                                                .whenComplete(() {
                                              Future.delayed(
                                                  Duration(seconds: 5),
                                                      () async {
                                                    setState(() {});
                                                  });
                                            });
                                          });
                                        });
                                        /*
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
                                                              height: MediaQuery.of(context).size.height,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(15),
                                                                    topRight: Radius.circular(15)),
                                                                color: Colors.white,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  Text(
                                                                    'Add-Ons ?',
                                                                    style: GoogleFonts.nunitoSans(
                                                                        fontWeight: FontWeight.bold, fontSize: 20),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  ListView.builder(
                                                                    shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    padding: EdgeInsets.all(0.0),
                                                                    scrollDirection: Axis.vertical,
                                                                    itemCount: home.adonName == null ? 0 : home.adonName.length,
                                                                    itemBuilder: (context, index) => Padding(
                                                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(home.adonName[index] == null || home.adonName[index] == "null" ? "loading" : home.adonName[index] + " (Rs " + home.adonPrice[index] + ")"),
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 18,
                                                                                height:
                                                                                MediaQuery.of(context).size.height / 40,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(
                                                                                        bottomLeft: Radius.circular(50),
                                                                                        topLeft: Radius.circular(50)),
                                                                                    color: Colors.deepPurple[700]),
                                                                                child: GestureDetector(
                                                                                    onTap: () {
                                                                                      if(counter>0){
                                                                                        setState(() {
                                                                                          counter--;
                                                                                        });
                                                                                      }
                                                                                      else{

                                                                                      }
                                                                                    },
                                                                                    child: Icon(
                                                                                      Icons.remove,
                                                                                      color: Colors.white,
                                                                                      size: 16,
                                                                                    )),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 18,
                                                                                height:
                                                                                MediaQuery.of(context).size.height / 40,
                                                                                color: Colors.white,
                                                                                child:
                                                                                Center(child: Text(counter.toString())),
                                                                              ),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 18,
                                                                                height:
                                                                                MediaQuery.of(context).size.height / 40,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(
                                                                                        bottomRight: Radius.circular(50),
                                                                                        topRight: Radius.circular(50)),
                                                                                    color: Colors.deepPurple[700]),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      counter++;
                                                                                    });
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.add,
                                                                                    color: Colors.white,
                                                                                    size: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10),
                                                                    child: Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Text(
                                                                        'Special instructions',
                                                                        style: GoogleFonts.nunitoSans(
                                                                            fontWeight: FontWeight.bold, fontSize: 14),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width / 1.06,
                                                                          height: MediaQuery.of(context).size.height / 9,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.grey),
                                                                              borderRadius:
                                                                              BorderRadius.all(Radius.circular(5))),
                                                                          child: TextField(
                                                                            decoration: InputDecoration(
                                                                              contentPadding:
                                                                              EdgeInsets.only(left: 10, top: 5),
                                                                              border: InputBorder.none,
                                                                            ),
                                                                            maxLines: 5,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Total Price : ',
                                                                          style: GoogleFonts.nunitoSans(
                                                                              fontWeight: FontWeight.w600, fontSize: 18),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 3),
                                                                          child: Container(
                                                                            width: 60,
                                                                            height: 30,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius:
                                                                              BorderRadius.all(Radius.circular(5)),
                                                                              //border: Border.all(color: Colors.black)
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                'Rs 225',
                                                                                style: GoogleFonts.nunitoSans(
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: (){
                                                                            Navigator.of(context).pop();
                                                                            //addAddOnsToCart(context);
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width / 2.3,
                                                                            height: MediaQuery.of(context).size.height / 20,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius.all(Radius.circular(7)),
                                                                                color: Colors.grey[300]),
                                                                            child: Center(
                                                                              child: Text(
                                                                                'Cancel',
                                                                                style: GoogleFonts.nunitoSans(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18,
                                                                                    color: Colors.black),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap: (){
                                                                            Navigator.push(
                                                                                context,
                                                                                PageRouteBuilder(
                                                                                  pageBuilder: (c, a1, a2) =>CartPage(),
                                                                                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                                                                  transitionDuration: Duration(milliseconds: 300),
                                                                                )
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width / 2.3,
                                                                            height: MediaQuery.of(context).size.height / 20,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius:
                                                                                BorderRadius.all(Radius.circular(7)),
                                                                                color: Colors.blue[700]),
                                                                            child: Center(
                                                                              child: Text(
                                                                                'Proceed',
                                                                                style: GoogleFonts.nunitoSans(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 18,
                                                                                    color: Colors.white),
                                                                              ),
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
                                                        ) ;

                                                      });
                                                }).whenComplete((){
                                              getItemAdons(context).whenComplete((){
                                                Future.delayed(Duration(seconds: 3), () async {
                                                  print("setting state");
                                                  setState(() {

                                                  });
                                                });
                                              });
                                            });

                                             */
                                      },
                                      child: Container(
                                        height: 32,
                                        width: 90,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    5)),
                                            border: Border.all(
                                                color: Colors
                                                    .grey)),
                                        child: Center(
                                          child: Text(
                                            "Add",
                                            textScaleFactor:
                                            1,
                                            style: GoogleFonts
                                                .nunitoSans(
                                                color: Colors
                                                    .white,
                                                fontSize:
                                                17,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      currencySymbl +
                                          home.itemPrice2[
                                          int.parse(selectedItemIdForSearch)],
                                      textScaleFactor: 1,
                                      style: GoogleFonts.nunitoSans(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              /*
                                  GestureDetector(
                                    onTap: () {
                                      homePageApiProvider.getItemAdons(context);
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                Colors.black.withOpacity(0.5),
                                                blurRadius: 5)
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.green[500]),
                                      child: Center(
                                        child: Text(
                                          'Add',
                                          style: GoogleFonts.nunitoSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),

                                   */
                            ]),
                      ),
                    ],
                  )),
            ),
          );
  }

  void slideSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Color(0xFF737373),
              child: Container(
                height: (MediaQuery.of(context).size.height /
                    2), //*double.parse(cuisineNames.length.toString()),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Cuisines',
                      textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        height: 100 *
                            (double.parse(cuisineNames.length.toString()) / 3),
                        //(MediaQuery.of(context).size.height /
                        //3.5),//*double.parse(cuisineNames.length.toString()),
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 2),
                          itemCount:
                              cuisineNames == null ? 0 : cuisineNames.length,
                          shrinkWrap: true,
                          itemBuilder: (_, i) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedCuisine = cuisineIds[i];
                              });
                            },
                            child: Container(
                              height: 20,
                              child: Row(
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: selectedCuisine == cuisineIds[i]
                                          ? Colors.blue
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 15,
                                    width: 80,
                                    child: Text(
                                      cuisineNames[i],
                                      textScaleFactor: 1,
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        getItemListAccordingToCuisine(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: Colors.blue[700]),
                        child: Center(
                          child: Text(
                            'Apply Filter',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    /*
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = "1";
                                });
                                print(selectedCuisine);
                              },
                              child: Container(
                                      width:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              45,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black),
                                        color: selectedCuisine == "1" ? Colors.blue : Colors.white,
                                      ),
                                    )
                                  ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'North Indian',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = "2";
                                });
                                print(selectedCuisine);
                              },
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width /
                                    25,
                                height:
                                MediaQuery.of(context).size.height /
                                    45,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black),
                                  color: selectedCuisine == "2" ? Colors.blue : Colors.white,
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'South Indian',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = "3";
                                });
                                print(selectedCuisine);
                              },
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width /
                                    25,
                                height:
                                MediaQuery.of(context).size.height /
                                    45,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black),
                                  color: selectedCuisine == "3" ? Colors.blue : Colors.white,
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'Gujrati',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = "4";
                                });
                                print(selectedCuisine);
                              },
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width /
                                    25,
                                height:
                                MediaQuery.of(context).size.height /
                                    45,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black),
                                  color: selectedCuisine == "4" ? Colors.blue : Colors.white,
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'Bengali',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = "5";
                                });
                                print(selectedCuisine);
                              },
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width /
                                    25,
                                height:
                                MediaQuery.of(context).size.height /
                                    45,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black),
                                  color: selectedCuisine == "5" ? Colors.blue : Colors.white,
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'Italian',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = "6";
                                });
                                print(selectedCuisine);
                              },
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width /
                                    25,
                                height:
                                MediaQuery.of(context).size.height /
                                    45,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black),
                                  color: selectedCuisine == "6" ? Colors.blue : Colors.white,
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'Mexican',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = "7";
                                });
                                print(selectedCuisine);
                              },
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width /
                                    25,
                                height:
                                MediaQuery.of(context).size.height /
                                    45,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black),
                                  color: selectedCuisine == "7" ? Colors.blue : Colors.white,
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'Desserts',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = "8";
                                });
                                print(selectedCuisine);
                              },
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width /
                                    25,
                                height:
                                MediaQuery.of(context).size.height /
                                    45,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black),
                                  color: selectedCuisine == "8" ? Colors.blue : Colors.white,
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'Asian',textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCuisine = "9";
                                });
                                print(selectedCuisine);
                              },
                              child: Container(
                                width:
                                MediaQuery.of(context).size.width /
                                    25,
                                height:
                                MediaQuery.of(context).size.height /
                                    45,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black),
                                  color: selectedCuisine == "9" ? Colors.blue : Colors.white,
                                ),
                              )
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            'Continental',textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){
                        getItemListAccordingToCuisine(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: MediaQuery.of(context).size.height / 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            color: Colors.blue[700]),
                        child: Center(
                          child: Text(
                            'Apply Filter',textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                     */
                  ],
                ),
              ),
            );
          });
        });
  }

  void slideSheetAddOns() {
    getItemAdons(context).whenComplete(() {
      Future.delayed(Duration(seconds: 3), () async {
        print("setting state");
        setState(() {});
      });
    });
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
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Add-Ons ?',
                        textScaleFactor: 1,
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(0.0),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            home.adonName == null ? 0 : home.adonName.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                home.adonName[index] == null ||
                                        home.adonName[index] == "null"
                                    ? "loading"
                                    : home.adonName[index] +
                                        " (Rs " +
                                        home.adonPrice[index] +
                                        ")",
                                textScaleFactor: 1,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 18,
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(50),
                                            topLeft: Radius.circular(50)),
                                        color: Colors.deepPurple[700]),
                                    child: GestureDetector(
                                        onTap: () {
                                          if (counter > 0) {
                                            setState(() {
                                              counter--;
                                            });
                                          } else {}
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 16,
                                        )),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 18,
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                    color: Colors.white,
                                    child:
                                        Center(child: Text(counter.toString())),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 18,
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(50),
                                            topRight: Radius.circular(50)),
                                        color: Colors.deepPurple[700]),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          counter++;
                                        });
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Special instructions',
                            textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.06,
                              height: MediaQuery.of(context).size.height / 9,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: TextField(
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, top: 5),
                                  border: InputBorder.none,
                                ),
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Price : ',
                              textScaleFactor: 1,
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  //border: Border.all(color: Colors.black)
                                ),
                                child: Center(
                                  child: Text(
                                    'Rs 225',
                                    textScaleFactor: 1,
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                addAddOnsToCart(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.3,
                                height: MediaQuery.of(context).size.height / 20,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    color: Colors.grey[300]),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    textScaleFactor: 1,
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => CartPage(),
                                      transitionsBuilder:
                                          (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                    ));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.3,
                                height: MediaQuery.of(context).size.height / 20,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7)),
                                    color: Colors.blue[700]),
                                child: Center(
                                  child: Text(
                                    'Proceed',
                                    textScaleFactor: 1,
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
