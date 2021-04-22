import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dabbawala/UI/Widgets/switch_widget_veg_nonveg.dart';
import 'package:dabbawala/UI/cart_page.dart';
import 'package:dabbawala/UI/cart_page_without_bottom_nav.dart';
import 'package:dabbawala/UI/choose_ad_ons.dart';
import 'package:dabbawala/UI/map_page.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'data/home_data.dart' as home;
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:dabbawala/UI/data/home_data.dart' as home;
import 'dart:convert';
import 'package:dabbawala/UI/home_page.dart' as bm;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_page.dart';

var selectedPlace;

ProgressDialog prGetItems;

List<String> itemIdT;
List<String> itemNameT;

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

var kInitialPosition = LatLng(bm.lat, bm.long);

var selectedItemIdForSearch;

bool showSearchedItem = false;

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  Future<String> getItemListAccToLatLong(context) async {
    String url = globals.apiUrl + "getnearbyvendorsbylatlong.php";

    http.post(url, body: {
      "latitude": bm.lat.toString(),
      "longitude": bm.long.toString(),
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
            counters = List.generate(home.itemId.length, (index) => 0);
          });
          print(home.itemId);
          print(home.itemName);
          print(home.itemPrice);
          print(home.image);
          print(home.itemDescription);
          print(home.vendorName);
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
            counters = List.generate(home.itemId.length, (index) => 0);
          });
          print(home.itemId);
          print(home.itemName);
          print(home.itemPrice);
          print(home.image);
          print(home.itemDescription);
          print(home.vendorName);
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
                    home.responseArrayGetItems['data'][index]['itemID'] +
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
            counters2 = List.generate(home.itemId2.length, (index) => 0);
          });
          print(home.itemId2);
          print(home.itemName2);
          print(home.itemNameTwo);
          print(home.itemPrice2);
          print(home.image2);
          print(home.itemDescription2);
          print(home.vendorName2);
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
            counters = List.generate(home.itemId.length, (index) => 0);
          });
          print(home.itemId);
          print(home.itemName);
          print(home.itemPrice);
          print(home.image);
          print(home.itemDescription);
          print(home.vendorName);
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
            counters = List.generate(home.itemId.length, (index) => 0);
          });
          print(home.itemId);
          print(home.itemName);
          print(home.itemPrice);
          print(home.image);
          print(home.itemDescription);
          print(home.vendorName);
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
              counters = List.generate(home.itemId.length, (index) => 0);
            });
            print(home.itemId);
            print(home.itemName);
            print(home.itemPrice);
            print(home.image);
            print(home.itemDescription);
            print(home.vendorName);
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
    String url = globals.apiUrl + "removeitem.php";

    http.post(url, body: {
      "id": selectedItemId.toString(),
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
//    setState(() {
//      if(bm.lat == null || bm.long == null){
//
//      }else{
//        kInitialPosition = LatLng(bm.lat, bm.long);
//      }
//      counters = [];
//      showSearchedItem = false;
//      switchControl = true;
//      selectedItemType = null;
//      selectedVegOrNonVeg = null;
//      selectedCuisine = [];
//      selectedItemIdForSearch = null;
//    });
//    getProfile(context);
//    //getItemListAccToLatLong(context);
//    getItemList(context);
//    getItemListTwo(context);
    //deleteCart(context);
  }

  @override
  Widget build(BuildContext context) {
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
          body: SingleChildScrollView(
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
                                   child: Image.network("https://admin.dabbawala.ml/"+home.image2[int.parse(selectedItemIdForSearch)].toString(),
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
                                                       child: Icon(Icons.delete, color: Colors.grey, size: 20,),
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
                                                                                      Icons.delete,
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

                //usePlaceDetailSearch: true,
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
                    bm.lat =
                        result.geometry.toJson()['location']['lat'].toString();
                    bm.long =
                        result.geometry.toJson()['location']['lng'].toString();
                  });
                  print(bm.lat);
                  print(bm.long);
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
          setState(() {});
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
              bm.addressIdsList == null || bm.addressIdsList == "null"
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
              onTap: () {},
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
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
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
            height: 10,
          ),
          Container(
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
                    child: Text(
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
                      child: Center(
                        child: Text(
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
                      child: Center(
                        child: Text(
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
                      child: Center(
                        child: Text(
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
                      child: Center(
                        child: Text(
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
        ? Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: home.itemId == null
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
                : Column(children: [
                    ListView.builder(
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
                                    selectedItemId =
                                        home.itemId[index].toString();
                                  });
                                  print(selectedItemId);
                                  //addToCart(context);
                                  //getItemAdons(context);
                                  //slideSheetAddOns();
                                },
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
                                        Container(
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
                                          child: Image.network(
                                            "https://admin.dabbawala.ml/" +
                                                home.image[index].toString(),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0, top: 0),
                                                child: Container(
                                                  width: 150,
                                                  child: Text(
                                                    home.itemName[index],
                                                    textScaleFactor: 1,
                                                    maxLines: 2,
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 0,
                                              ),
                                              Container(
                                                width: 150,
                                                child: Text(
                                                  home.itemDescription[index],
                                                  textScaleFactor: 1,
                                                  maxLines: 2,
                                                  style: GoogleFonts.nunitoSans(
                                                    color: Colors.grey,
                                                    fontSize: 12.5,
                                                  ),
                                                ),
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
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
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
                                                                          context);
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
                                                                          .delete,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 20,
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
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      counters[
                                                                          index]++;
                                                                    });
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
                                                                            () {});
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
                                                                      size: 20,
                                                                    ),
                                                                  )),
                                                            ],
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                selectedItemId = home
                                                                    .itemId[
                                                                        index]
                                                                    .toString();
                                                                counters[
                                                                    index]++;
                                                              });
                                                              print(
                                                                  selectedItemId);
                                                              print(counters[
                                                                  index]);
                                                              //prAddToCart.show();
                                                              getItemAdons(
                                                                  context);
                                                              addToCart(context)
                                                                  .whenComplete(
                                                                      () {});
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
                                                                                      Icons.delete,
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
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey)),
                                                              child: Center(
                                                                child: Text(
                                                                  "Add +",
                                                                  textScaleFactor:
                                                                      1,
                                                                  style: GoogleFonts
                                                                      .nunitoSans(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      globals.currencySymbl +
                                                          home.itemPrice[index],
                                                      textScaleFactor: 1,
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                            ))
                  ]),
          )
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
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: MediaQuery.of(context).size.height / 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.network(
                          "https://admin.dabbawala.ml/" +
                              home.image2[int.parse(selectedItemIdForSearch)]
                                  .toString(),
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 0, top: 0),
                              child: Container(
                                width: 150,
                                child: Text(
                                  home.itemNameTwo[
                                      int.parse(selectedItemIdForSearch)],
                                  textScaleFactor: 1,
                                  maxLines: 2,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                home.itemDescription2[
                                    int.parse(selectedItemIdForSearch)],
                                textScaleFactor: 1,
                                maxLines: 2,
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.grey,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3,
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
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                                    Icons.delete,
                                                    color: Colors.grey,
                                                    size: 20,
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
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedItemId = home
                                                        .itemId2[int.parse(
                                                            selectedItemIdForSearch)]
                                                        .toString();
                                                  });
                                                  print(selectedItemId);
                                                  setState(() {
                                                    counters2[int.parse(
                                                        selectedItemIdForSearch)]++;
                                                  });
                                                  print(counters2[int.parse(
                                                      selectedItemIdForSearch)]);
                                                  prAddToCart.show();
                                                  addToCart(context)
                                                      .whenComplete(() {
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
                                                                    opacity:
                                                                        anim,
                                                                    child:
                                                                        child),
                                                            transitionDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        300),
                                                          ));
                                                    });
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                )),
                                          ],
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedItemId = home
                                                  .itemId2[int.parse(
                                                      selectedItemIdForSearch)]
                                                  .toString();
                                              counters2[int.parse(
                                                  selectedItemIdForSearch)]++;
                                            });
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
                                                  ));
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
                                                                                      Icons.delete,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Center(
                                              child: Text(
                                                "Add +",
                                                textScaleFactor: 1,
                                                style: GoogleFonts.nunitoSans(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    globals.currencySymbl +
                                        home.itemPrice2[
                                            int.parse(selectedItemIdForSearch)],
                                    textScaleFactor: 1,
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
                                          Icons.delete,
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
