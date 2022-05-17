import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_share/flutter_share.dart';



class ShareScreen extends StatefulWidget {
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {

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
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
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
                          S.of(context).Share_us,
                          style: TextStyle(color: white, fontSize: 17),
                        ),
                        Visibility(
                          visible: false,
                          child: Icon(Icons.ac_unit_rounded),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 5,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50,vertical: 100),
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Text('Share Our App and Earn 10\$ on every share to a new user',style: TextStyle(color: Colors.white,fontSize: 16),),
                  ),

                  SizedBox(height: 25,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: RaisedButton(
                          color: yellow,
                          child: Text('Share',style: TextStyle(fontWeight: FontWeight.bold),),
                          onPressed: ()
                          {
                            createUrl();
                          },
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ));
  }

}
