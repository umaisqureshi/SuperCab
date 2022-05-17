import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/helper/src/searchMapPlaceWidget.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/location_utils.dart';
import 'package:supercab/utils/model/AirportPriceList.dart';
import 'package:supercab/utils/model/airportNameModel.dart';
import 'package:supercab/utils/settings.dart';
import 'package:supercab/utils/userController.dart';
import 'package:supercab/DataSource/Source.dart';


class Airport extends StatefulWidget {
  @override
  _AirportState createState() => _AirportState();
}

class _AirportState extends State<Airport> {
  var userLocationLatLng;
  var userLatitude, userLongitude;

  bool isAirportSelected;

  var myLocation;
  CurrentUser user;

  var myLocationLatitude, myLocationLongitude;
  var myLocationLatLng;
  String searchAddress;
  final formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();

  bool isDestinationSelected;
  bool fromSearch = false;

  bool enableButton = false;

  String selectedAirportName;
  String selectedAirportNameForCity;
  String searchedPalce;
  bool currentLocation = true;
  bool isValidAddress = false;
  bool fromAirportToCBD = false;

  bool isMelbourneAirports = false;

  List<Widget> widgetList;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void getMyLocation(String lang) async{

    await Geolocator().getCurrentPosition().then((currentLocation) async {

      myLocation = currentLocation;

      userLatitude = currentLocation.latitude;
      userLongitude = currentLocation.longitude;
      userLocationLatLng = LatLng(currentLocation.latitude, currentLocation.longitude);

      await getUserCurrentLocationAddress(userLocationLatLng, API_KEY, lang);
      setState(() {});

    });
  }

  getUserCurrentLocationAddress(location, apiKey, String lang) async {
    await getAddressName(location, apiKey, lang);
  }

