import 'dart:convert';
import 'package:dabbawala/UI/data/bottom_nav_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:dabbawala/UI/data/cart_data.dart' as cart;
import 'package:dabbawala/UI/data/home_data.dart' as home;

class CartPageApiProvider {

  Future<String> addCart(context) async {


    String url = globals.apiUrl + "addcart.php";

    http.post(url, body: {

    "userID" : home.userIdResponse.toString(),
      "itemID" :home.itemId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      cart.responseArrayAddCart = jsonDecode(response.body);
      print(cart.responseArrayAddCart);
      cart.getAddCartResponse= cart.responseArrayAddCart['status'].toString();
      cart.getAddCartMessage = cart.responseArrayAddCart['message'].toString();
      if(statusCode == 200){
        if(cart.getAddCartMessage == "Successfully"){
          print(cart.getAddCartMessage);





        }else if (cart.getAddCartMessage == "Error Changing Password"){

        }
      }
    });

  }

  Future<String> addCartAddons(context) async {



    String url = globals.apiUrl + "addcartadson.php";

    http.post(url, body: {

      // "cartID" :
      // "adsonID" :


    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      cart.responseArrayAddCartAdons = jsonDecode(response.body);
      print(cart.responseArrayAddCartAdons);
      cart.getAddCartAdonsResponse = cart.responseArrayAddCartAdons['status'].toString();
      cart.getAddCartAdonsMessage = cart.responseArrayAddCartAdons['message'].toString();
      if(statusCode == 200){
        if(cart.getAddCartAdonsMessage == "Successfully"){


        }
      }
      else if (cart.getAddCartAdonsMessage == "Unable to login. Data is incomplete"){

      }
    });

  }

  Future<String> getCart(context) async {

    String url = globals.apiUrl + "getcart.php";

    http.post(url, body: {

      // "userID" :
      // "cartID" :

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      cart.responseArrayGetCart = jsonDecode(response.body);
      print(cart.responseArrayGetCart);
      cart.getCartResponse = cart.responseArrayGetCart['status'].toString();
      cart.getCartMessage = cart.responseArrayGetCart['message'].toString();
      if(statusCode == 200){
        if(cart.getCartMessage == "Item Found"){

        }else if (cart.getCartMessage == "Error fetching data"){

        }
      }
    });

  }

  Future<String> removeItem(context) async {



    String url = globals.apiUrl + "removeitem.php";

    http.post(url, body: {

      // "cartID":


    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      cart.responseArrayRemoveCart = jsonDecode(response.body);
      print(cart.responseArrayRemoveCart);
      cart.getRemoveCartResponse = cart.responseArrayRemoveCart['status'].toString();
      cart.getRemoveCartMessage = cart.responseArrayRemoveCart['message'].toString();
      if(statusCode == 200){
        if(cart.getRemoveCartMessage == "Successfully"){


        }else if (cart.getRemoveCartMessage == "Unable To Delete Item From Cart"){

        }
      }
    });

  }




}