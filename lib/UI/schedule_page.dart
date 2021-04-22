import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:buildUpcomingMeals(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          buildScheduleMeals(context),
          ],
        ),
      ),

    );
  }

  Widget buildUpcomingMeals(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text('Upcoming Meals',style: GoogleFonts.nunitoSans(
        color: Colors.blue[800],
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),),
    );
  }

  Widget buildScheduleMeals(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: 5,right: 5),
      child: ListView.builder(
        shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 5,
          itemBuilder: (context, index) =>
             Padding(
               padding: const EdgeInsets.only(top:15),
               child: Stack(
                 children: [Container(
               padding: EdgeInsets.only(left: 10,right: 10),
               width: MediaQuery.of(context).size.width/1,
               height: MediaQuery.of(context).size.height/6.5,
               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.centerRight,
//                     end: Alignment.centerLeft,
//                     colors: [
//                       Colors.blue[200],
//                       Colors.blue[100],
//                       Colors.white
//                     ],
//                   ),
               color: Colors.blue[200],
                   borderRadius: BorderRadius.all(Radius.circular(15)),

                 boxShadow: [BoxShadow(
                   color: Colors.black.withOpacity(0.7),blurRadius: 10,
                 )],
               ),),

                   Container(
                   width: MediaQuery.of(context).size.width/4,
                   height: MediaQuery.of(context).size.height/6.5,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(15)),
                   ),
                     child: Image.asset('assets/images/dabba.png',scale: 2,fit: BoxFit.fill,),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 115,top: 10),
                     child: Text('Aloo-Rajma Thali',style: GoogleFonts.nunitoSans(
                       color: Colors.blue[900],
                       fontWeight: FontWeight.bold,
                       fontSize: 14
                     ),),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 115, top: 38),
                     child: Text('Rice, Chapati, Daal, Aloo-Rajma, \nRaita, Pickle, Rasgolla, Curd',style: GoogleFonts.nunitoSans(
                       color: Colors.black,
                       fontSize: 13,
                       fontWeight: FontWeight.w600
                     ),),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 115,top: 80),
                     child: Text('New Udupi Restaurant',style: GoogleFonts.nunitoSans(
                       color: Colors.black,
                       fontWeight: FontWeight.w600,
                       fontSize: 13
                     ),),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 288,top: 10),
                     child: Text('Monday - Breakfast',style: GoogleFonts.nunitoSans(
                       color: Colors.blue[800],
                       fontSize: 13,
                       fontWeight: FontWeight.bold
                     ),),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left:5,top: 140),
                     child: Container(
                       width: MediaQuery.of(context).size.width/2.4,
                       height: MediaQuery.of(context).size.height/17,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(15)),
                         color: Colors.blueAccent[700],
                         boxShadow: [BoxShadow(
                           color: Colors.black.withOpacity(0.7),blurRadius: 10,
                         )],
                       ),
                       child: Center(
                         child: Text('Modify Order',style: GoogleFonts.nunitoSans(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           fontSize: 15,
                         ),),
                       ),
                     ),
                   ),

                   Padding(
                     padding: const EdgeInsets.only(left:225,top: 140),
                     child: Container(
                       width: MediaQuery.of(context).size.width/2.4,
                       height: MediaQuery.of(context).size.height/17,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(15)),
                           color: Colors.grey[300],
                         boxShadow: [BoxShadow(
                           color: Colors.black.withOpacity(0.7),blurRadius: 10,
                         )],
                       ),
                       child: Center(
                         child: Text('Cancel',style: GoogleFonts.nunitoSans(
                           color: Colors.black,
                           fontSize: 15,
                           fontWeight: FontWeight.bold
                         ),),
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 320,
                     top: 40),
                     child: Text('26th Oct 2020',style: GoogleFonts.nunitoSans(
                       color: Colors.black,
                       fontSize: 13,
                       fontWeight: FontWeight.w500
                     ),),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left: 300,
                         top: 80),
                     child: Text('Home (Whitefield)',style: GoogleFonts.nunitoSans(
                         color: Colors.black,
                         fontSize: 13,
                         fontWeight: FontWeight.w500
                     ),),
                   )

                 ],
               ),
             )

      ),
    );
  }
}
