import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'dart:convert';

var orderIdNo;
var orderItemName;
var orderVendorName;
var orderTotalPrice;
var orderDatetime;
var orderNumber;
var orderStatus;

class MyPastOrders extends StatefulWidget {
  @override
  _MyPastOrdersState createState() => _MyPastOrdersState();
}

class _MyPastOrdersState extends State<MyPastOrders> {

  Future<String> getPastOrders(context) async {

    String url = globals.apiUrl + "getpastorders.php";

    http.post(url, body: {

      "customerid" : storedUserId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var getOrders = jsonDecode(response.body);
      print(getOrders);

      var getOrdersMsg = getOrders['message'].toString();
      print(getOrdersMsg);

      if(statusCode == 200){
        if(getOrdersMsg == "Item Found"){
          setState(() {
            orderIdNo = List.generate(getOrders['data'].length, (index) => getOrders['data'][index]['orderNumber']);
            orderItemName = List.generate(getOrders['data'].length, (index) => getOrders['data'][index]['itemName']);
            orderVendorName = List.generate(getOrders['data'].length, (index) => getOrders['data'][index]['vendorName']);
            orderTotalPrice = List.generate(getOrders['data'].length, (index) => getOrders['data'][index]['orderAmnt']);
            orderDatetime = List.generate(getOrders['data'].length, (index) => getOrders['data'][index]['orderDatetime']);
            orderNumber = List.generate(getOrders['data'].length, (index) => getOrders['data'][index]['orderNumber']);
            orderStatus = List.generate(getOrders['data'].length, (index) => getOrders['data'][index]['orderStatus']);
          });
          print(orderIdNo.toList());
          print(orderItemName.toList());
          print(orderVendorName.toList());
          print(orderTotalPrice.toList());
          print(orderDatetime.toList());
          print(orderNumber.toList());
          print(orderStatus.toList());

        }else{
          setState(() {
            orderIdNo = null;
          });

        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderIdNo = null;
    getPastOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: buildOrderedItems(context),
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
      title: Text('My Past Orders',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
        color: Colors.black,
        fontSize: 20,
      ),),
    );
  }

  Widget buildOrderedItems(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: orderIdNo == null ? 0 : orderIdNo.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Text(
                                orderItemName.reversed.toList()[index],textScaleFactor: 1,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width/1.5,
                                child: Text(
                                  "Ordered no. : "+orderNumber.reversed.toList()[index],
                                  textScaleFactor: 1,
                                  maxLines: 2,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width/1.5,
                                child: Text(
                                  "Ordered from : "+orderVendorName.reversed.toList()[index],
                                  textScaleFactor: 1,
                                  maxLines: 2,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.yellow[900],
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width/1.5,
                                child: Text(
                                  "Ordered on : "+orderDatetime.reversed.toList()[index],
                                  textScaleFactor: 1,
                                  maxLines: 2,
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, top: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width/1.5,
                                child: Text(
                                  orderStatus.reversed.toList()[index] == "1" ? "Ordered status : Confirmed" : orderStatus.reversed.toList()[index] == "2" ? "Ordered status : Delivered" : "Ordered status : Cancelled",
                                  textScaleFactor: 1,
                                  maxLines: 2,
                                  style: GoogleFonts.nunitoSans(
                                      color: orderStatus.reversed.toList()[index] == "3" ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          globals.currencySymbl+orderTotalPrice.reversed.toList()[index],
                          textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
              Divider(),
            ],
          ),
        ));
  }

}