  Future<String> getAddressName(LatLng location, String apiKey, String lang) async {
    try {
      var endPoint = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&language=$lang&key=$apiKey';
      var response = jsonDecode((await get(Uri.parse(endPoint), headers: await LocationUtils.getAppHeaders())).body);
      //AirportAddress airportAddress = airportAddressFromJson(response);
      var _address = response['results'][0]['formatted_address'];

     //  airportAddress.results[0].addressComponents.where((element) => element.longName.contains(melbournePriceList.where((element) => element.locationName)))
     // if(con){
     //   print('*********8');
     //   print(airportAddress.results[0].addressComponents[0].longName);
     // }

      List<dynamic> _place = response['results'][0]['address_components'];
      searchedPalce = _place.firstWhere((entry) => entry['types'].contains('locality'))['long_name'];

      bool check =  melbournePriceList.any((element) {
        return element.locationName.contains(searchedPalce);
      });

      isValidAddress = check;

      print('*************');
      print(check.toString());

      print('Current Address : ' + _address);

      user.areaNameForAirport = searchedPalce;

      fromController.text = _address;
      user.userCurrentAddress = _address;
      enableButton =true;

      return _address;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    getLanguage().then((value) {
      getMyLocation(mobileLanguage.value.languageCode);
    });

    user = Get.find<CurrentUser>();
    isAirportSelected = false;

    user.fromCityToAirport = true;
    user.fromAirportToCity = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          child: Stack(
            children: [

              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.50,
                  margin: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [

                      // user.fromCityToAirport
                      // ? Padding(
                      //   padding: const EdgeInsets.only(left: 15,right: 15,top: 75),
                      //   child: Text(S.of(context).Melbourne_Services,
                      //        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: yellow),),)
                      // : !isMelbourneAirports
                      // ? Padding(
                      //   padding: const EdgeInsets.only(left: 15,right: 15,top: 75),
                      //   child: Text(S.of(context).We_are_Offering_Services_to_Only_CBD_Areas,
                      //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: yellow),),)
                      // : SizedBox(height: 75,),


                      SizedBox(height: 175,),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.92,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: yellow,width: 0.8)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              S.of(context).All_Inclusive_Pricing +'!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 12,),

                            Text('${S.of(context).FixedFare}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.w500),),

                            SizedBox(height: 12,),
                            Text('${S.of(context).OtherCities}',maxLines: 6,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.w500),),

                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Spacer(),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20,right: 20, bottom: 10,top: 10),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: RaisedButton(
                            color:
                            enableButton == true ? yellow : Colors.lime[900],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            onPressed: enableButton ? () {
                              if (isAirportSelected) {

                                user.isAirportTransfer = true;
                                user.isHourlyTransfer = false;
                                user.isLocalTransfer = false;

                                if(isValidAddress)
                                  {
                                    Navigator.pushNamed(context, "/chooseVehicle",
                                        arguments: 'airport');
                                  }
                                else if(fromAirportToCBD)
                                  {
                                    Navigator.pushNamed(context, "/chooseVehicle",
                                        arguments: 'airport');
                                  }
                                else
                                  {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                        S.of(context).Invalid_Area_Location,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ));
                                  }
                              } else {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    S.of(context).Select_Airport,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ));
                              }
                            } : (){},
                            child: Text(
                              S.of(context).Estimated_Fare,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  color: Colors.black,
                  child: SingleChildScrollView(
                    child: user.fromCityToAirport
                        ?
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          if (currentLocation)
                            Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white)),
                                  margin: EdgeInsets.only(
                                      left: 10,right: 10, bottom: 0),
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        enableButton = false;
                                        currentLocation = !currentLocation;
                                      });
                                    },
                                    controller: fromController,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 5, left: 5, right: 5),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.my_location_sharp,
                                        color: Colors.grey,
                                      ),
                                      hintText: S.of(context).From,
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                )
                          else Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: ValueListenableBuilder(
                                    valueListenable: mobileLanguage,
                                    builder:(context, Locale lang,_) =>
                                    SearchMapPlaceWidget(
                                      apiKey: 'AIzaSyABFmjpW4zSizocefrOcxVOXjzr0kZNsmM',
                                      hintText: S.of(context).From,
                                      location: userLocationLatLng, //LatLng(userLocationLatLng.latitude, userLocationLatLng.longitude)
                                      radius: 50 * 100000,
                                      hasClearButton: true,
                                      strictBounds: true,
                                      language: lang.languageCode,
                                      onSelected: (place) async
                                      {
                                        setState(() {
                                          enableButton = false;
                                        });

                                        print(place.description);
                                        final geolocation = await place.geolocation;
                                        LatLng latLng = geolocation.coordinates;
                                        myLocationLatitude = latLng.latitude;
                                        myLocationLongitude = latLng.longitude;
                                        myLocationLatLng = LatLng(myLocationLatitude, myLocationLongitude);
                                        await getUserCurrentLocationAddress(myLocationLatLng, API_KEY, lang.languageCode);
                                        myLocation = geolocation.coordinates;
                                        userLocationLatLng = myLocationLatLng;
                                        user.userLocationLatLng = userLocationLatLng;
                                        setState(() {});

                                      },
                                    ),
                                  ),
                                ),

                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 5,left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               // Icon(Icons.arrow_downward_sharp,color: Colors.white,size: 18,),
                                IconButton(
                                  icon:Icon(Icons.wifi_protected_setup,color: Colors.white,),
                                  onPressed: ()
                                  {
                                    setState(() {
                                      user.fromCityToAirport = false;
                                      isValidAddress = false;
                                      user.fromAirportToCity = true;
                                    });
                                  },
                                ),
                                //SizedBox(),
                              ],
                            ),
                          ),

                          Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: DropdownButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  ),
                                  hint: Text(
                                    S.of(context).Select_Airport,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  elevation: 5,
                                  isExpanded: true,
                                  underline: Container(
                                    color: Colors.transparent,
                                  ),
                                  focusColor: Colors.white,
                                  dropdownColor: Colors.black,
                                  value: selectedAirportName,
                                  isDense: true,
                                  items: airPortNamesList(context).map((value) {
                                    return DropdownMenuItem(
                                        value: value.index,
                                        child: Text(
                                          value.name,
                                          style: TextStyle(color: yellow),
                                        ));
                                  }).toList(),
                                  onChanged: (input) {
                                    setState(() {
                                      isAirportSelected = true;
                                      selectedAirportName = input;
                                      user.selectedAirport = int.parse(input);

                                      print('************');
                                      print('Selected Airport Name : ' + user.selectedAirport.toString());
                                      print('************');

                                    });
                                  }),
                            ),
                          ),

                        ],
                      ),
                    )
                        :
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(color: Colors.white),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: DropdownButton(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  ),
                                  hint: Text(
                                    S.of(context).Select_Airport,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  elevation: 5,
                                  isExpanded: true,
                                  underline: Container(
                                    color: Colors.transparent,
                                  ),
                                  focusColor: Colors.white,
                                  dropdownColor: Colors.black,
                                  value: selectedAirportNameForCity,
                                  isDense: true,
                                  items: airPortNamesListForCity(context).map((value) {
                                    return DropdownMenuItem(
                                        value: value.index,
                                        child: Text(
                                          value.name,
                                          style: TextStyle(color: yellow),
                                        ));
                                  }).toList(),
                                  onChanged: (input) {
                                    setState(() {

                                      isAirportSelected = true;

                                      selectedAirportNameForCity = input;

                                      user.selectedAirport = int.parse(input);

                                      setState(() {
                                        if(input == '6')
                                          {
                                            isMelbourneAirports = true;
                                            fromAirportToCBD = false;
                                          }
                                        else if(input == '7')
                                          {
                                            isMelbourneAirports = true;
                                            fromAirportToCBD = false;
                                          }
                                        else
                                          {
                                            isMelbourneAirports = false;
                                            user.fromMelbourneAirportsToAreas = false;
                                            fromAirportToCBD = true;
                                            enableButton = true;
                                          }
                                      });

                                      print('************');
                                      print('Selected Airport Name : ' + user.selectedAirport.toString());
                                      print('************');
                                    });
                                  }),
                            ),
                          ),

                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 5,left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Icon(Icons.arrow_downward_sharp,color: Colors.white,size: 18,),
                                IconButton(
                                  icon:Icon(Icons.wifi_protected_setup,color: Colors.white,),
                                  onPressed: ()
                                  {
                                    setState(() {
                                      user.fromCityToAirport = true;
                                      fromAirportToCBD = false;
                                      user.fromAirportToCity = false;
                                    });
                                  },
                                ),
                                // SizedBox(),
                              ],
                            ),
                          ),

                          isMelbourneAirports
                              ? Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: ValueListenableBuilder(
                                    valueListenable: mobileLanguage,
                                    builder:(context, Locale lang,_)
                                    => SearchMapPlaceWidget(
                                      apiKey:
                                      'AIzaSyABFmjpW4zSizocefrOcxVOXjzr0kZNsmM',
                                      hintText: S.of(context).To,
                                      location: userLocationLatLng, //LatLng(userLocationLatLng.latitude, userLocationLatLng.longitude)
                                      radius: 50 * 100000,
                                      hasClearButton: true,
                                      strictBounds: true,
                                      language: lang.languageCode,
                                      onSelected: (place) async {

                                        setState(()
                                        {
                                          enableButton = false;
                                        });

                                        print(place.description);
                                        final geolocation = await place.geolocation;
                                        LatLng latLng = geolocation.coordinates;
                                        myLocationLatitude = latLng.latitude;
                                        myLocationLongitude = latLng.longitude;
                                        myLocationLatLng = LatLng(myLocationLatitude, myLocationLongitude);
                                        await getUserCurrentLocationAddress(myLocationLatLng, API_KEY,lang.languageCode);
                                        myLocation = geolocation.coordinates;
                                        userLocationLatLng = myLocationLatLng;
                                        user.userLocationLatLng = userLocationLatLng;

                                        user.fromMelbourneAirportsToAreas = true;
                                        //user.fromAirportToCity = false;

                                        setState(() {});

                                      },
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white,width: 1),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(S.of(context).City,style: TextStyle(color: Colors.white),),
                                ),

                        ],
                      ),
                    ),
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


