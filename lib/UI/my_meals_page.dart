import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MyMeals extends StatefulWidget {
  @override
  _MyMealsState createState() => _MyMealsState();
}

class _MyMealsState extends State<MyMeals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildMyMeals(context),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_outlined,color: Colors.black,)),
      centerTitle: true,
      title: Text('My Orders',style: GoogleFonts.nunitoSans(
        color: Colors.blue[800],
        fontWeight: FontWeight.bold,
        fontSize: 20
      ),),
    );
  }

  Widget buildMyMeals(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width / 1,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Image.asset(
                              'assets/images/dabba.png',
                              scale: 2,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 95  ),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 4.5,
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: Colors.red[700]),
                              child: Center(
                                child: Text(
                                  'Best Seller',
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 70),
                              child: Text(
                                'Aloo-Rajma Thali',
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                            Text(
                              'Rice, Chapati, Daal, Aloo-Rajma, \nRaita, Pickle, Rasgolla, Curd',
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Text(
                                'New Udupi Restaurant',
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ),
                          ]),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('26th Oct 2020,\n4:09 PM',style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600
                            ),),
                            Text(
                              '★ 4.8 ',
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.yellow[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rs 200',
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ])
                    ],
                  )),
            ))
      ]),
    );
  }
}
