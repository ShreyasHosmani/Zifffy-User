import 'package:dabbawala/UI/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

   jumpScreen(){
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) =>LoginPage(),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          )
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jumpScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/zifffyuserlogo.png',
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10,),
            Text("loading...",
              style: GoogleFonts.nunitoSans(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

