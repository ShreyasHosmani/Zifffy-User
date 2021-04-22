import 'package:dabbawala/UI/change_contact.dart';
import 'package:dabbawala/UI/change_name.dart';
import 'package:dabbawala/UI/map_page.dart';
import 'package:dabbawala/UI/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  final name;
  final email;
  final phone;
  EditProfilePage(this.name, this.email, this.phone) : super();
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          buildEditName(context),
          SizedBox(height: 10,),
          buildEditContact(context),
          SizedBox(height: 10,),
          buildResetPassword(context),
          SizedBox(height: 10,),
          buildChangeLocation(context)
        ],
      ),
    );
  }
  
  Widget buildAppBar(BuildContext context){
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 1,
      leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_outlined,color: Colors.black, size: 20,)),
      title: Text('Edit Profile',style: GoogleFonts.nunitoSans(
        color: Colors.black,
        fontSize: 20,
      ),),
    );
  }

  Widget buildEditName(BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => ChangeName(widget.name),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        height: 45,
        child: Row(
          children: [
            SizedBox(width: 20,),
            Icon(Icons.person,color: Colors.grey,),
            SizedBox(width: 20),
            Text('Change Name',style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15
            ),)
          ],
        ),
      ),
    );
  }

  Widget buildEditContact(BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => ChangeContact(widget.phone),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        height: 45,
        child: Row(
          children: [
            SizedBox(width: 20,),
            Icon(Icons.call,color: Colors.grey,),
            SizedBox(width: 20),
            Text('Change Contact Nubmer',style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15
            ),)
          ],
        ),
      ),
    );
  }

  Widget buildResetPassword(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>ResetPasswordPage(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        height: 45,
        child: Row(
          children: [
            SizedBox(width: 20,),
            Icon(Icons.lock_open,color: Colors.grey,),
            SizedBox(width: 20),
            Text('Reset Password',style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15
            ),)
          ],
        ),
      ),
    );
  }

  Widget buildChangeLocation(BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>MapPage(),
              transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 300),
            )
        );
      },
      child: Container(
        height: 45,
        child: Row(
          children: [
            SizedBox(width: 20,),
            Icon(Icons.location_on,color: Colors.grey,),
            SizedBox(width: 20),
            Text('Change Location',style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15
            ),)
          ],
        ),
      ),
    );
  }


}
