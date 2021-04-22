import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

TextEditingController nameController = TextEditingController();
ProgressDialog prChangeName;
final formKey = GlobalKey<FormState>();

class ChangeName extends StatefulWidget {
  final name;
  ChangeName(this.name) : super();
  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {

  Future<String> changeName(context) async {

    String url = globals.apiUrl + "changecustomername.php";

    http.post(url, body: {

      "customerID": storedUserId.toString(),
      "fullname" : nameController.text.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayChangeName = jsonDecode(response.body);
      print(responseArrayChangeName);

      var responseArrayChangeNameMsg = responseArrayChangeName['message'].toString();
      print(responseArrayChangeNameMsg);

      if(statusCode == 200){
        if(responseArrayChangeNameMsg == "Login Successfull"){

          prChangeName.hide().whenComplete((){
            Fluttertoast.showToast(msg: "Saved", backgroundColor: Colors.black, textColor: Colors.white);
            Navigator.of(context).pop();
          });

        }else{
          prChangeName.hide();
          Fluttertoast.showToast(msg: "Some error occured!", backgroundColor: Colors.black, textColor: Colors.white);
        }
      }

    });
    // SharedPreferences prefs = await SharedPreferences.getInstance();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    prChangeName = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: buildSaveButton(context),
      ),
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Form(
            key: formKey,
            child: buildNameField(context)),
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
      title: Text('Change Name',style: GoogleFonts.nunitoSans(
        color: Colors.black,
        fontSize: 20,
      ),),
    );
  }

  Widget buildNameField(BuildContext context){
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: nameController,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Enter name',
            hintStyle: GoogleFonts.nunitoSans(
              color: Colors.black,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Icon(Icons.person,color: Colors.grey.shade300,),),
          validator: (value) {
            if (value.isEmpty) {
              return 'Name cannot be empty!';
            }
            return null;
          },
        ));
  }

  Widget buildSaveButton(BuildContext context){
    return InkWell(
      onTap: (){
        if(formKey.currentState.validate()){
          prChangeName.show();
          changeName(context);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.4),blurRadius: 3,
            )],
            color: Colors.blue[800]
        ),
        child: Center(
          child: Text('Save',style: GoogleFonts.nunitoSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),),
        ),
      ),
    );
  }

}
