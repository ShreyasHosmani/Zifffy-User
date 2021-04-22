import 'package:dabbawala/UI/cart_page.dart';
import 'package:dabbawala/UI/home_page.dart' as h;
import 'package:dabbawala/UI/home_page1.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:dabbawala/UI/data/home_data.dart' as home;
import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';

List<int> counters;
List<String> adOnIds;
var totalPrice;
var selectedAdsOnId;

var selecAdsOnIdForDelete;

bool showW = false;

ProgressDialog prAdsOn;

class ChooseAdOns extends StatefulWidget {
  final itemId;
  final tempCartId;
  final itemPrice;
  ChooseAdOns(this.itemId, this.tempCartId, this.itemPrice) : super();
  @override
  _ChooseAdOnsState createState() => _ChooseAdOnsState();
}

class _ChooseAdOnsState extends State<ChooseAdOns> {

  Future<String> getItemAdons(context) async {

    String url = globals.apiUrl + "getitemadsonlist.php";

    http.post(url, body: {

      "itemID": widget.itemId.toString(),

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

          setState(() {
            home.adonName = List.generate(home.responseArrayGetAdons['data'].length, (index) => home.responseArrayGetAdons['data'][index]['itemadsonName'].toString());
            home.adonPrice = List.generate(home.responseArrayGetAdons['data'].length, (index) => home.responseArrayGetAdons['data'][index]['itemadsonPrice'].toString());
            adOnIds = List.generate(home.responseArrayGetAdons['data'].length, (index) => home.responseArrayGetAdons['data'][index]['itemadsonID'].toString());
            counters = List.generate(home.adonName.length, (index) => 0);
          });
          print(home.adonName);
          print(home.adonPrice);
          print(adOnIds);
          print(counters);

        }else{
          setState(() {
            home.adonName = null;
          });
        }
      }
    });

  }

  Future<String> getCartAdons(context) async {

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
//            int sum = cartAdOnPricesList.fold(0, (previous, current) => int.parse(previous.toString()) + int.parse(current.toString()));
//            print("adons total :" + sum.toString());
//            finalAmountWithAdOns = int.parse(finalAmount.toString())+int.parse(sum.toString());
//            finalAmount2 = (int.parse(finalAmountWithAdOns.toString())+18+10).toString();
          });

          print(cartAdOnIdsList.toList());
          print(cartAdOnNamesList.toList());
          print(cartAdOnPricesList.toList());
