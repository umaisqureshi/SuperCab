import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:flag/flag.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/widgets/progressIndicatorWidget.dart';
import 'package:supercab/utils/socialAuthentication.dart'
    as SocialAuthentication;
import 'package:supercab/utils/userController.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>
{

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPassVisible = false;
  bool isConfirmPassVisible = false;
  bool _status = false;

  CurrentUser user;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String languages = 'English';
  String countryCode;

  @override
  void initState() {
    super.initState();
    user = Get.put(CurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: Row(
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
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        S.of(context).SIGN_UP,
                        style: TextStyle(color: white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          style: TextStyle(color: white),
                          dropdownColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: S.of(context).Select_Language,
                            hintStyle: TextStyle(color: white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: white, width: 2),
                            ),
                          ),
                          value: languages,
                          items: [
                            'English',
                            'Chinese',
                          ]
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem(
                                        child: Text(value),
                                        value: value,
                                      ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              languages = value;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: new TextFormField(
                                  controller: firstNameController,
                                  validator: (input) {
                                    if (input.isEmpty)
                                      return 'Required Field';
                                    else
                                      return null;
                                  },
                                  style: TextStyle(color: white),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: white),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        color: white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: white, width: 2),
                                    ),
                                    hintText: S.of(context).First_Name,
                                  )),
                            ),
                          ),
                          new Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: new TextFormField(
                                  controller: lastNameController,
                                  validator: (input) {
                                    if (input.isEmpty)
                                      return 'Required Field';
                                    else
                                      return null;
                                  },
                                  style: TextStyle(color: white),
                                  decoration: InputDecoration(
                                    hintText: S.of(context).Last_Name,
                                    hintStyle: TextStyle(color: white),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        color: white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: white, width: 2),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: emailController,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Required Field';
                            else
                              return null;
                          },
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: S.of(context).Email,
                            hintStyle: TextStyle(color: white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: white, width: 2),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: TextFormField(
                                  style: TextStyle(color: white),
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: white),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        color: white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: white, width: 2),
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Flag(
                                        "Au",
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                    hintText: '+61',
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: new TextFormField(
                                  controller: phoneController,
                                  validator: (input) {
                                    if (input.isEmpty)
                                      return 'Required Field';
                                    else if (input.length != 9) //9
                                      return 'Invalid Number';
                                    else
                                      return null;
                                  },
                                  style: TextStyle(color: white),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '123456789',
                                    hintStyle: TextStyle(color: white),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                        color: white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: white, width: 2),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: isPassVisible ? false : true,
                          controller: passController,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Required Field';
                            else if (input.length < 8)
                              return 'Password should be 8 character long';
                            else
                              return null;
                          },
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            suffixIcon: isPassVisible
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPassVisible = !isPassVisible;
                                      });
                                    },
                                    child: Icon(Icons.visibility_off,
                                        color: Colors.white))
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPassVisible = !isPassVisible;
                                      });
                                    },
                                    child: Icon(Icons.visibility,
                                        color: Colors.white)),
                            hintText: S.of(context).Password,
                            hintStyle: TextStyle(color: white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: white, width: 2),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          obscureText: isConfirmPassVisible ? false : true,
                          controller: confirmPasswordController,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Required Field';
                            else if (passController.text !=
                                confirmPasswordController.text)
                              return 'Passwords should be matched';
                            else
                              return null;
                          },
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            suffixIcon: isConfirmPassVisible
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isConfirmPassVisible =
                                            !isConfirmPassVisible;
                                      });
                                    },
                                    child: Icon(Icons.visibility_off,
                                        color: Colors.white))
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isConfirmPassVisible =
                                            !isConfirmPassVisible;
                                      });
                                    },
                                    child: Icon(Icons.visibility,
                                        color: Colors.white)),
                            hintText: S.of(context).Confirm_Password,
                            hintStyle: TextStyle(color: white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: white, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _status
                    ? ProgressIndicatorWidget()
                    : Padding(
                        padding: EdgeInsets.fromLTRB(8, 40, 8, 20),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                              color: yellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Text(
                                S.of(context).Continue,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              onPressed: () {
                                signUp();
                              }),
                        ),
                      ),
                Text(
                  S.of(context).OR,
                  style: TextStyle(fontSize: 18, color: white),
                ),
                _status
                    ? ProgressIndicatorWidget()
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () =>
                                  SocialAuthentication.signUpFacebook(context),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/icons/fb.png',
                                    height: 25,
                                  ),
                                  Text(
                                    'Facebook',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: Icon(Icons.eighteen_mp),
                                  )
                                ],
                              )),
                        ),
                      ),
                _status
                    ? ProgressIndicatorWidget()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                              color: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () =>
                                  SocialAuthentication.signUpGoogle(context),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    'assets/icons/google.png',
                                    height: 25,
                                  ),
                                  Text(
                                    S.of(context).Google,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: Icon(Icons.eighteen_mp),
                                  )
                                ],
                              )),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: RichText(
                    text: TextSpan(
                        text: S.of(context).Have_an_account,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        children: [
                          TextSpan(
                            text: S.of(context).SIGN_IN,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: yellow,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => Navigator.pushNamed(context, '/signIn'),
                          ),
                          TextSpan(
                            text: "${S.of(context).here}?",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _status = true;
      });
      await FirebaseCredentials()
          .auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passController.text)
          .then((value) {
        user.currentUserId = value.user.uid;
        FirebaseCredentials().firestore.collection('user').doc(user.currentUserId).set({
          'name': firstNameController.text + ' ' + lastNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'selectedLanguage': languages
        });
      });
      setState(() {
        _status = false;
      });
      Navigator.pushReplacementNamed(context, '/OTP',
          arguments: '+61' + phoneController.text);
    }
  }
}
