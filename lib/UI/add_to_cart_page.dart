import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dabbawala/UI/choose_ad_ons.dart';
import 'package:dabbawala/UI/data/bottom_nav_data.dart';
import 'package:dabbawala/UI/map_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'data/home_data.dart' as home;
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;

List<String> addOnName;
List<String> addOnPrice;
int counter = 0;
int counterTwo = 0;
int counterThree = 0;
int counterFour = 0;

var subItemIdsList;
var subItemNamesList;
var subItemDescriptionList;
var subItemAmountsList;
var subItemPricesList;

var images;
var imageIds;

class AddToCartPage extends StatefulWidget {
  final itemId;
  final tempCartId;
  final itemPrice;
  final name;
  final desc;
  final price;
  final vendor;
  AddToCartPage(this.itemId, this.tempCartId, this.itemPrice, this.name, this.desc, this.price, this.vendor) : super();
  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {

  Future<String> getItemImages(context) async {

    String url = "https://admin.dabbawala.ml/mobileapi/vendor/getimagebyitemid.php";

    http.post(url, body: {

      "itemID" : widget.itemId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetImages = jsonDecode(response.body);
      print(responseArrayGetImages);

      var responseArrayGetImagesMsg = responseArrayGetImages['message'].toString();
      print(responseArrayGetImagesMsg);

      if(statusCode == 200){
        if(responseArrayGetImagesMsg == "Successfully"){
          setState(() {
            imageIds = List.generate(responseArrayGetImages['data'].length, (index) => responseArrayGetImages['data'][index]['iimID'].toString());
            images = List.generate(responseArrayGetImages['data'].length, (index) => "https://admin.dabbawala.ml/"+responseArrayGetImages['data'][index]['imageName'].toString());
          });
          print(imageIds);
          print(images);

        }else{
          setState(() {
            images = null;
          });

        }
      }
    });

  }

  Future<String> getSubItemList(context) async {

    String url = "https://admin.dabbawala.ml/mobileapi/user/getsubitembyitemid.php";

    http.post(url, body: {

      "itemID" : widget.itemId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      var responseArrayGetSubItems = jsonDecode(response.body);
      print(responseArrayGetSubItems);

      var responseArrayGetSubItemsMsg = responseArrayGetSubItems['message'].toString();
      print(responseArrayGetSubItemsMsg);

      if(statusCode == 200){
        if(responseArrayGetSubItemsMsg == "Item Found"){
          //prGetItems.hide();
          setState(() {
            subItemIdsList = List.generate(responseArrayGetSubItems['data'].length, (index) => responseArrayGetSubItems['data'][index]['subitemID'].toString());
            subItemNamesList = List.generate(responseArrayGetSubItems['data'].length, (index) => responseArrayGetSubItems['data'][index]['subitemName'].toString());
            subItemDescriptionList = List.generate(responseArrayGetSubItems['data'].length, (index) => responseArrayGetSubItems['data'][index]['subitemDescription'].toString());
            subItemAmountsList = List.generate(responseArrayGetSubItems['data'].length, (index) => responseArrayGetSubItems['data'][index]['subitemPrice'].toString());
          });
          print(subItemIdsList.toList());
          print(subItemNamesList.toList());
          print(subItemDescriptionList.toList());
          print(subItemAmountsList.toList());

        }else{
          //prGetItems.hide();
          setState(() {
            subItemNamesList = null;
          });

        }
      }
    });

  }

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
          });
          print(home.adonName);
          print(home.adonPrice);

        }else{
          setState(() {
            home.adonName = null;
          });
        }
      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      getItemImages(context);
    });
    getSubItemList(context);
    getItemAdons(context);
    images = null;
    setState(() {
      addOnName = home.adonName;
      addOnPrice = home.adonPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: buildItemOptions(context),
      ),
      body: images == null ? Center(
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildMealsSlider(context),
            SizedBox(
              height: 20,
            ),
            buildFoodItems(context),
            SizedBox(height: MediaQuery.of(context).size.height / 10),
          ],
        ),
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        widget.name,textScaleFactor: 1,
        style: GoogleFonts.nunitoSans(
          color: Colors.black,
        ),
      ),
      centerTitle: false,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
    );
  }

  buildLocationContainer(BuildContext context) {
    return Container(
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
            Text(
              "Bhau Institute, COEP, Wellesly Road...",textScaleFactor: 1,
              style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavigationAppBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 13,
      color: Colors.blue[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Icon(
              Icons.location_on,
              color: Colors.white,
              size: 35,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => MapPage(),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 300),
                      ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.height / 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.black.withOpacity(0.3)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      'ITPL WhiteField',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMealsSlider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: CarouselSlider.builder(
              itemCount: images.length,
              options: CarouselOptions(
                  height: 200,
                  viewportFraction: 1,
                  initialPage: 0,
                  //aspectRatio: 16 / 9,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {}),
              itemBuilder: (BuildContext context, index) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.fill,
                    ),
                  ))),
    );
  }

  Widget buildFoodItems(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size.height/2.55,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.name,textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  globals.currencySymbl+widget.price,textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              widget.desc,
              style: GoogleFonts.nunitoSans(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Sold by : "+widget.vendor,
              style: GoogleFonts.nunitoSans(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.yellow[900],
              ),
            ),
          ),
          buildSubItemsListViewBuilder(context),
          /*
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rice_bowl,
                      color: Colors.green[800],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Steamed Basmati Rice',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '100 gm',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 17, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rice_bowl,
                      color: Colors.green[800],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Dal Takda',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '50 gm',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 17, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rice_bowl,
                      color: Colors.green[800],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Paneer Tikka Masala',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '100 gm',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 17, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rice_bowl,
                      color: Colors.green[800],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Roti (Butter)',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '2 pcs',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 17, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rice_bowl,
                      color: Colors.green[800],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Papad',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '1 pc',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 17, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rice_bowl,
                      color: Colors.green[800],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Curd',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '1 pc',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 17, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rice_bowl,
                      color: Colors.green[800],
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Rabdi',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '1 pc',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 17, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),

           */
          //Divider(),
        ],
      ),
    );
  }

  Widget buildItemOptions(BuildContext context) {
    return Container(
      height: home.adonName == null ? 45 : 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: home.adonName == null ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2.2,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.grey[300]),
              child: Center(
                child: Text(
                  'Back',textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          ),
          home.adonName == null ? Container() : GestureDetector(
            onTap: () {
              if(home.adonName == null){
                Navigator.of(context).pop();
              }else{
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => ChooseAdOns(widget.itemId, widget.tempCartId, widget.itemPrice),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    )
                );
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2.2,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.blue[700]),
              child: Center(
                child: Text(
                  'Choose AdOns',textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void slideSheetAddOns() {
    setState(() {
      addOnName = home.adonName;
      addOnPrice = home.adonPrice;
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
                  height: MediaQuery.of(context).size.height / 1.8,
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
                        height: 10,
                      ),
                      Text(
                        'Add-Ons ?',
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Text(
                              home.adonName[selectedIndex]+home.adonPrice[selectedIndex],
                              style: GoogleFonts.nunitoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
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
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Chapati (10 Rs)',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 60,
                            ),
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
                                        if(counterTwo>0){
                                          setState(() {
                                            counterTwo--;
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
                                      Center(child: Text(counterTwo.toString())),
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
                                        counterTwo++;
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
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Text(
                              'Papad (7 Rs)',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 21,
                            ),
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
                                        if(counterThree>0){
                                          setState(() {
                                            counterThree--;
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
                                      Center(child: Text(counterThree.toString())),
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
                                        counterThree++;
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
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Paratha (15 Rs)',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 60,
                            ),
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
                                        if(counterFour>0){
                                          setState(() {
                                            counterFour--;
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
                                      Center(child: Text(counterFour.toString())),
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
                                        counterFour++;
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
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Text(
                              'Sweet Curd',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ToggleSwitch(
                              minHeight: 25.0,
                              minWidth: 45.0,
                              cornerRadius: 20.0,
                              activeBgColor: Colors.deepPurple[700],
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey[300],
                              inactiveFgColor: Colors.black,
                              labels: [
                                'No',
                                'Yes',
                              ],
                              fontSize: 13,
                              onToggle: (index) {
                                print('switched to: $index');
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Onion',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 40,
                            ),
                            ToggleSwitch(
                              minHeight: 25.0,
                              minWidth: 45.0,
                              cornerRadius: 20.0,
                              activeBgColor: Colors.deepPurple[700],
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey[300],
                              inactiveFgColor: Colors.black,
                              labels: [
                                'No',
                                'Yes',
                              ],
                              fontSize: 13,
                              onToggle: (index) {
                                print('switched to: $index');
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Text(
                              'Special Instruction',
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                                      globals.currencySymbl+ '225',
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
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
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
                            Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: MediaQuery.of(context).size.height / 20,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                  color: Colors.blue[700]),
                              child: Center(
                                child: Text(
                                  'Add to Cart',
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
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
            ) ;

              });
        });
  }

  Widget buildSubItemsListViewBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
      child: Column(children: [
        Divider(),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            itemCount: subItemNamesList == null ? 0 : subItemNamesList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,width: 25,
                            child: Center(child: Image.asset("assets/images/fried-rice.png"))
                          ),
                          SizedBox(width: 10,),
                          Container(
                            //width: MediaQuery.of(context).size.width/1.5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Text(
                                subItemNamesList[index],
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
                              subItemAmountsList[index],
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          //SizedBox(width: 5,),
                        ],
                      )),
                  Divider(),
                ],
              ),
            ))
      ]),
    );
  }

}
