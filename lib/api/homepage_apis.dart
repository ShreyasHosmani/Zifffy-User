import 'dart:convert';
import 'package:dabbawala/UI/data/bottom_nav_data.dart';
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:dabbawala/UI/data/home_data.dart' as home;

class HomePageApiProvider {

  Future<String> getItemList(context) async {

    String url = globals.apiUrl + "getallitemlist.php";

    http.post(url, body: {


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
          home.itemId = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index]['itemID']);
          print(home.itemId);
          home.itemName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index]['itemName']);
          print(home.itemName);
          home.itemPrice = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index]['itemPrice']);
          print(home.itemPrice);
          home.image = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index]['imageName']);
          print(home.image);
          home.itemDescription = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index]['itemDescription']);
          print(home.itemDescription);
          home.vendorName = List.generate(home.responseArrayGetItems['data'].length, (index) => home.responseArrayGetItems['data'][index]['vendorName']);
          print(home.vendorName);

        }else if (home.getItemsMessage == "Error fetching data"){

        }
      }
    });

  }

  Future<String> getItemDetailsById(context) async {

    String url = globals.apiUrl + "getitemdetailsbyitemid.php";

    http.post(url, body: {

      "itemID": '1',


    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      home.responseArrayGetItemDetails = jsonDecode(response.body);
      print(home.responseArrayGetItemDetails);
      home.getItemDetailsResponse = home.responseArrayGetItemDetails['status'].toString();
      home.getItemDetailsMessage = home.responseArrayGetItems['message'].toString();
      if(statusCode == 200){
        if(home.getItemDetailsMessage == "Item Found"){
          print(home.itemId);

        }else if (home.getItemDetailsMessage == "Error fetching data"){
        print(home.itemId);
        }
      }
    });

  }

  Future<String> getItemAdons(context) async {

    String url = globals.apiUrl + "getitemadsonlist.php";

    http.post(url, body: {

      "itemID": home.itemId[selectedIndex].toString(),


    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      home.responseArrayGetAdons = jsonDecode(response.body);
      print(home.responseArrayGetAdons);
      home.getAdonsResponse= home.responseArrayGetAdons['status'].toString();
      home.getAdonsMessage = home.responseArrayGetAdons['message'].toString();
      if(statusCode == 200){
        if(home.getAdonsMessage == "Item Found"){
          print(home.itemId);
          home.adonName = List.generate(home.responseArrayGetAdons['data'].length, (index) => home.responseArrayGetAdons['data'][index]['itemadsonName'].toString());
          print(home.adonName);
          home.adonPrice = List.generate(home.responseArrayGetAdons['data'].length, (index) => home.responseArrayGetAdons['data'][index]['itemadsonPrice'].toString());
          print(home.adonPrice);




        }else if (home.getAdonsMessage == "Error fetching data"){
          print(home.itemId);
        }
      }
    });

  }

}