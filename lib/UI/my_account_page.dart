 import 'dart:io';
import 'package:dabbawala/UI/edit_profile_page.dart';
import 'package:dabbawala/UI/login_page.dart';
import 'package:dabbawala/UI/my_past_orders.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/cart_data.dart' as cart;
import 'dart:convert';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;
import 'data/home_data.dart' as home;

var tempName;
var tempEmail;
var tempPhone;
ProgressDialog prLogOut;

final Email email = Email(
  body: 'Type your queries here...',
  subject: 'Query',
  recipients: ['support@zifffy.com'],
  cc: [''],
  //bcc: ['bcc@example.com'],
  //attachmentPaths: ['/path/to/attachment.zip'],
  isHTML: false,
);

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {

  Future<String> getProfile(context) async {

    String url = globals.apiUrl + "getprofile.php";

    http.post(url, body: {

      "customerID" : storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetProfile = jsonDecode(response.body);
      print(responseArrayGetProfile);

      var responseArrayGetProfileMsg = responseArrayGetProfile['message'].toString();
      print(responseArrayGetProfileMsg);

      if(statusCode == 200){
        if(responseArrayGetProfileMsg == "Item Found"){

          setState(() {
            tempName = responseArrayGetProfile['data']['customerFullname'].toString();
            tempEmail = responseArrayGetProfile['data']['customerEmail'].toString();
            tempPhone = responseArrayGetProfile['data']['customerMobileno'].toString();
          });
          print(tempName);
          print(tempEmail);
          print(tempPhone);

        }else{

          Fluttertoast.showToast(msg: 'Some error occured', backgroundColor: Colors.black, textColor: Colors.white);

        }
      }

    }

    );

  }

  Future<String> deleteFcmToken(context) async {

    String url = globals.apiUrl + "deletefcmtoken.php";

    http.post(url, body: {

      "customerID" : storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayDeleteFcmToken = jsonDecode(response.body);
      print(responseArrayDeleteFcmToken);

      var responseArrayDeleteFcmTokenMsg = responseArrayDeleteFcmToken['message'].toString();
      print(responseArrayDeleteFcmTokenMsg);

      if(responseArrayDeleteFcmTokenMsg == "Successfully"){
        prLogOut.hide();
        Fluttertoast.showToast(msg: "Logged out", backgroundColor: Colors.black, textColor: Colors.white);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => LoginPage(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
        clearUser();
      }else{
        prLogOut.hide();
        Fluttertoast.showToast(msg: 'Please check your network connection!',backgroundColor: Colors.black, textColor: Colors.white);
      }

    });
  }

  @override
  initState() {
    super.initState();
    getProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    prLogOut = ProgressDialog(context);
    return WillPopScope(
      onWillPop: () => showDialog(
          context: context,
          builder: (context) => new AlertDialog(
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
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('No'),
                    ),
                  ),
                ],
              )),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: tempName == null || tempName == "null" ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildProfileContainer(context),
              buildAccountOptions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileContainer(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                ),
                child: Text(
                 tempName,textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                    tempPhone.toString() == null || tempPhone.toString() == "null" ? "" + tempEmail.toString() :tempPhone.toString() + " - " + tempEmail.toString(),textScaleFactor: 1,
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => EditProfilePage(tempName, tempEmail, tempPhone),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 300),
                      )).whenComplete((){
                        getProfile(context);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    'Edit profile',textScaleFactor: 1,
                    style: GoogleFonts.nunitoSans(
                      color: Colors.blue,
                      letterSpacing: 0,
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Divider(),
            ],
          ),
        ));
  }

  Widget buildAccountOptions(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1,
      height: MediaQuery.of(context).size.height / 1,
      decoration: BoxDecoration(
          //borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => MyPastOrders(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  )
              );
            },
            child: Container(
              height: 45,
              child: Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                elevation: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'My Past Orders',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
//          Container(
//            height: 45,
//            child: Card(
//              margin: EdgeInsets.all(0),
//              elevation: 0,
//              child: Row(
//                children: [
//                  SizedBox(
//                    width: 20,
//                  ),
//                  Icon(
//                    Icons.attach_money,
//                    color: Colors.grey,
//                  ),
//                  SizedBox(width: 20),
//                  Text(
//                    'Refer and Earn',textScaleFactor: 1,
//                    style: GoogleFonts.nunitoSans(
//                        color: Colors.black,
//                        fontWeight: FontWeight.w400,
//                        fontSize: 15),
//                  )
//                ],
//              ),
//            ),
//          ),
          InkWell(
            onTap: (){
              showAlertDialogHelpAndSupport(context);
            },
            child: Container(
              height: 45,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.headset_mic,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Help and Support',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              launch("https://drive.google.com/file/d/1CLXus_ythFAJiiA1cWx59Mtavjh4rPKG/view?usp=sharing");
            },
            child: Container(
              height: 45,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.wysiwyg,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Terms and Conditions',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              launch("https://drive.google.com/file/d/11B0tOQ-xClPlPeJ-W6pGoWUZTVKTXRQn/view?usp=sharing");
            },
            child: Container(
              height: 45,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.redo,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Refund Policy',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              launch("https://drive.google.com/file/d/1NiNbT5XAfWYcsqJKGoLCkjDtFPRo6upR/view?usp=sharing");
            },
            child: Container(
              height: 45,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.privacy_tip,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Privacy Policy',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              showAlertDialogAboutUs(context);
            },
            child: Container(
              height: 45,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.announcement,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'About Us',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showAlertDialogLogout(context);
            },
            child: Container(
              height: 45,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Sign Out',textScaleFactor: 1,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getName() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    home.userNameResponse = prefs.getString('userName');
    setState(() {
      tempName = home.userNameResponse;
    });
    print(home.userNameResponse);
  }

  void getEmail() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    home.userEmailResponse = prefs.getString('userEmail');
    setState(() {
      tempEmail= home.userEmailResponse;
    });
    print(home.userEmailResponse);
  }

  void getPhone() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    home.userPhoneResponse = prefs.getString('userPhone');
    setState(() {
      tempPhone = home.userPhoneResponse;
    });
    print(home.userPhoneResponse);
  }

  clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    googleSignIn.signOut();
    facebookLogin.logOut();
  }

  showAlertDialogLogout(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Yes'),
      onPressed: () {
        prLogOut.show();
        deleteFcmToken(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('No'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog ask = AlertDialog(
      title: Text('Sign Out'),
      content: Text('Are you sure?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ask;
      },
    );
  }

  showAlertDialogAboutUs(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Yes'),
      onPressed: () {
        prLogOut.show();
        deleteFcmToken(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('Okay'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog ask = AlertDialog(
      title: Text('About Us',
        style: GoogleFonts.nunitoSans(),
      ),
      content: Text('Zifffy is a product by 1024X Innovation Private limited with headquarters at No. 10bm/202, 100ft Road, HRBR Layout, Bangalore 560043.',
        style: GoogleFonts.nunitoSans(),
      ),
      actions: [
        //cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ask;
      },
    );
  }

  showAlertDialogHelpAndSupport(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Yes'),
      onPressed: () {
        prLogOut.show();
        deleteFcmToken(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('Okay'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog ask = AlertDialog(
      title: Text('Help & Support',
        style: GoogleFonts.nunitoSans(),
      ),
      content: Container(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                launch('tel:8884089000');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Phone Support:',
                    style: GoogleFonts.nunitoSans(),
                  ),
                  SizedBox(width: 10,),
                  Text('8884089000',
                    style: GoogleFonts.nunitoSans(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: () async {
                await FlutterEmailSender.send(email);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('E-mail:',
                    style: GoogleFonts.nunitoSans(),
                  ),
                  SizedBox(width: 10,),
                  Text('support@zifffy.com',
                    style: GoogleFonts.nunitoSans(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                launch('https://www.zifffy.com');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Website:',
                    style: GoogleFonts.nunitoSans(),
                  ),
                  SizedBox(width: 10,),
                  Text('www.zifffy.com',
                    style: GoogleFonts.nunitoSans(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        //cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ask;
      },
    );
  }
}
