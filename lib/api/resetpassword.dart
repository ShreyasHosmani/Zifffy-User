import 'dart:convert';
import 'package:dabbawala/UI/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/login_data.dart' as login;
import 'package:dabbawala/UI/data/account_data.dart' as acc;

class ResetPasswordApiProvider {

  Future<String> resetPassword(context) async {

    String url = globals.apiUrl + "resetpassword.php";

    http.post(url, body: {

      "customerID":'1' ,
      "customercurrentpassword": acc.oldPasswordController.text.toString(),
      "customernewpassword":acc.confirmNewPasswordController.text.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      acc.responseArrayResetPassword = jsonDecode(response.body);
      print(acc.responseArrayResetPassword);
      acc.resetPasswordResponse = acc.responseArrayResetPassword['status'].toString();
      acc.resetPasswordMessage = acc.responseArrayResetPassword['message'].toString();
      if(statusCode == 200){
        if(acc.resetPasswordMessage == "Successfully"){
          acc.prResetPassword.hide().whenComplete((){
            Fluttertoast.showToast(msg: acc.resetComplete
            );
            clearFields(context);
            Navigator.of(context).pop();


          });
        }else{
          if(acc.resetPasswordMessage == "Current Password Does Not Match"){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.invalidUser,);
            });
          }
          else if(acc.resetPasswordMessage == 'No customer found using this vendor id'){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.invalidPassword,);
            });
          }
        }
      }
      else if(acc.resetPasswordMessage == "Unable to reset password. Data is incomplete"){

      }

    });

  }




  void clearFields(BuildContext context){
    acc.oldPasswordController.clear();
    acc.newPasswordController.clear();
    acc.confirmNewPasswordController.clear();


  }

}