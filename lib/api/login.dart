import 'dart:convert';
import 'package:dabbawala/UI/Widgets/bottom_nav_bar.dart';
import 'package:dabbawala/UI/home_page.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/login_data.dart' as login;
import 'package:dabbawala/UI/data/forgot_password_data.dart' as forgot;

class LoginApiProvider {

  Future<String> signIn(context) async {

    print(login.emailController.text.toString());
    print(login.passwordController.text.toString());

    String url = globals.apiUrl + "login.php";

    http.post(url, body: {

      "email": login.emailController.text.trim(),
      "password" : login.passwordController.text.trim(),
      "fcmtoken" : userToken.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      login.responseArrayLogin = jsonDecode(response.body);
      print(login.responseArrayLogin);
      login.loginResponse = login.responseArrayLogin['status'].toString();
      login.loginMessage = login.responseArrayLogin['message'].toString();
      if(statusCode == 200){
        if(login.loginMessage == "Login Successfull"){
          login.prlogin.hide().whenComplete(() async {
            Fluttertoast.showToast(msg: login.loginSuccess, backgroundColor: Colors.black, textColor: Colors.white);
            clearFields(context);

            login.userId = login.responseArrayLogin['data']['customerID'];
            storedUserId = login.userId;
            print(storedUserId);
            login.userFullName = login.responseArrayLogin['data']['customerFullname'];
            print(login.userFullName);
            login.userPhone = login.responseArrayLogin['data']['customerMobileno'];
            print(login.userPhone);
            login.userEmail = login.responseArrayLogin['data']['customerEmail'];
            print(login.userEmail);

            // login.userIDResponse = login.responseArrayLogin['data']['vendorID'];
            // print(login.userIDResponse);

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('userId',login.userId);
            prefs.setString('userName', login.userFullName);
            prefs.setString('userPhone', login.userPhone);
            prefs.setString('userEmail', login.userEmail);

            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) =>BottomNavBar(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                )
            );

          });

        }else{
          if(login.loginMessage == 'User does not exist with this email'){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.invalidUser, backgroundColor: Colors.black, textColor: Colors.white);
            });
          }
          else if(login.loginMessage == 'Password Incorrect with this email'){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.invalidPassword, backgroundColor: Colors.black, textColor: Colors.white);
            });
          }
          else if(login.loginMessage == 'Unable to login. Data is incomplete'){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.dataIncomplete, backgroundColor: Colors.black, textColor: Colors.white);
            });
          }

        }
      }

    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId',login.userId);
    prefs.setString('userName', login.userFullName);
    prefs.setString('userPhone', login.userPhone);
    prefs.setString('userEmail', login.userEmail);
  }

  Future<String> forgotPassword(context) async {

    String url = globals.apiUrl + "forgotpassword.php";

    http.post(url, body: {

      "customerresetemail": forgot.emailController.text,

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }
      forgot.responseArrayForgotPassword = jsonDecode(response.body);
      print(forgot.responseArrayForgotPassword);
      forgot.forgotPasswordResponse = forgot.responseArrayForgotPassword['status'].toString();
      forgot.forgotPasswordMessage = forgot.responseArrayForgotPassword['message'].toString();
      if(statusCode == 200){
        if(forgot.forgotPasswordMessage == "Successfully"){
          forgot.prForgotPassword.hide().whenComplete((){
            Fluttertoast.showToast(msg: forgot.emailSent, backgroundColor: Colors.black, textColor: Colors.white);
            clearEmail(context);
            Navigator.of(context).pop();


          });
        }else{
          if(forgot.forgotPasswordMessage == "User does not exist with this email"){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.invalidUser, backgroundColor: Colors.black, textColor: Colors.white);
            });
          }
          else if(forgot.forgotPasswordMessage == 'Unable to add reset data'){
            login.prlogin.hide().whenComplete((){
              print('Hello');
              Fluttertoast.showToast(msg: login.invalidPassword, backgroundColor: Colors.black, textColor: Colors.white);
            });
          }
        }
      }

    });
    // SharedPreferences prefs = await SharedPreferences.getInstance();

  }

  void clearFields(BuildContext context){
    login.emailController.clear();
    login.passwordController.clear();
  }

  void clearEmail(BuildContext context){
    forgot.emailController.clear();
  }

}