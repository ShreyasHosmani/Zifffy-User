import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';

bool obscureTextOne = true;
bool obscureTextTwo = true;
bool obscureTextThree = true;

final formKey = GlobalKey<FormState>();

var oldPasswordController = new TextEditingController();
var newPasswordController = new TextEditingController();
var confirmNewPasswordController = new TextEditingController();


var responseArrayResetPassword;
var resetPasswordResponse;
var resetPasswordMessage;
ProgressDialog prResetPassword;

var resetComplete = 'Password Changed';
var currentPasswordError = 'Wrong Current Password';



