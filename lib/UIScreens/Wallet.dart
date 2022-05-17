
import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/utils/userController.dart';
import 'package:get/get.dart';


class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet>
{

  CurrentUser user;

  String myReward = '0';

  void getMyReward() async
  {
    await FirebaseCredentials()
        .firestore
        .collection('wallet')
        .doc(user.currentUserId)
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic> data = value.data();
        setState(() {
          myReward = data['TotalCash'].toString();
        });
      }
    }).catchError((onError) => print('Error Fetching Data'));
  }

  @override
  void initState() {

    super.initState();

    user = Get.find<CurrentUser>();
    getMyReward();
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
                            S.of(context).Wallet,
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
                      height: 30,
                    ),

                    Container(
                      //height: 465,
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                        margin: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10)),
                            border: Border.all(
                                color: Colors.white, width: 1)),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [

                            Text(S.of(context).CASH,style: TextStyle(fontSize: 15,color: yellow),),

                            SizedBox(height: 5,),

                            Text('\$ ${myReward.toString()}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: yellow),),

                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: RaisedButton(
                        color: yellow,
                        child: Text(S.of(context).Pay_Now,style: TextStyle(fontWeight: FontWeight.bold,),),
                        onPressed: ()
                        {

                        },
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

}
