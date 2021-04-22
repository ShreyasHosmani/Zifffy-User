import 'package:dabbawala/api/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'data/signup_data.dart' as signup;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  SignUpApiProvider signUpApiProvider  = SignUpApiProvider();

  @override
  Widget build(BuildContext context) {
    signup.prSignUp = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: signup.formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/10,),
                  buildDabbawalaText(context),
                  SizedBox(height: 20,),
                  buildFullNameText(context),
                  buildFullNameField(context),
                  SizedBox(height: 5,),
                  buildEmailText(context),
                  buildEmailField(context),
                  SizedBox(height: 5,),
                  buildPasswordText(context),
                  buildPasswordField(context),
                  SizedBox(height: 5,),
                  buildPhoneNumText(context),
                  buildPhoneNumField(context),
                  SizedBox(height: 50,),
                  buildSignUpButton(context),
//                  SizedBox(height: 40,),
//                  buildOrText(context),
//                  buildSocialLoginsRow(context),
//                  SizedBox(height: 40,),
                ],
              ),
            ),
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
        child: Text('Sign Up',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: Colors.black,
        ),),
      ),
    );
  }

  Widget buildFullNameText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text('Name',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildFullNameField(BuildContext context){
    return  Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: signup.fullNameController,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Full Name',
              hintStyle: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 14,
              ),
              prefixIcon: Icon(Icons.person,color: Colors.grey,),
              floatingLabelBehavior: FloatingLabelBehavior.always,),
          validator: (value) {
            if (value.isEmpty) {
              return  'Name is compulsory';
            }
            return null;
          },

        ));
  }

  Widget buildEmailText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 5),
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
          controller: signup.emailController,
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
              ? 'Email is compulsory'
              : null,

        ));
  }

  Widget buildPasswordText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text('Password',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context){
    return  Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: signup.passwordController,
          obscureText: signup.obscureText,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Password',
              hintStyle: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 14,
              ),
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
              suffixIcon: signup.obscureText == true ? GestureDetector(
                  onTap: (){
                    setState(() {
                      signup.obscureText = false;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)) : GestureDetector(
                  onTap: (){
                    setState(() {
                      signup.obscureText = true;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)),
              floatingLabelBehavior: FloatingLabelBehavior.always,),
          validator: (value) {
            if (value.length == 0) {
              return 'Password is compulsory';
            } else if (value.length < 6) {
              return 'Minimum 6 characters';
            }
            return null;
          },

        ));
  }

  Widget buildPhoneNumText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text('Phone Number',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildPhoneNumField(BuildContext context){
    return  Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
            keyboardType: TextInputType.number,
          controller: signup.phoneController,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Phone Number',
              hintStyle: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 14,
              ),
              prefixIcon: Icon(Icons.call,color: Colors.grey,),
              floatingLabelBehavior: FloatingLabelBehavior.always,),
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

  Widget buildSignUpButton(BuildContext context){
    return Container(
        height: 45,
        width: 280,
        padding: EdgeInsets.only(left: 20,right: 20),
        child: RaisedButton(
          child: Text("Register",textScaleFactor: 1,
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              )),
          onPressed: () {
        if(signup.formKey.currentState.validate()){
          signup.prSignUp.show();
          signUpApiProvider.signUp(context);

        }
          },
          color: Colors.blue[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
        ));
  }

  Widget buildOrText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 0, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
          child: Text('or',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: Colors.grey,
          ),),
        ),
      ),
    );
  }

  buildSocialLoginsRow(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            signup.prSignUp.show();
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/images/faceb.png"),
              ),
            ),
          ),
        ),
        SizedBox(width: 25,),
        InkWell(
          onTap: (){
            signup.prSignUp.show();
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.blue),
            ),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/search.png"),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 25,),
        InkWell(
          onTap: (){
            signup.prSignUp.show();
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/images/apple.png"),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
