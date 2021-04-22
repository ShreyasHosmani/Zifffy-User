import 'dart:convert';
import 'dart:io';
import 'package:dabbawala/UI/home_page.dart';
import 'package:dabbawala/UI/forgot_password_page.dart';
import 'package:dabbawala/UI/signup_page.dart';
import 'package:dabbawala/api/cart_apis.dart';
import 'package:dabbawala/api/homepage_apis.dart';
import 'package:dabbawala/api/login.dart';
import 'package:dabbawala/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'data/login_data.dart' as login;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/login_data.dart' as login;
import 'package:dabbawala/UI/data/forgot_password_data.dart' as forgot;

FacebookLogin facebookLogin = FacebookLogin();
GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'profile',
  ],
);

Map userProfile;
bool _isLoggedIn = false;

var googleEmail;
var googleName;
var googleAuthId;
//variables for facebook
var facebookEmail;
var facebookName;
var facebookAuthId;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  CartPageApiProvider cartPageApiProvider = CartPageApiProvider();
  LoginApiProvider loginApiProvider = LoginApiProvider();
  HomePageApiProvider homePageApiProvider = HomePageApiProvider();

  _loginWithFB() async{

    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
          facebookName = profile['name'];
          facebookEmail = profile['email'];
          facebookAuthId = profile['id'];
        });
        print(facebookName);
        print(facebookEmail);
        print(facebookAuthId);
        LoginUsingFacebook(context);
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false );
        break;
    }

  }

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn().then((value) {
        login.prlogin.hide();

        setState(() {
          googleEmail = googleSignIn.currentUser.email;
          googleName = googleSignIn.currentUser.displayName;
          googleAuthId = googleSignIn.currentUser.id;
        });

        print(googleEmail.toString());
        print(googleName.toString());
        print(googleAuthId.toString());

        login.prlogin.show();
        LoginUsingGoogle(context);
        //_handleGetContact();
      });
    } catch (error) {
      print(error);
      _handleSignOut();
    }
  }

  Future<void> _handleSignOut() => googleSignIn.disconnect();

  Future<String> LoginUsingGoogle(context) async {

    String url = globals.apiUrl + "registersocial.php";

    http.post(url, body: {

      "email": googleEmail.toString(),
      "fullname": googleName.toString(),
      "authtype" : "Google",
      "fcmtoken" : userToken.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayGoogle = jsonDecode(response.body);
      print(responseArrayGoogle);

      var status = responseArrayGoogle['status'];
      var msg = responseArrayGoogle['message'];
      if(status == "200" || status == 200){

        Fluttertoast.showToast(msg: "Logged in successfully!", backgroundColor: Colors.black,
          textColor: Colors.white,);

        login.prlogin.hide().whenComplete(() async {
          Fluttertoast.showToast(msg: login.loginSuccess, backgroundColor: Colors.black, textColor: Colors.white);
          //clearFields(context);

          login.userId = responseArrayGoogle['data']['customerID'];
          storedUserId = login.userId;
          print(storedUserId);
          login.userFullName = responseArrayGoogle['data']['customerFullname'];
          print(login.userFullName);
          login.userPhone = responseArrayGoogle['data']['customerMobileno'];
          print(login.userPhone);
          login.userEmail = responseArrayGoogle['data']['customerEmail'];
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
      }
      else if(status == "401" || status == 401 || status == "402" || status == 402){
        //await pr.hide();

        googleSignIn.disconnect();

        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.black,
          textColor: Colors.white,);

        login.prlogin.hide();
      }else{
        //await pr.hide();

        googleSignIn.disconnect();

        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.black,
          textColor: Colors.white,);

        login.prlogin.hide();
      }

    });
  }

  Future<String> LoginUsingFacebook(context) async {

    String url = globals.apiUrl + "registersocial.php";

    http.post(url, body: {

      "email": facebookEmail.toString(),
      "fullname": facebookName.toString(),
      "authtype" : "Facebook",
      "fcmtoken" : userToken.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseArrayGoogle = jsonDecode(response.body);
      print(responseArrayGoogle);

      var status = responseArrayGoogle['status'];
      var msg = responseArrayGoogle['message'];
      if(status == "200" || status == 200){

        Fluttertoast.showToast(msg: "Logged in successfully!", backgroundColor: Colors.black,
          textColor: Colors.white,);

        login.prlogin.hide().whenComplete(() async {
          Fluttertoast.showToast(msg: login.loginSuccess, backgroundColor: Colors.black, textColor: Colors.white);
          //clearFields(context);

          login.userId = responseArrayGoogle['data']['customerID'];
          storedUserId = login.userId;
          print(storedUserId);
          login.userFullName = responseArrayGoogle['data']['customerFullname'];
          print(login.userFullName);
          login.userPhone = responseArrayGoogle['data']['customerMobileno'];
          print(login.userPhone);
          login.userEmail = responseArrayGoogle['data']['customerEmail'];
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
      }
      else if(status == "401" || status == 401 || status == "402" || status == 402){
        //await pr.hide();

        googleSignIn.disconnect();

        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.black,
          textColor: Colors.white,);

        login.prlogin.hide();
      }else{
        //await pr.hide();

        googleSignIn.disconnect();

        Fluttertoast.showToast(msg: msg, backgroundColor: Colors.black,
          textColor: Colors.white,);

        login.prlogin.hide();
      }

    });
  }

  @override
  void initState() {

    super.initState();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    login.prlogin = ProgressDialog(context);
    return WillPopScope(
      onWillPop: ()=>
          showDialog(
              context: context,
              builder: (context) =>
              new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit the App'),
                actions: <Widget>[
                  new GestureDetector(
                    onTap: () => exit(0),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('Yes'),
                    ),
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('No'),
                    ),
                  ),

                ],
              )

          ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: buildNewUserSignUp(context),
        ),
        body: Center(
          child: Form(
              key: _formKey,
              child: buildLoginBox(context)),
        ),
      ),
    );
  }

  Widget buildLoginBox(BuildContext context){
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            //border: Border.all(color: Colors.grey.shade400),
            color: Colors.white
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                buildDabbawalaText(context),
                SizedBox(height: 30,),
                buildPhoneNoText(context),
                buildPhoneNumberField(context),
                SizedBox(height: 10,),
                buildPasswordText(context),
                buildPasswordField(context),
                SizedBox(height: 40,),
                buildLoginButton(context),
                SizedBox(height:20,),
                buildForgetPassword(context),
                SizedBox(height:30,),
                buildOrText(context),
                buildSocialLoginsRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDabbawalaText(BuildContext context){
    return GestureDetector(
      onTap: (){
        print(DateTime.now().millisecondsSinceEpoch.toString());
      },
      child: Container(
        color: Colors.white,
        child: Center(
          child: Text('Zifffy',
            textScaleFactor: 1,
            style: GoogleFonts.nunitoSans(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Colors.black,
          ),),
        ),
      ),
    );
  }

  Widget buildPhoneNoText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Text('Email Id',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildPhoneNumberField(BuildContext context){
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: login.emailController,
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Email',
              hintStyle: GoogleFonts.nunitoSans(
                  color: Colors.black,
                      fontSize: 14,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Icon(Icons.email,color: Colors.grey,),),
          validator: (value) {
            if (value.length == 0) {
              return login.phoneNumberCompulsory;
            } else if (value.length < 10) {
              return login.invalidPhoneNumber;
            }
            return null;
          },
        ));
  }

  Widget buildPasswordText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 5),
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Text('Password',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.blue[900]
        ),),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context){
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextFormField(
          controller: login.passwordController,
          style: TextStyle(color: Colors.black),
          obscureText: login.obscureText,
          cursorColor: Colors.black,
          autofocus: false,
          decoration: InputDecoration(
              hintText: 'Enter Password',
              hintStyle: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 14,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: login.obscureText == true ? GestureDetector(
                  onTap: (){
                    setState(() {
                      login.obscureText = false;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)) : GestureDetector(
                  onTap: (){
                    setState(() {
                      login.obscureText = true;
                    });
                  },
                  child: Icon(Icons.visibility,color: Colors.grey,)),),
          validator: (value) {
            if (value.length == 0) {
              return 'Password is compulsory';
            } else if (value.length < 6) {
            }
            return null;
          },
        ));
  }

  Widget buildLoginButton(BuildContext context){
    return Container(
        height: 45,
        width: 280,
        padding: EdgeInsets.only(left: 20,right: 20),
        child: RaisedButton(
          child: Text("Login",textScaleFactor: 1,
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                ),
              )),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              login.prlogin.show();
              loginApiProvider.signIn(context);
            }
          },
          color: Colors.blue[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
        ));
  }

  Widget buildForgetPassword(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => ForgotPasswordPage(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 300),
              )
          );
        },
        child: Center(
          child: Text('Forgot Password',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.blue[900]
          ),),
        ),
      ),
    );
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
            login.prlogin.show();
            _loginWithFB();
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
            login.prlogin.show();
            _handleSignIn();
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
        /*
        SizedBox(width: 25,),
        InkWell(
          onTap: (){
            login.prlogin.show();
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

         */
      ],
    );
  }

  Widget buildNewUserSignUp(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      color: Colors.white,
      child: GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => SignUpPage(),
                transitionsBuilder: (c, anim, a2, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: Duration(milliseconds: 300),
              )
          );
        },
        child: Center(
          child: Text('New User ? Sign Up',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black
          ),),
        ),
      ),
    );
  }
}
