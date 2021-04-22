import 'package:dabbawala/UI/edit_address.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dabbawala/UI/data/map_data.dart' as map;
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:dabbawala/UI/Widgets/bottom_nav_bar.dart' as bm;
import 'home_page.dart';

var tmpLat;
var tmpLong;

List<String> addressIdsList;
List<String> addressNamesList;

TextEditingController addressLine1 = TextEditingController();
TextEditingController addressLine2 = TextEditingController();

ProgressDialog prAddLocation;

var selectedAddressId;

final formKey = GlobalKey<FormState>();

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

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
            addressIdsList = [];
          });

        }
      }
    });
  }

  Future<String> addAddress(context) async {

    String url = globals.apiUrl + "savecustomeraddress.php";

    http.post(url, body: {

      "latitude" : tmpLat.toString(),
      "longitude" : tmpLong.toString(),
      "customerID" : storedUserId.toString(),
      "address" : addressLine1.text.toString()+" - Address line 2 / Instructions : "+addressLine2.text.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArraySaveAddress = jsonDecode(response.body);
      print(responseArraySaveAddress);

      var responseArraySaveAddressMsg = responseArraySaveAddress['message'].toString();
      print(responseArraySaveAddressMsg);

      if(statusCode == 200){
        if(responseArraySaveAddressMsg == "Successfully"){

          prAddLocation.hide().whenComplete((){
            Fluttertoast.showToast(msg: "Saved", backgroundColor: Colors.black, textColor: Colors.white);
            addressLine1.clear();
            addressLine2.clear();
            getAddressList(context);
          });

        }else{

          prAddLocation.hide().whenComplete((){
            Fluttertoast.showToast(msg: "Some error occured!", backgroundColor: Colors.black, textColor: Colors.white);
          });

        }
      }
    });
  }

  Future<String> removeAddress(context) async {

    String url = globals.apiUrl + "removecustomeraddress.php";

    http.post(url, body: {

      "id" : selectedAddressId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayRemoveAddress = jsonDecode(response.body);
      print(responseArrayRemoveAddress);

      var responseArrayRemoveAddressMsg = responseArrayRemoveAddress['message'].toString();
      print(responseArrayRemoveAddressMsg);

      if(statusCode == 200){
        if(responseArrayRemoveAddressMsg == "Successfully"){

          prAddLocation.hide().whenComplete((){
            Fluttertoast.showToast(msg: "Removed", backgroundColor: Colors.black, textColor: Colors.white);
            getAddressList(context);
          });

        }else{

          prAddLocation.hide().whenComplete((){
            Fluttertoast.showToast(msg: "Some error occured!", backgroundColor: Colors.black, textColor: Colors.white);
          });

        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedAddressId = null;
    getAddressList(context);
  }

  @override
  Widget build(BuildContext context) {
    prAddLocation = ProgressDialog(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          title: Text("Location Settings",
            style: GoogleFonts.nunitoSans(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_outlined,color: Colors.black, size: 20,)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  buildLocationsListViewBuilder(context),
                  SizedBox(height: 0,),
                  Text("Add a new location",
                    style: GoogleFonts.nunitoSans(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  //SizedBox(height: 10,),
//                  Container(
//                    height: 300,
//                    width: MediaQuery.of(context).size.width,
//                    child: PlacePicker(
//                      apiKey: "AIzaSyAaHgfDzwtlUYxsaBZfqNCTbROLVhhw_N4",
//                      initialPosition: kInitialPosition,
//                      useCurrentLocation: true,
//                      selectInitialPosition: true,
//                      onPlacePicked: (result) {
//                        print(result.formattedAddress);
//                        print(result.geometry.toJson());
//                        //setState(() {
//                          addressLine1.text = result.formattedAddress.toString();
//                        //});
//                        print(addressLine1.text.toString());
//                      },
//                    ),
//                  ),
                  //SizedBox(height: 20,),
                  Container(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: TextFormField(
                    controller: addressLine1,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Enter address line 1',
                      hintStyle: GoogleFonts.nunitoSans(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,),
                    onChanged: (val){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              apiKey: "AIzaSyAaHgfDzwtlUYxsaBZfqNCTbROLVhhw_N4",
                              initialPosition: kInitialPosition,
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              onPlacePicked: (result) {
                                print(result.formattedAddress);
                                print(result.geometry.toJson());
                                setState(() {
                                addressLine1.text = result.formattedAddress.toString();
                                tmpLat = result.geometry.toJson()['location']['lat'];
                                tmpLong = result.geometry.toJson()['location']['lng'];
                                });
                                print(tmpLat);
                                print(tmpLong);
                                print(addressLine1.text.toString());
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      );
                    },
                    validator: (value) {
                      if (value.length == 0) {
                        return 'This field is mandatory';
                      }
                      return null;
                    },
                  )),
                  Container(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: TextFormField(
                        controller: addressLine2,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Enter address line 2 / How to reach?',
                          hintStyle: GoogleFonts.nunitoSans(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,),
                        validator: (value) {
                          if (value.length == 0) {
                            return 'This field is mandatory';
                          }
                          return null;
                        },
                      )),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      if(formKey.currentState.validate()){
                        prAddLocation.show();
                        addAddress(context);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                        child: Text(
                          "Add Location",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildLocationsListViewBuilder(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your saved locations",
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
            itemCount: addressIdsList == null ? 0 : addressIdsList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                      child: Text(addressNamesList[index],
                        style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            selectedAddressId = addressIdsList[index].toString();
                          });
                          print(selectedAddressId);
                          showAlertDialogDeleteAddress(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text("Remove this address",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 25,),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) =>EditAddress(addressIdsList[index], addressNamesList[index]),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration: Duration(milliseconds: 300),
                              )
                          ).whenComplete((){
                            getAddressList(context);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text("Update this address",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ),
        Divider(),
      ],
    );
  }

  showAlertDialogDeleteAddress(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Yes'),
      onPressed: () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Removing...", backgroundColor: Colors.black, textColor: Colors.white);
        removeAddress(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('No'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog ask = AlertDialog(
      title: Text('Remove Address'),
      content: Text('Are you sure you want to remove this address?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ask;
      },
    );
  }

}
