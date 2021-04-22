import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog prUpdateLocation;
TextEditingController addressLine11 = TextEditingController();
TextEditingController addressLine22 = TextEditingController();
final formKey = GlobalKey<FormState>();

var addressSplit;
var addressLineOne;
var addressLineTwo;

class EditAddress extends StatefulWidget {
  final id;
  final address;
  EditAddress(this.id, this.address) : super();
  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {

  Future<String> updateAddress(context) async {

    print(widget.id);
    print(addressLine11.text.toString()+" - Address line 2 / Instructions : "+addressLine22.text.toString());

    String url = globals.apiUrl + "updatecustomeraddress.php";

    http.post(url, body: {

      "addressID" : widget.id.toString(),
      "address" : addressLine11.text.toString()+" - Address line 2 / Instructions : "+addressLine22.text.toString(),

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

          prUpdateLocation.hide().whenComplete((){
            Fluttertoast.showToast(msg: "Saved", backgroundColor: Colors.black, textColor: Colors.white);
            addressLine11.clear();
            addressLine22.clear();
            Navigator.of(context).pop();
          });

        }else{

          prUpdateLocation.hide().whenComplete((){
            Fluttertoast.showToast(msg: "Some error occured!", backgroundColor: Colors.black, textColor: Colors.white);
            Navigator.of(context).pop();
          });

        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressSplit = null;
    int idx = widget.address.indexOf(":");
    int idx2 = widget.address.indexOf("- Address line 2");
    if(widget.address.contains('/')){
      addressLineOne = widget.address.substring(0,idx2).trim();
      print(addressLineOne);
      addressLineTwo = widget.address.substring(idx+1).trim();
      print(addressLineTwo);
      addressLine11 = TextEditingController(text: addressLineOne);
      addressLine22 = TextEditingController(text: addressLineTwo);
    }else{
      addressLine11 = TextEditingController(text: widget.address);
    }
  }

  @override
  Widget build(BuildContext context) {
    prUpdateLocation = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text("Update location",
                style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),SizedBox(height: 20,),
              Container(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: TextFormField(
                    controller: addressLine11,
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
                    controller: addressLine22,
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
                    prUpdateLocation.show();
                    updateAddress(context);
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
    );
  }

  Widget buildAppBar(BuildContext context){
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 1,
      leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_outlined,color: Colors.black, size: 20,)),
      title: Text('Update Address',style: GoogleFonts.nunitoSans(
        color: Colors.black,
        fontSize: 20,
      ),),
    );
  }



}
