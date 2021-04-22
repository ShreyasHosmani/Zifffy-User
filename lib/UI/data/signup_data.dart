library main_app.loginglobals;
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';

final formKey = GlobalKey<FormState>();

bool obscureText = true;
var emailController = new TextEditingController();
var passwordController = new TextEditingController();
var responseArraySignUp;
var signUpResponse;
var signUpMessage;
ProgressDialog prSignUp;
String signUpSuccessful = 'Registered Successfully';
String signUpEmailAlreadyExits = 'User Already Exists';
var fullNameController = new TextEditingController();
var phoneController = new TextEditingController();
String unableToRegister = 'Unable to Register';