//          print("final amount : "+finalAmountWithAdOns.toString());
//          print(finalAmount2);

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

  Future<String> addAddOnsToCart(context) async {

    String url = globals.apiUrl + "addcartadson.php";

    http.post(url, body: {

      "cartID" : h.tempCartId,
      "adsonID[0]" : selectedAdsOnId,

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayAddAdsOn = jsonDecode(response.body);
      print(responseArrayAddAdsOn);

      var responseArrayAddAdsOnMsg = responseArrayAddAdsOn['message'].toString();
      print(responseArrayAddAdsOnMsg);

      if(statusCode == 200){
        if(responseArrayAddAdsOnMsg == "Successfully"){

          prAdsOn.hide();
          Fluttertoast.showToast(msg: 'Added', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            getCartAdons(context);
          });

        }else{

          prAdsOn.hide();
          Fluttertoast.showToast(msg: 'Some error occured', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  Future<String> removeAdsOn(context) async {

    String url = globals.apiUrl + "removeadson.php";

    http.post(url, body: {

      "id" : selecAdsOnIdForDelete.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayRemoveAdsOn = jsonDecode(response.body);
      print(responseArrayRemoveAdsOn);

      var responseArrayRemoveAdsOnMsg = responseArrayRemoveAdsOn['message'].toString();
      print(responseArrayRemoveAdsOnMsg);

      if(statusCode == 200){
        if(responseArrayRemoveAdsOnMsg == "Successfully"){

          prAdsOn.hide();
          Fluttertoast.showToast(msg: 'Removed', backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
            getCartAdons(context);
          });

        }else{

          prAdsOn.hide();
          Fluttertoast.showToast(msg: 'Some error occured', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemAdons(context);
    counters = [];
    adOnIds = [];
    showW = false;
    selecAdsOnIdForDelete = null;
    selectedAdsOnId = null;
    Future.delayed(Duration(seconds: 3), () async {
      setState(() {
        showW = true;
      });
    });
    totalPrice = widget.itemPrice;
  }

  @override
  Widget build(BuildContext context) {
    prAdsOn = ProgressDialog(context);
    return showW == true ? Stack(
      children: [
        HomePage1(),
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.5),
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: buildAdOnsBody(context),
          ),
        ),
      ],
    ) : Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(),),
    );
  }

  Widget buildBottomNavBarButtons(BuildContext context){
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            height: 40,
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.all(Radius.circular(7)),
                color: Colors.grey[300]),
            child: Center(
              child: Text(
                'Cancel',textScaleFactor: 1,
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
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
              height: 40,
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(7)),
                  color: Colors.blue[700]),
              child: Center(
                child: Text(
                  'Proceed',textScaleFactor: 1,
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
    );
  }

  Widget buildAdOnsBody(BuildContext context){
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
                'Add-Ons ?',textScaleFactor: 1,
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
                                IconButton(icon: Icon(Icons.remove_circle,color: Colors.red,size: 15,), onPressed: (){
                                  prAdsOn.show();
                                  setState(() {
                                    selecAdsOnIdForDelete = cartAdOnIdsList[index].toString();
                                  });
                                  print(selecAdsOnIdForDelete);
                                  removeAdsOn(context);
                                }),
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
                                Spacer(),
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
                  )),
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
                      Text(home.adonName[index] == null || home.adonName[index] == "null" ? "loading" : home.adonName[index] + " (Rs " + home.adonPrice[index] + ")", textScaleFactor: 1,),
                      Row(
                        children: [
//                          Container(
//                            width: MediaQuery.of(context).size.width / 18,
//                            height:
//                            MediaQuery.of(context).size.height / 40,
//                            color: Colors.white,
//                            child:
//                            Center(child: Text(counters[index].toString())),
//                          ),
//                          SizedBox(width: 20,),
                          Container(
                            width: 50,
                            height:
                            MediaQuery.of(context).size.height / 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                    topLeft: Radius.circular(50), bottomLeft: Radius.circular(50),
                                  ),
                                color: Colors.deepPurple[700]),
                            child: GestureDetector(
                              onTap: () {
                                prAdsOn.show();
                                setState(() {
                                  counters[index]++;
                                });
                                print(counters[index]);
                                if(counters[index] > 0){
                                  setState(() {
                                    totalPrice = (int.parse(totalPrice)+(int.parse(home.adonPrice[index]))).toString();
                                    selectedAdsOnId = adOnIds[index].toString();
                                  });
                                  print(totalPrice);
                                  print(selectedAdsOnId);
                                  addAddOnsToCart(context);
//                                  if(home.adonName.length == 0){
//
//                                  }else if(home.adonName.length == 1){
//                                    addAddOnsToCart1(context);
//                                  }else if(home.adonName.length == 2){
//                                    addAddOnsToCart2(context);
//                                  }else if(home.adonName.length == 3){
//                                    addAddOnsToCart3(context);
//                                  }else if(home.adonName.length == 4){
//                                    addAddOnsToCart4(context);
//                                  }else if(home.adonName.length == 5){
//                                    addAddOnsToCart5(context);
//                                  }else if(home.adonName.length == 6){
//                                    addAddOnsToCart6(context);
//                                  }else if(home.adonName.length == 7){
//                                    addAddOnsToCart7(context);
//                                  }else if(home.adonName.length == 8){
//                                    addAddOnsToCart8(context);
//                                  }else if(home.adonName.length == 9){
//                                    addAddOnsToCart9(context);
//                                  }else{
//                                    addAddOnsToCart10(context);
//                                  }
                                }
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
//              Padding(
//                padding: const EdgeInsets.only(left: 10),
//                child: Align(
//                  alignment: Alignment.centerLeft,
//                  child: Text(
//                    'Special instructions',textScaleFactor: 1,
//                    style: GoogleFonts.nunitoSans(
//                        fontWeight: FontWeight.bold, fontSize: 14),
//                  ),
//                ),
//              ),
//              SizedBox(
//                height: 5,
//              ),
//              Padding(
//                padding: const EdgeInsets.only(left: 10, right: 10),
//                child: Row(
//                  children: [
//                    Container(
//                      width: MediaQuery.of(context).size.width / 1.06,
//                      height: MediaQuery.of(context).size.height / 9,
//                      decoration: BoxDecoration(
//                          border: Border.all(color: Colors.grey),
//                          borderRadius:
//                          BorderRadius.all(Radius.circular(5))),
//                      child: TextField(
//                        decoration: InputDecoration(
//                          contentPadding:
//                          EdgeInsets.only(left: 10, top: 5),
//                          border: InputBorder.none,
//                        ),
//                        maxLines: 5,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              SizedBox(
//                height: 10,
//              ),
//              Padding(
//                padding: const EdgeInsets.only(left: 10, right: 10),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    Text(
//                      'Total Price : ',textScaleFactor: 1,
//                      style: GoogleFonts.nunitoSans(
//                          fontWeight: FontWeight.w600, fontSize: 18),
//                    ),
//                    Padding(
//                      padding: const EdgeInsets.only(right: 3),
//                      child: Container(
//                        width: 60,
//                        height: 30,
//                        decoration: BoxDecoration(
//                          borderRadius:
//                          BorderRadius.all(Radius.circular(5)),
//                          //border: Border.all(color: Colors.black)
//                        ),
//                        child: Center(
//                          child: totalPrice == null || totalPrice == "" || totalPrice == " " || totalPrice == "null" ? Text(
//                            globals.currencySymbl+widget.itemPrice,textScaleFactor: 1,
//                            style: GoogleFonts.nunitoSans(
//                                fontSize: 18,
//                                fontWeight: FontWeight.bold),
//                          ) : Text(
//                           globals.currencySymbl+totalPrice,textScaleFactor: 1,
//                            style: GoogleFonts.nunitoSans(
//                                fontSize: 18,
//                                fontWeight: FontWeight.bold),
//                          ),
//                        ),
//                      ),
//                    )
//                  ],
//                ),
//              ),
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
                            'Continue Browsing',textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
                            'Proceed to Buy',textScaleFactor: 1,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
  }

}
