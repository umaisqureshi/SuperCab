import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';


class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
   TextEditingController _outputController;

  @override
  initState() {
    super.initState();
    this._outputController =  TextEditingController();
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
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage("assets/icons/bg_shade.png"),
          )),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/icons/mainLogo.png',
                  height: 150,
                ),

                Text(
                  S.of(context).Get_access_to_hundreds_of_Cabs,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),

                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white24,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/qrscane.png')),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 140,
                              height: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/group.png')),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white24,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: S.of(context).John_Smith,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' ${S.of(context).member} ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('john_smith@gmail.com',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ))
                      ],
                    ),
                  ),
                ),
                //Spacer(),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    color: yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).Cancel,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
