import 'package:dabbawala/UI/cart_page.dart';
import 'package:dabbawala/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:dabbawala/UI/data/globals_data.dart' as globals;
import 'package:http/http.dart' as http;

var discountId; // discount id
var discountName; //discount name
var discountOffPercentage; //discount percentage
var discountCashBack; // discount cash back in rupees
var discountMaxCashBack; // discount max cash back in rupees
var discountMinimumPurchaseAmount; // discount minimum purchase amount
var discountValidUntil; // discount validity
var discountMaximumDiscountAmount; // discount max amount
var discountMinimumAmount; // discount min amount
var discountLimit; // discount usage limit
var discountFrom; // start date
var discountUntil; // end date

var totalLimit;
var userDiscountUsedCount;

var selectedDiscountFrom;
var selectedDiscountUntil;

var discountLimitPerUser;

var totalUsageCount;
var selectedMaxDiscountAmount;
var selectedMinDiscountAmount;

class OffersAndPromoCodes extends StatefulWidget {
  @override
  _OffersAndPromoCodesState createState() => _OffersAndPromoCodesState();
}

class _OffersAndPromoCodesState extends State<OffersAndPromoCodes> {

  Future<String> getDiscounts(context) async {

    String url = globals.apiUrl + "getdiscount.php";

    http.post(url, body: {


    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetDiscount = jsonDecode(response.body);
      print(responseArrayGetDiscount);

      var responseArrayGetDiscountMsg = responseArrayGetDiscount['message'].toString();
      print(responseArrayGetDiscountMsg);

      if(statusCode == 200){
        if(responseArrayGetDiscountMsg == "Discount Found"){

          setState(() {
            discountId = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountID'].toString());
            discountName = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountName'].toString());
            discountOffPercentage = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountFlatdiscount'].toString());
            discountCashBack = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountCashback'].toString());
            discountMaxCashBack = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountMaximumcashbackamt'].toString());
            discountMinimumPurchaseAmount = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountMinimumpurchaseamt'].toString());
            discountMaximumDiscountAmount = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountMaximumdiscountamt'].toString());
            discountValidUntil = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountCoupenenddate'].toString());
            discountMinimumAmount = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountMinimumpurchaseamt'].toString());
            discountLimit = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountUsagelimit'].toString());
            discountFrom = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountCoupenstartdate'].toString());
            discountUntil = List.generate(responseArrayGetDiscount['data'].length, (index) => responseArrayGetDiscount['data'][index]['discountCoupenenddate'].toString());
          });

          print(discountId.toList());
          print(discountName.toList());
          print(discountOffPercentage.toList());
          print(discountCashBack.toList());
          print(discountMaxCashBack.toList());
          print(discountMinimumPurchaseAmount.toList());
          print(discountMaximumDiscountAmount.toList());
          print(discountValidUntil.toList());
          print(discountMinimumAmount.toList());
          print(discountLimit.toList());
          print(discountFrom.toList());
          print(discountUntil.toList());

        }else{

          setState(() {
            discountName = null;
          });

        }
      }

    }
    );
  }

  Future<String> getUserDiscountLogs(context) async {

    print(storedUserId);
    print(selectedDiscountId);

    String url = globals.apiUrl + "getdiscountlogs.php";

    http.post(url, body: {

      "userID" : storedUserId.toString(),
      "discountID" : selectedDiscountId.toString(),

    }).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");

      }

      var responseArrayGetMyLogs = jsonDecode(response.body);
      print(responseArrayGetMyLogs);

      var responseArrayGetMyLogsMsg = responseArrayGetMyLogs['message'].toString();
      print(responseArrayGetMyLogsMsg);

