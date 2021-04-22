    import 'package:dabbawala/api/resetpassword.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dabbawala/UI/data/account_data.dart' as acc;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog prResetPassword;

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

ResetPasswordApiProvider resetPasswordApiProvider = ResetPasswordApiProvider();

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  Future<String> resetPassword(context) async {

    String url = globals.apiUrl + "resetpassword.php";

    http.post(url, body: {

      "customerID": storedUserId.toString(),
      "customercurrentpassword" : acc.oldPasswordController.text.toString(),
      "customernewpassword" : acc.newPasswordController.text.toString(),

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
        if(responseArrayChangeNameMsg == "Successfully"){

          prResetPassword.hide().whenComplete((){
            Fluttertoast.showToast(msg: "Password changed", backgroundColor: Colors.black, textColor: Colors.white);
            Navigator.of(context).pop();
          });

        }else{
          prResetPassword.hide();
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
    acc.oldPasswordController.clear();
    acc.newPasswordController.clear();
    acc.confirmNewPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    prResetPassword = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: buildResetButton(context),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: acc.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                buildCurrentPasswordText(context),
                buildCurrentPasswordField(context),
                SizedBox(height: 20,),
                buildNewPasswordText(context),
                buildNewPasswordField(context),
                SizedBox(height: 20,),
                buildConfirmNewPasswordText(context),
                buildConfirmNewPasswordField(context),
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
      title: Text('Reset Password',style: GoogleFonts.nunitoSans(
        color: Colors.black,
        fontSize: 20,
      ),),
    );
  }

  Widget buildCurrentPasswordText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text('Current Password',style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black
        ),),
      ),
    );
  }

  Widget buildCurrentPasswordField(BuildContext context){
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: acc.oldPasswordController,
          style: TextStyle(color: Colors.black),
          obscureText: acc.obscureTextOne,
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Old Password',
              hintStyle: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 14,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: acc.obscureTextOne == true ? GestureDetector(
                  onTap: (){
                    setState(() {
                      acc.obscureTextOne = false;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)) : GestureDetector(
                  onTap: (){
                    setState(() {
                      acc.obscureTextOne = true;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)),),
          validator: (value) {
            if (value.length == 0) {
              return 'Password is compulsory';
            } else if (value.length < 6) {
              return 'Password must be more than 6 charecters!';
            }
            return null;
          },
        ));
  }

  Widget buildNewPasswordText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text('New Password',style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black
        ),),
      ),
    );
  }

  Widget buildNewPasswordField(BuildContext context){
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: acc.newPasswordController,
          style: TextStyle(color: Colors.black),
          obscureText: acc.obscureTextTwo,
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'New Password',
              hintStyle: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 14,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: acc.obscureTextTwo == true ? GestureDetector(
                  onTap: (){
                    setState(() {
                      acc.obscureTextTwo = false;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)) : GestureDetector(
                  onTap: (){
                    setState(() {
                      acc.obscureTextTwo = true;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)),),
          validator: (value) {
            if (value.length == 0) {
              return 'Password is compulsory';
            } else if (value.length < 6) {
              return 'Password must be more than 6 charecters!';
            }
            return null;
          },
        ));
  }

  Widget buildConfirmNewPasswordText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text('Confirm Password',style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black
        ),),
      ),
    );
  }

  Widget buildConfirmNewPasswordField(BuildContext context){
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: acc.confirmNewPasswordController,
          style: TextStyle(color: Colors.black),
          obscureText: acc.obscureTextThree,
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Confirm Password',
              hintStyle: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 14,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Icon(Icons.lock_outline),),
          validator: (value) {
            if (value.length == 0) {
              return 'Password is compulsory';
            } else if (value.length < 6) {
              return 'Password must be more than 6 charecters';
            }
            else if (acc.newPasswordController.text.toString() != acc.confirmNewPasswordController.text.toString()){
              return 'New and confirm passwords do not match';
            }
            return null;
          },
        ));
  }

  Widget buildResetButton(BuildContext context){
    return Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10,right: 10),
        child: RaisedButton(
          child: Text("Reset",
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              )),
          onPressed: () {
            if (acc.formKey.currentState.validate()) {
              prResetPassword.show();
              resetPassword(context);
            }
    },
            color: Colors.blue[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
        ));
  }

  void clearFields(BuildContext context){
    acc.oldPasswordController.clear();
    acc.newPasswordController.clear();
    acc.confirmNewPasswordController.clear();


  }

}
