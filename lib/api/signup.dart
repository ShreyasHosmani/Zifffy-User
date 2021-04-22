import 'dart:convert';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:dabbawala/UI/data/signup_data.dart' as signup;


class SignUpApiProvider {

  Future<String> signUp(context) async {

    print(signup.fullNameController.text.toString());
    print(signup.phoneController.text.toString());
    print(signup.emailController.text.toString());
    print(signup.passwordController.text.toString());

    String url = globals.apiUrl + "register.php";

    http.post(url, body: {

      "fullname" : signup.fullNameController.text.toString(),
      "phone" : signup.phoneController.text,
      "fcmtoken" : userToken.toString(),
      "email": signup.emailController.text.toString(),
      "password" : signup.passwordController.text.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      signup.responseArraySignUp = jsonDecode(response.body);
      print(signup.responseArraySignUp);
      signup.signUpResponse = signup.responseArraySignUp['status'].toString();
      signup.signUpMessage = signup.responseArraySignUp['message'].toString();
      if(statusCode == 200){
        if(signup.signUpMessage == "Registered Successfull"){
          signup.prSignUp.hide().whenComplete((){
            Fluttertoast.showToast(msg: signup.signUpSuccessful, backgroundColor: Colors.black, textColor: Colors.white);
            clearFields(context);
            Navigator.of(context).pop();
          });
        }else if (signup.signUpMessage == "User already exist with this email"){
          signup.prSignUp.hide().whenComplete((){
            Fluttertoast.showToast(msg: signup.signUpEmailAlreadyExits, backgroundColor: Colors.black, textColor: Colors.white);
          });
        }
        else if(signup.signUpMessage == "Error Adding Customer"){
          signup.prSignUp.hide().whenComplete((){
            Fluttertoast.showToast(msg: signup.signUpEmailAlreadyExits, backgroundColor: Colors.black, textColor: Colors.white);
          });
        }


      }
      else if(statusCode == 400){
        signup.prSignUp.hide().whenComplete((){
          Fluttertoast.showToast(msg: signup.unableToRegister, backgroundColor: Colors.black, textColor: Colors.white);
        });
      }


    });

  }

  void clearFields(BuildContext context){
    signup.emailController.clear();
    signup.fullNameController.clear();
    signup.passwordController.clear();
    signup.phoneController.clear();
  }

}