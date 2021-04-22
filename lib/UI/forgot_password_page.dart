import 'package:dabbawala/api/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'data/forgot_password_data.dart' as forgot;

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  LoginApiProvider loginApiProvider = LoginApiProvider();

  @override
  Widget build(BuildContext context) {
    forgot.prForgotPassword = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Container(
            child: Form(
              key: forgot.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  buildDabbawalaText(context),
                  SizedBox(height: 40,),
                  buildEmailField(context),
                  SizedBox(height: 40,),
                  buildForgotPasswordButton(context),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget buildDabbawalaText(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: Text('Forgot Password',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: Colors.black,
        ),),
      ),
    );
  }

  Widget buildEmailText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text('Email',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildEmailField(BuildContext context){
    return  Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: forgot.emailController,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Email',
              hintStyle: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 14,
              ),
              prefixIcon: Icon(Icons.email,color: Colors.grey,),
              floatingLabelBehavior: FloatingLabelBehavior.always,),
          validator: (val) =>
          !EmailValidator.validate(val, true)
              ? 'Not a valid email'
              : null,

        ));
  }

  Widget buildPhoneNumText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/23,
        color: Colors.white,
        child: Text('Phone Number',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildPhoneNumField(BuildContext context){
    return  Container(
        height: MediaQuery.of(context).size.height/10,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Phone Number',
              hintStyle: TextStyle(
                  color: Colors.black
              ),
              suffixIcon: Icon(Icons.call,color: Colors.deepPurple[800],),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 45, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(55),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 10,
              ),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(55),
                  borderSide: BorderSide(color:Colors.black),
                  gapPadding: 10
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color:Colors.black),
                  gapPadding: 10
              )),
          validator: (value) {
            if (value.length == 0) {
              return 'Phone number is compulsory';
            } else if (value.length < 10) {
              return 'Invalid Phone Number';
            }
            return null;

          },

        ));
  }

  Widget buildForgotPasswordButton(BuildContext context){
    return Container(
        height: 45,
        width: 180,
        padding: EdgeInsets.only(left: 20,right: 20),
        child: RaisedButton(
          child: Text("Send",textScaleFactor: 1,
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              )),
          onPressed: () {
            if (forgot.formKey.currentState.validate()){
              forgot.prForgotPassword.show();
              loginApiProvider.forgotPassword(context);
            }
          },
          color: Colors.blue[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
        ));
  }
}
