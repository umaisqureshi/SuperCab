// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:supercab/utils/constants.dart';
// import 'package:supercab/utils/socialAuthentication.dart'
//     as SocialAuthentication;
//
// class OnBoard extends StatefulWidget {
//   @override
//   _OnBoardState createState() => _OnBoardState();
// }
//
// class _OnBoardState extends State<OnBoard> {
//   final introKey = GlobalKey<IntroductionScreenState>();
//
//   void _onIntroEnd(context) {}
//
//   Widget _buildImage(String assetName) {
//     return Align(
//       child: Image.asset('assets/icons/$assetName.png', width: 350.0),
//       alignment: Alignment.bottomCenter,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const bodyStyle = TextStyle(
//         fontSize: 19.0, color: Colors.white, fontWeight: FontWeight.bold);
//     const pageDecoration = const PageDecoration(
//       titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
//       bodyTextStyle: bodyStyle,
//       descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
//       pageColor: Colors.transparent,
//       imagePadding: EdgeInsets.zero,
//     );
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: BoxDecoration(
//               image: new DecorationImage(
//             fit: BoxFit.cover,
//             image: new AssetImage("assets/icons/background.png"),
//           )),
//           child: Container(
//               height: double.infinity,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   image: new DecorationImage(
//                 fit: BoxFit.cover,
//                 image: new AssetImage("assets/icons/bg_shade.png"),
//               )),
//               child: Column(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 480,
//                     child: IntroductionScreen(
//                       globalBackgroundColor: Colors.transparent,
//                       key: introKey,
//                       pages: [
//                         PageViewModel(
//                           mainTitleWidget: Center(
//                             child: Text(
//                               "Australia Wide",
//                               style: TextStyle(
//                                   color: yellow,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           titleWidget: SizedBox(),
//                           bodyWidget: Text(
//                             "On demand chauffeur car, bus, van and limo network across the country.",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500),
//                             textAlign: TextAlign.center,
//                           ),
//                           image: _buildImage('australiaWide'),
//                           decoration: pageDecoration,
//                         ),
//                         PageViewModel(
//                           mainTitleWidget: Center(
//                             child: Text(
//                               "Vehicle Class",
//                               style: TextStyle(
//                                   color: yellow,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           titleWidget: SizedBox(),
//                           bodyWidget: Text(
//                             "We offer Business Sedans, European Prestige, SUV, VAN,Buses and Stretch Limos for Airport Transfers, Weddings and local Pick ups",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500),
//                             textAlign: TextAlign.center,
//                           ),
//                           image: _buildImage('vehicleClass'),
//                           decoration: pageDecoration,
//                         ),
//                         PageViewModel(
//                           mainTitleWidget: Center(
//                             child: Text(
//                               "Fixed Price",
//                               style: TextStyle(
//                                   color: yellow,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           titleWidget: SizedBox(),
//                           bodyWidget: Text(
//                             "No surge pricing no hidden cost, The price you see is the price you pay",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500),
//                             textAlign: TextAlign.center,
//                           ),
//                           image: _buildImage('fixedPrice'),
//                           decoration: pageDecoration,
//                         ),
//                         PageViewModel(
//                           mainTitleWidget: Center(
//                             child: Text(
//                               "Customer Satisfaction",
//                               style: TextStyle(
//                                   color: yellow,
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           titleWidget: SizedBox(),
//                           bodyWidget: Text(
//                             "Super cab partners maintain a 96% customer satisfaction rating",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500),
//                             textAlign: TextAlign.center,
//                           ),
//                           image: _buildImage('customerSatisfaction'),
//                           footer: RaisedButton(
//                             onPressed: () {
//                               introKey.currentState?.animateScroll(0);
//                             },
//                             child: const Text(
//                               'FooButton',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             color: Colors.lightBlue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                           ),
//                           decoration: pageDecoration,
//                         ),
//                       ],
//                       onDone: () => _onIntroEnd(context),
//                       showSkipButton: false,
//                       skipFlex: 0,
//                       nextFlex: 0,
//                       skip: null,
//                       next: const Icon(Icons.arrow_forward),
//                       done: Text(''),
//                       dotsDecorator: const DotsDecorator(
//                         size: Size(10.0, 10.0),
//                         color: yellow,
//                         activeSize: Size(22.0, 10.0),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     "15% Off 1st ride. Use PROMO 'FIRST'",
//                     style: TextStyle(
//                         color: yellow,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Container(
//                         height: 50,
//                         child: RaisedButton(
//                             color: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               side: BorderSide(
//                                 color: Colors.blue,
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             onPressed: () =>
//                                 SocialAuthentication.signUpFacebook(context),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 20.0),
//                                   child: Image.asset(
//                                     "assets/icons/Icon awesome-facebook-f.png",
//                                     width: 20,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 20.0),
//                                   child: Text(
//                                     'Facebook',
//                                     style: TextStyle(
//                                       fontFamily: 'Montserrat',
//                                       fontSize: 15,
//                                       color: const Color(0xffffffff),
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ],
//                             )),
//                       ),
//                       Container(
//                         height: 50,
//                         child: RaisedButton(
//                             color: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               side: BorderSide(
//                                 color: Colors.white,
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             onPressed: () =>
//                                 SocialAuthentication.signUpGoogle(context),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 20.0),
//                                   child: Image.asset(
//                                     "assets/icons/google.png",
//                                     width: 20,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 30.0),
//                                   child: Text(
//                                     'Google',
//                                     style: TextStyle(
//                                       fontFamily: 'Montserrat',
//                                       fontSize: 15,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ],
//                             )),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Container(
//                       width: double.infinity,
//                       height: 50,
//                       child: RaisedButton(
//                         color: Colors.white.withOpacity(0.1),
//                         shape: RoundedRectangleBorder(
//                             side: BorderSide(color: Colors.white),
//                             borderRadius: BorderRadius.circular(13)),
//                         onPressed: () =>
//                             Navigator.pushNamed(context, '/signIn'),
//                         child: Text(
//                           "SIGN IN",
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Container(
//                       width: double.infinity,
//                       height: 50,
//                       child: RaisedButton(
//                         color: Colors.white.withOpacity(0.1),
//                         shape: RoundedRectangleBorder(
//                             side: BorderSide(color: Colors.white),
//                             borderRadius: BorderRadius.circular(13)),
//                         onPressed: () =>
//                             Navigator.pushNamed(context, '/signUp'),
//                         child: RichText(
//                           text: TextSpan(
//                               text: "Don't Have an account",
//                               style:
//                                   TextStyle(fontSize: 12, color: Colors.white),
//                               children: [
//                                 TextSpan(
//                                   text: " SIGN UP ",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     color: yellow,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "Here?",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 ),
//                               ]),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
// }
