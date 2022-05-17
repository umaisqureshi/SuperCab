import 'package:flutter/material.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/firebaseCredentials.dart';
import 'package:supercab/UIScreens/bookCab.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final contactController = TextEditingController();

  final emailController = TextEditingController();
   final vehicleController = TextEditingController();
  final tripCostController = TextEditingController();
  

  bool _status = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
              child: Container(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
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
                          onTap: ()=> Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 12,
                            color: white,
                          ),
                        ),
                      ),
                      Text(
                        S.of(context).Contact,
                        style: TextStyle(color: white, fontSize: 17),
                      ),
                      Visibility(
                        visible: false,
                        child: Icon(Icons.eighteen_mp),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Icon(Icons.eighteen_mp),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                           controller: nameController,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Required Field';
                            else
                              return null;
                          },
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: S.of(context).Name,
                            hintStyle: TextStyle(color: white),
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                           controller: contactController,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Required Field';
                            else
                              return null;
                          },
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: '${S.of(context).Contact_Number} :',
                            hintStyle: TextStyle(color: white),
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                           controller: emailController,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Required Field';
                            else
                              return null;
                          },
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: 'smith@gmail.com',
                            hintStyle: TextStyle(color: white),
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
                          SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                           controller: phoneController,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Required Field';
                            else
                              return null;
                          },
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: '${S.of(context).phone}',
                            hintStyle: TextStyle(color: white),
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                           controller: vehicleController,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Required Field';
                            else
                              return null;
                          },
                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: S.of(context).Selected_Vehicle,
                            hintStyle: TextStyle(color: white),
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
                         SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                           controller: tripCostController,
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Required Field';
                            else
                              return null;
                          },

                          style: TextStyle(color: white),
                          decoration: InputDecoration(
                            hintText: S.of(context).Trip_Cost,
                            hintStyle: TextStyle(color: white),
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      color: yellow,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      onPressed: (){

                        submit();
                      },
                      child: Text(
                        S.of(context).Next,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
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
   void submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _status = true;
      });

      FirebaseCredentials().firestore.collection('contactnumber').doc().set({
        'name': nameController.text,
        'contactNumber': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'vehicle': vehicleController.text,
       

      });
      setState(() {
        _status = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BookCab()));
    }
  }
}
