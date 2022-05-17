import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supercab/UIScreens/NotificationDetails_PromoCode.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';

class Promotions extends StatefulWidget {
  @override
  _PromotionsState createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage("assets/icons/background.png"),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: new AssetImage("assets/icons/bg_shade.png"),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 60, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
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
                        S.of(context).Promotions,
                        style: TextStyle(color: white, fontSize: 17),
                      ),
                      Visibility(
                        visible: false,
                        child: Icon(Icons.ac_unit_rounded),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => NotificationDetails_PromoCode(
                              promoCodeId: null,
                            )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 18, right: 18, top: 30),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                        ),
                        Text(
                          S.of(context).Discount_Offers,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 520,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Posts')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> querySnapshot) {
                      if (querySnapshot.hasError) {
                        return Center(child: Text('Some Error'));
                      }
                      if (querySnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: yellow,
                          ),
                        );
                      } else {
                        final list = querySnapshot.data.docs;
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            var time = list[index]['time'];
                            var date = list[index]['date'];
                            var description = list[index]['description'];
                            var imageUrl = list[index]['imageUrl'];
                            bool isItalic = list[index]['isItalic'];
                            bool isBold = list[index]['isBold'];
                            var fontSize = list[index]['fontsSize'];
                            var colorCode = int.parse(list[index]['colorCode']);
                            var selectedFontFamily = list[index]['fontFamily'];
                            return Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white, width: 1)),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${S.of(context).Date} : ',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        date,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${S.of(context).Time} : ',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        time,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            color: Colors.white, width: 1)),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.fill,
                                        height: 300,
                                        width: 350,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(description.toString(),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          color: Color(colorCode),
                                          fontFamily: selectedFontFamily,
                                          fontWeight: isBold
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontStyle: isItalic
                                              ? FontStyle.italic
                                              : FontStyle.normal)),
                                ],
                              ),
                            );
                          },
                          itemCount: list.length,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
