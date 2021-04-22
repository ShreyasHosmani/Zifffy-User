import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_page.dart';
import 'data/globals_data.dart';

class SuccessfulPurchase extends StatefulWidget {
  @override
  _SuccessfulPurchaseState createState() => _SuccessfulPurchaseState();
}

class _SuccessfulPurchaseState extends State<SuccessfulPurchase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: InkWell(
        onTap: (){
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.4),blurRadius: 3,
                )],
                color: Colors.grey.shade300
            ),
            child: Center(
              child: Text('Okay',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Order Confirmed",
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, size: 20, color: Colors.black,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Text("Your order has been confirmed.",
              style: GoogleFonts.nunitoSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20,),
            Center(child: Image.asset("assets/images/done.gif", scale: 2,)),
            SizedBox(height: 20,),
            Divider(),
            Text("Your order details : ",
              style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            buildCartItems(context),
            buildAdOnsListViewBuilder(context),
            buildItemListPrice(context),
          ],
        ),
      ),
    );
  }

  Widget buildCartItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
      child: Column(children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            itemCount: cartItemNames == null ? 0 : cartItemNames.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
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
                                    cartItemNames[index],textScaleFactor: 1,
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              currencySymbl+cartItemPrices[index],textScaleFactor: 1,
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
            ))
      ]),
    );
  }

  Widget buildAdOnsListViewBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
      child: Column(children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0.0),
            scrollDirection: Axis.vertical,
            itemCount: cartAdOnNamesList == null ? 0 : cartAdOnNamesList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //width: MediaQuery.of(context).size.width/1.5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 0, top: 5),
                              child: Text(
                                cartAdOnNamesList[index],textScaleFactor: 1,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              currencySymbl+cartAdOnPricesList[index],textScaleFactor: 1,
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
            ))
      ]),
    );
  }

  Widget buildItemListPrice(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total item bill:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),),
              InkWell(
                onTap: (){print(finalAmount.toString());},
                child: finalAmountWithAdOns == null || finalAmountWithAdOns == "null" ? Text(currencySymbl+ tempAmt.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),) : Text(currencySymbl + finalAmountWithAdOns.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),),
              )
            ],
          ),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Partner Fee:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),),
              Text('Rs '+deliveryFees.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),)
            ],
          ),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax and charges:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),),
              Text('Rs '+taxFees.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),)
            ],
          ),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Packing charges:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),),
              Text('Rs '+packingCharge.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),)
            ],
          ),
          walletBalance == "0" ? Container() : Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Use wallet balance',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),),
              Spacer(),
              Text('Rs '+walletBalance.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),),
              SizedBox(width: 10,),
              Container(
                child: Center(child: useWalletBalance == true ? GestureDetector(
                    onTap: (){setState(() {
                      useWalletBalance = false;
                    });
                    if(finalAmount2 == null || finalAmount2 == "null"){
                      setState(() {
                        tempAmt2 = int.parse(tempAmt2.toString())+int.parse(walletBalance.toString());
                      });
                      print(tempAmt2);
                    }else{
                      setState(() {
                        finalAmount2 = int.parse(finalAmount2.toString())+int.parse(walletBalance.toString());
                      });
                    }
                    },
                    child: Icon(Icons.check_box, color: Colors.green,)) :
                GestureDetector(
                    onTap: (){setState(() {
                      useWalletBalance = true;
                    });
                    if(finalAmount2 == null || finalAmount2 == "null"){
                      setState(() {
                        tempAmt2 = int.parse(tempAmt2.toString())-int.parse(walletBalance.toString());
                      });
                      print(tempAmt2);
                    }else{
                      setState(() {
                        finalAmount2 = int.parse(finalAmount2.toString())-int.parse(walletBalance.toString());
                      });
                    }
                    },
                    child: Icon(Icons.check_box_outline_blank, color: Colors.grey,)),),
              ),
            ],
          ),
          selectedDiscountAmount == null || selectedDiscountAmount == "null" ? Container() :
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Promo code applied',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600
              ),),
              Spacer(),
              Text(selectedDiscountPromoCode+"- Rs. "+selectedDiscountAmount.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.red[900],
                  fontWeight: FontWeight.w600
              ),),
            ],
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total bill:',textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),),
              finalAmount2 == null || finalAmount2 == "null" ? Text('Rs '+tempAmt2.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),) : Text('Rs '+finalAmount2.toString(),textScaleFactor: 1,style: GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),)
            ],
          ),
          SizedBox(height: 10,),
          // SizedBox(height: 12,),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('Total bill with subscription:',style: GoogleFonts.nunitoSans(
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold,
          //       color: Colors.blue[800]
          //     ),),
          //     Text('Rs 560',style: GoogleFonts.nunitoSans(
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.blue[800]
          //     ),)
          //   ],
          // )
        ],
      ),
    );

  }
}
