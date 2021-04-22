library main_app.loginglobals;
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';

final formKey = GlobalKey<FormState>();

var emailController = new TextEditingController();
var responseArrayForgotPassword;
var forgotPasswordResponse;
var forgotPasswordMessage;
ProgressDialog prForgotPassword;
String emailSent = 'Email Sent';