      if(statusCode == 200){
        if(responseArrayGetMyLogsMsg == "Successfully"){

          setState(() {
            userDiscountUsedCount = responseArrayGetMyLogs['data'].length.toString(); //How many times i have used this discount
            totalUsageCount = responseArrayGetMyLogs['data2'].toString();
            totalLimit = responseArrayGetMyLogs['data1']['discountTotallimit'].toString(); //How many times zifffy total users can use this discount(total Limit)
            discountLimitPerUser = responseArrayGetMyLogs['data1']['discountUsagelimit'].toString(); //How many times a single user can use this
          });
          print(userDiscountUsedCount);
          print(totalUsageCount);
          print(totalLimit);
          print(discountLimitPerUser);

          if(int.parse(totalUsageCount) == int.parse(totalLimit) || int.parse(totalUsageCount) > int.parse(totalLimit)){
            print("111111");
            Fluttertoast.showToast(msg: 'You have reached the limit for this offer!',backgroundColor: Colors.white, textColor: Colors.red);
            setState(() {
              selectedDiscountAmount = null;
            });
          }else{
            if(int.parse(userDiscountUsedCount) == int.parse(discountLimitPerUser) || int.parse(userDiscountUsedCount) > int.parse(discountLimitPerUser)){
              print("222222");
              Fluttertoast.showToast(msg: 'You have reached the limit for this offer!',backgroundColor: Colors.white, textColor: Colors.red);
              setState(() {
                selectedDiscountAmount = null;
              });
            }else{
              if(DateTime.now().isAfter(DateTime.parse(selectedDiscountFrom)) && DateTime.now().isBefore(DateTime.parse(selectedDiscountUntil))){
                print("333333");

                if(double.parse(selectedMinDiscountAmount.toString()) <  double.parse(selectedDiscountAmount.toString()) && double.parse(selectedDiscountAmount.toString()) > double.parse(selectedMaxDiscountAmount.toString())){
                  Fluttertoast.showToast(msg: 'Offer applied',backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
                    Navigator.of(context).pop();
                  });
                }else{
                  Fluttertoast.showToast(msg: 'This offer is not applicable for this order!',backgroundColor: Colors.white, textColor: Colors.red);
                  setState(() {
                    selectedDiscountAmount = null;
                  });
                }

              }else{
                print("44444");
                Fluttertoast.showToast(msg: 'This offer has expired!',backgroundColor: Colors.white, textColor: Colors.red);
                setState(() {
                  selectedDiscountAmount = null;
                });
              }
            }
          }
        }else{
          print("555555");

          if(double.parse(selectedMinDiscountAmount.toString()) <  double.parse(selectedDiscountAmount.toString()) && double.parse(selectedDiscountAmount.toString()) > double.parse(selectedMaxDiscountAmount.toString())){
            Fluttertoast.showToast(msg: 'Offer applied',backgroundColor: Colors.black, textColor: Colors.white).whenComplete((){
              Navigator.of(context).pop();
            });
          }else{
            Fluttertoast.showToast(msg: 'This offer is not applicable for this order!',backgroundColor: Colors.white, textColor: Colors.red);
            setState(() {
              selectedDiscountAmount = null;
            });
          }

        }
      }

    }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userDiscountUsedCount = null;
      selectedDiscountId = null;
    });
    getDiscounts(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            discountName == null ? Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Text("No available offers currently, we will notify you soon for exciting offers to grab on!"),
            ) : buildOffersList(context),
          ],
        ),
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
      title: Text('Available Offers',style: GoogleFonts.nunitoSans(
        color: Colors.black,
        fontSize: 20,
      ),),
    );
  }

  Widget buildOffersList(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: discountName == null ? 0 : discountName.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 5),
          child: InkWell(
            onTap: (){
              print("onTap called");
              setState(() {
                selectedDiscountId = discountId[index].toString();
                selectedMaxDiscountAmount = discountMaximumDiscountAmount[index].toString();
                selectedMinDiscountAmount = discountMinimumAmount[index].toString();

                if(finalAmount2 == null || finalAmount2 == "null"){
                  selectedDiscountAmount = (double.parse(tempAmt2.toString()) *  ( double.parse( discountOffPercentage[index].toString()) / 100 )).round();
                }else{
                  selectedDiscountAmount = (double.parse(finalAmount2.toString()) *  ( double.parse( discountOffPercentage[index].toString()) /100 )).round();
                }

                selectedDiscountPromoCode = discountName[index].toString();
                selectedDiscountFrom = discountFrom[index].toString();
                selectedDiscountUntil = discountUntil[index].toString();
              });
              print(selectedDiscountId);
              print(selectedDiscountAmount);
              print(selectedDiscountPromoCode);
              print(selectedDiscountFrom);
              print(selectedDiscountUntil);

              getUserDiscountLogs(context);
            },
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offer code : " + discountName[index],
                          textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5,),
                        discountValidUntil[index] == "0000-00-00 00:00:00" ? Text(
                          "Offer Details : Get Flat "+discountOffPercentage[index]+"% off on your order.",
                          textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                            color: Colors.grey,
                            fontSize: 13,),
                        ) : Text(
                          "Offer Details : Get Flat Rs."+discountOffPercentage[index]+" off on your order. Valid untill : " + discountValidUntil[index].toString().substring(0,10),
                          textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                              color: Colors.grey,
                              fontSize: 13,),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Click here to apply",
                          textScaleFactor: 1,
                          style: GoogleFonts.nunitoSans(
                            color: Colors.blue,
                            fontSize: 12,),
                        ),
                      ],
                    )),
                Divider(),
              ],
            ),
          ),
        ));
  }

}
