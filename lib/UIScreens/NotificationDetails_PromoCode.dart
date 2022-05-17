import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/ActivatePromoCodeDialog.dart';
import 'package:supercab/utils/constants.dart';

class NotificationDetails_PromoCode extends StatefulWidget {
  String promoCodeId;

  NotificationDetails_PromoCode({
    @required this.promoCodeId,
  });

  @override
  _NotificationDetails_PromoCodeState createState() =>
      _NotificationDetails_PromoCodeState();
}

class _NotificationDetails_PromoCodeState
    extends State<NotificationDetails_PromoCode> {
  final formKey = GlobalKey<FormState>();

  final promoCodeController = TextEditingController();

  bool isOfferAvailable;
  bool alreadyActivated;

  bool formValidation() {
    if (formKey.currentState.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    isOfferAvailable = false;
    alreadyActivated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: new DecorationImage(
        fit: BoxFit.cover,
        image: new AssetImage("assets/icons/background.png"),
      )),
      child: Container(
        decoration: BoxDecoration(
            image: new DecorationImage(
          fit: BoxFit.cover,
          image: new AssetImage("assets/icons/bg_shade.png"),
        )),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: white)),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 12,
                            color: white,
                          ),
                        ),
                      ),
                      Text(
                        S.of(context).Special_Offer,
                        style: TextStyle(color: white, fontSize: 17),
                      ),
                      Visibility(
                        visible: false,
                        child: Icon(Icons.ac_unit_rounded),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PromoCodeDataModal());
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).ADD_PROMO_CODE,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.promoCodeId == null
                    ? Container(
                        alignment: Alignment.center,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('PromoCodes')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> querySnapshot) {
                            if (querySnapshot.hasError) {
                              return Center(child: Text('Some Error'));
                            }
                            if (querySnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              final list = querySnapshot.data.docs;

                              return Container(
                                height: 520,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    var promoCode = list[index]['promoCode'];
                                    var totalRides = list[index]['totalRides'];
                                    var expiryDate = list[index]['expiryDate'];
                                    var discount = list[index]['discount'];
                                    var message = list[index]['comment'];

                                    var date = DateFormat('MMM dd,yyyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            expiryDate));

                                    return Container(
                                      //height: 465,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 5),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: Colors.white, width: 1)),
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              discount.toString() +
                                                  '%' +
                                                  ' OFF',
                                              style: TextStyle(
                                                  fontSize: 22, color: yellow),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${S.of(context).Total_Rides} :  $totalRides',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              message,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${S.of(context).Code} :  $promoCode',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.copy,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                      onPressed: () async {
                                                        await FlutterClipboard
                                                            .copy(promoCode);
                                                        print('Text Copied');
                                                      },
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  '${S.of(context).Expires} :  $date',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: list.length,
                                ),
                              );
                            }
                          },
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('PromoCodes')
                              .doc(widget.promoCodeId)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> querySnapshot) {
                            if (querySnapshot.hasError) {
                              return Center(child: Text('Some Error'));
                            }
                            if (querySnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              final data = querySnapshot.data;

                              var promoCode = data['promoCode'];
                              var totalRides = data['totalRides'];
                              var expiryDate = data['expiryDate'];
                              var discount = data['discount'];
                              var message = data['comment'];

                              var date = DateFormat('MMM dd,yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      expiryDate));

                              return Container(
                                //height: 465,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${S.of(context).Promo_Code} :  $promoCode',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${S.of(context).Expiry_Date} : ',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            date,
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${S.of(context).discount} :  $discount',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${S.of(context).Total_Rides} :  $totalRides',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${S.of(context).Message} :  $message',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
