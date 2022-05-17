import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/UIScreens/ShareScreen.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {

  createUrl() async
  {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
      uriPrefix: 'https://newsupercab.page.link',
      link: Uri.parse('https://super-cab-59ea5.web.app/?id=${FirebaseAuth.instance.currentUser.uid}'),
      androidParameters: AndroidParameters(
        packageName: "com.utechware.thesupercab",
      ),
      iosParameters: IosParameters(
        bundleId: "com.utechware.thesupercab",
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "SuperCab",
        imageUrl: Uri.parse("https://firebasestorage.googleapis.com/v0/b/superrcab.appspot.com/o/mainLogo.png?alt=media&token=f51ee723-9c72-4048-936b-f0494f269fb0"),
      ),
    );
    await parameters.buildShortLink().then((ShortDynamicLink value) async {
      if (value != null) {
        await FlutterShare.share(
            title: "Super Cab",
            linkUrl: value.shortUrl.toString(),
            chooserTitle: 'Share with');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Drawer(
        child: Container(
          color: yellow,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children:
              [
                Container(
                  height: 30,
                  width: 20,
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 1.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black)),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/home'),
                    child: Row(
                      children:
                      [
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/icons/homeIcon.png',
                          height: 20,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          S.of(context).Home,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/getQuote'),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/icons/chat.png',
                          height: 20,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          S.of(context).Request_a_Quote,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                ExpansionTile(
                  backgroundColor: Colors.transparent,
                  tilePadding: EdgeInsets.fromLTRB(10, 0, 0, 0),

                  title: Row(
                    children: [
                      Image.asset(
                        'assets/icons/24hours.png',
                        height: 20,
                      ),
                      SizedBox(
                        width: 17,
                      ),
                      Text(
                        S.of(context).Extra_services,
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/extraService'),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.car_rental,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(S.of(context).Stretch_Limo,style: TextStyle(fontSize: 12),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/extraService'),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.bus_alert,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(S.of(context).Buses_upto_60_PAX,style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/extraService'),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.privacy_tip,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(S.of(context).Wedding_and_Party_Quotes,style: TextStyle(fontSize: 12))
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/extraService'),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.tour_sharp,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(S.of(context).Tours_and_Sight_Seeing,style: TextStyle(fontSize: 12))
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  ],
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/promotions'),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/icons/promotion.png',
                          height: 20,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Text(
                          S.of(context).Promotions,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () async
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=> ShareScreen()));
                      //createUrl();
                    },
                    child: Row(
                      children:
                      [
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/icons/share.png',
                          height: 20,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Text(S.of(context).Share_us, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/wallet'),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/icons/hand.png',
                          height: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          S.of(context).My_Account,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/history'),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/icons/history.png',
                          height: 20,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          S.of(context).My_Bookings,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/scanCard'),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/icons/paymentMethod.png',
                          height: 20,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          S.of(context).My_Cards,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 1.2,
                  thickness: 1.2,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: GestureDetector(
                    onTap: () {
                      FirebaseCredentials().auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/signIn', (route) => false);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.logout, color: Colors.black),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          S.of(context).LOG_OUT,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
