library main_app.loginglobals;
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';

String invalidPhoneNumber = 'Invalid Phone Number';
String phoneNumberCompulsory = 'Phone Number is Compulsory';
String invalidPassword = 'Invalid Password';

bool obscureText = true;

var emailController = new TextEditingController();
var passwordController = new TextEditingController();

var responseArrayLogin;
var loginResponse;
var loginMessage;
ProgressDialog prlogin;
var loginSuccess = 'Login Successful';
var invalidUser = 'Invalid User';
var dataIncomplete = 'Data Incomplete';
var userId;
var userFullName;
var userEmail;
var userPhone;


