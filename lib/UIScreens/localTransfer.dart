
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:supercab/Repo/DistanceApi.dart';
import 'package:supercab/generated/l10n.dart';
import 'package:supercab/utils/constants.dart';
import 'package:supercab/utils/location_utils.dart';
import 'package:supercab/utils/model/DistanceCal.dart';
import 'package:supercab/utils/userController.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:supercab/helper/src/searchMapPlaceWidget.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:supercab/UIScreens/chooseVehicle.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';
import 'dart:convert';


class LocalTransfer extends StatefulWidget {
  @override
  _LocalTransferState createState() => _LocalTransferState();
}

class _LocalTransferState extends State<LocalTransfer> {

  CameraPosition initialCameraPosition;
  var myLocation, myLocationLatitude, myLocationLongitude;
  var fromLocation, fromLocationLatitude, fromLocationLongitude;
  var myLocationLatLng, fromLocationLatLng;
  Set<Marker> markers;
  List<LatLng> polyLinesCoordinates = [];
  var userLocationLatLng = LatLng(0.0, 0.0);
  var startingUserLocationLatLng = LatLng(0.0, 0.0);
  var userLatitude, userLongitude;
  var destinationLatitude, destinationLongitude;
  var destinationLocationLatLng;
  GoogleMapController controller;
  String searchAddress;
  CurrentUser user;

  int newDistance = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController = TextEditingController();

  bool isMapLoaded = false;
  bool isDestinationSelected;
  bool fromSearch = false;

  var clientLatitude = -37.770666;
  var clientLongitude = 144.775025;

  var clientDestinationLatitude = -37.88579;
  var clientDestinationLongitude = 145.08477;

  /*CardDetails _cardDetails;

  Future<void> scanCard() async {
    var cardDetails =
    await CardScanner.scanCard(scanOptions: CardScanOptions(scanCardHolderName: true));

    if (!mounted) return;
    setState(() {
      _cardDetails = cardDetails;
    });
    Navigator.of(context).pop();
    print(_cardDetails.toString());
  }*/
  /*
  void searchAndNavigate() {
    Geolocator().placemarkFromAddress(searchAddress).then((result) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: getZoomLevel(capRadius(10.0 * 1000)))));

      // for markers and polyLines
      destinationLatitude = result[0].position.latitude;
      destinationLongitude = result[0].position.longitude;
      destinationLocationLatLng =
          LatLng(result[0].position.latitude, result[0].position.longitude);

      LatLng latLang =
          LatLng(result[0].position.latitude, result[0].position.longitude);

      markers.add(Marker(
          markerId: MarkerId(result.toString()),
          position: latLang,
          icon: BitmapDescriptor.defaultMarkerWithHue(0)));
      double totalDistance =
          distance(userLocationLatLng, destinationLocationLatLng);
      user.totalKilometers = totalDistance;
      setState(() {
        isDestinationSelected = true;
      });
    }).catchError((onError) {
      setState(() {
        isDestinationSelected = false;
      });

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Invalid Destination Address!',
          style: TextStyle(color: Colors.white),
        ),
      ));
    });
  }
*/

  static double distance(LatLng currentLocation, LatLng destinationLocation) {
    final destLat = degreesToRadians(
        destinationLocation.latitude - currentLocation.latitude);
    final destLng = degreesToRadians(
        destinationLocation.longitude - currentLocation.longitude);
    final lat1 = degreesToRadians(currentLocation.latitude);
    final lat2 = degreesToRadians(destinationLocation.latitude);
    final r = 6378.137; // WGS84 major axis
    double c = 2 *
        asin(sqrt(pow(sin(destLat / 2), 2) +
            cos(lat1) * cos(lat2) * pow(sin(destLng / 2), 2)));
    return r * c;
  }

  static double degreesToRadians(double degrees) {
    return (degrees * pi) / 180;
  }

  static double capRadius(double radius) {
    if (radius > MAX_SUPPORTED_RADIUS) {
      print("The radius is bigger than $MAX_SUPPORTED_RADIUS and hence we'll use that value");
      return MAX_SUPPORTED_RADIUS.toDouble();
    }
    return radius;
  }

  double getZoomLevel(double radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - log(scale) / log(2);
    }
    zoomLevel = num.parse(zoomLevel.toStringAsFixed(2));
    return zoomLevel;
  }

  Future<void> getMyLocation() async {
     await Geolocator().getCurrentPosition().then((currentLocation) async {
      myLocation = currentLocation;
      isMapLoaded = true;
      userLatitude = currentLocation.latitude;
      userLongitude = currentLocation.longitude;
      userLocationLatLng = LatLng(currentLocation.latitude, currentLocation.longitude);
      startingUserLocationLatLng = LatLng(currentLocation.latitude, currentLocation.longitude);

      user.userLocationLatLng = userLocationLatLng;

      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: getZoomLevel(50.0 * 1000));


      markers.add(Marker(
          markerId: MarkerId('1'),
          position: userLocationLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(45)));

      await getUserCurrentLocationAddress(userLocationLatLng, API_KEY);

      setState(() {});

     });
  }

  getUserCurrentLocationAddress(location, apiKey) async {
    await getAddressName(location, apiKey);
  }

  Future<String> getAddressName(LatLng location, String apiKey) async {
    try {
      var endPoint = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&language=en&key=$apiKey';
      var response = jsonDecode((await get(Uri.parse(endPoint), headers: await LocationUtils.getAppHeaders())).body);
      var _address = response['results'][0]['formatted_address'];
      fromController.text = _address;
      user.userCurrentAddress = _address;
      print('Current Address : ' + user.userCurrentAddress.toString());
      return _address;
    } catch (e) {
      print(e);
      return null;
    }
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  void _onMapCreated(GoogleMapController mapController) {
    setState(() {
      controller = mapController;
    });
  }

  void initState() {
    super.initState();
    user = Get.find<CurrentUser>();
    markers = Set<Marker>();
    getMyLocation();
    isDestinationSelected = false;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyABFmjpW4zSizocefrOcxVOXjzr0kZNsmM',
      // PointLatLng(clientLatitude, clientLongitude),
      // PointLatLng(clientDestinationLatitude, clientDestinationLongitude),
      PointLatLng(myLocation.latitude, myLocation.longitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.walking,
    );
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _addPolyLine();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [

          Container(
            height: 100,
            child: isMapLoaded == true
                ? GoogleMap(
                    initialCameraPosition: initialCameraPosition,
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    markers: markers,
                    myLocationButtonEnabled: false,
                    polylines: Set<Polyline>.of(polylines.values),
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      new Factory<OneSequenceGestureRecognizer>(
                        () => new EagerGestureRecognizer(),
                      ),
                    ].toSet(),
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                  )
                : Center(
                    child: Text(
                      S.of(context).Map_is_Loading,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.black,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  !fromSearch
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)),
                            child: TextField(
                              controller: fromController,
                              onTap: () => setState(() {
                                fromSearch = !fromSearch;

                                Marker marker = markers.firstWhere((marker) => marker.markerId.value == "2",orElse: () => null);

                                setState(() {
                                  polylineCoordinates.clear();
                                  isDestinationSelected = false;
                                  markers.remove(marker);
                                  //user.userLocationLatLng = startingUserLocationLatLng;
                                  //controller.animateCamera(CameraUpdate.newLatLng(startingUserLocationLatLng));
                                });

                              }),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                border: InputBorder.none,
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.my_location_sharp),
                                  color: Colors.grey,
                                  onPressed: () {
                                    getMyLocation();
                                  },
                                ),
                                hintText: S.of(context).From,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: SearchMapPlaceWidget(
                            apiKey: 'AIzaSyABFmjpW4zSizocefrOcxVOXjzr0kZNsmM',
                            hintText: S.of(context).From,
                            location: LatLng(userLocationLatLng.latitude, userLocationLatLng.longitude),
                            radius: 50 * 100000,
                            hasClearButton: true,
                            strictBounds: true,
                            onSelected: (place) async {

                              final geolocation = await place.geolocation;
                              controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
                              LatLng latLng = geolocation.coordinates;
                              myLocationLatitude = latLng.latitude;
                              myLocationLongitude = latLng.longitude;
                              myLocationLatLng = LatLng(myLocationLatitude, myLocationLongitude);
                              setState(() {
                                myLocation = geolocation.coordinates;
                                userLocationLatLng = myLocationLatLng;
                                user.userLocationLatLng = userLocationLatLng;
                              });

                              getUserCurrentLocationAddress(user.userLocationLatLng, API_KEY);

                              markers.add(Marker(
                                  markerId: MarkerId('1'),
                                  position: LatLng(
                                      myLocationLatitude, myLocationLongitude),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      45))
                              );

                              setState(() {});
                            },
                          ),
                        ),
                  SearchMapPlaceWidget(
                    apiKey: 'AIzaSyABFmjpW4zSizocefrOcxVOXjzr0kZNsmM',
                    hintText: S.of(context).To,
                    location: LatLng(userLocationLatLng.latitude, userLocationLatLng.longitude),
                    radius: 50 * 100000,
                    hasClearButton: true,
                    strictBounds: true,
                    onSelected: (place) async {

                      final geolocation = await place.geolocation;
                      LatLng latLng = geolocation.coordinates;
                      destinationLatitude = latLng.latitude;
                      destinationLongitude = latLng.longitude;
                      destinationLocationLatLng = LatLng(destinationLatitude, destinationLongitude);

                      // destinationLocationLatLng = LatLng(clientDestinationLatitude, clientDestinationLongitude);

                      DistanceCal dis = await fetchCartList(userLocationLatLng, destinationLocationLatLng, "AIzaSyABFmjpW4zSizocefrOcxVOXjzr0kZNsmM");

                      newDistance = dis.routes[0].legs[0].distance.value;

                      controller.animateCamera(CameraUpdate.newLatLngZoom(
                          userLocationLatLng,
                          getZoomLevel(newDistance.toDouble()))
                      );

                      markers.add(Marker(
                          markerId: MarkerId('2'),
                          position:
                              LatLng(destinationLatitude, destinationLongitude),
                          icon: BitmapDescriptor.defaultMarkerWithHue(0))
                      );

                      _getPolyline();

                      user.totalKilometers = (newDistance ~/ 1000);

                      final coordinates = new Coordinates(destinationLatitude, destinationLongitude);
                      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                      var first = addresses.first;
                      user.userDestinationAddress = first.locality; //+ ',' + first.subLocality;
                      print('Destination Address : ' + user.userDestinationAddress.toString());
                      setState(() {
                        isDestinationSelected = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          isDestinationSelected
              ? Positioned(
                  right: 12,
                  top: 125,
                  child: Container(
                    decoration: BoxDecoration(color: yellow, borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '${S.of(context).Distance} : ${user.totalKilometers} ${S.of(context).Km}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : SizedBox(),

          fromSearch
              ? Positioned(
                  bottom: 75,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle
                    ),
                    child: IconButton(
                      icon: Icon(Icons.my_location_sharp,color: yellow,),
                      onPressed: ()
                      {

                        fromSearch = false;
                        Marker marker = markers.firstWhere((marker) => marker.markerId.value == "2",orElse: () => null);

                        setState(() {
                          getMyLocation();
                          polylineCoordinates.clear();

                          isDestinationSelected = false;

                          markers.remove(marker);
                          user.userLocationLatLng = startingUserLocationLatLng;
                          controller.animateCamera(CameraUpdate.newLatLng(startingUserLocationLatLng));

                        });
                      },
                    ),
                  ),)
              : SizedBox(),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              color: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: RaisedButton(
                  color: isDestinationSelected == true ? yellow : Colors.lime[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onPressed: isDestinationSelected == true
                      ? () {

                          // double pricePerKM = 2.30;
                          // double totalKMCost = pricePerKM * user.totalKilometers;
                          // double totalPrice = totalKMCost + 15;

                          user.isLocalTransfer = true;
                          user.isHourlyTransfer = false;
                          user.isAirportTransfer = false;
                          SchedulerBinding.instance
                              .addPostFrameCallback((timeStamp) async {
                            await Future.delayed(Duration.zero);
                            Navigator.pushNamed(context, "/chooseVehicle",
                                arguments: 'local');
                          });

                          /*if(totalPrice > 50)
                            {
                              user.isLocalTransfer = true;
                              user.isHourlyTransfer = false;
                              user.isAirportTransfer = false;
                              SchedulerBinding.instance
                                  .addPostFrameCallback((timeStamp) async {
                                await Future.delayed(Duration.zero);
                                Navigator.pushNamed(context, "/chooseVehicle",
                                    arguments: 'local');
                              });
                            }
                          else
                            {

                              // showDialog(
                              //   context: context, builder: (BuildContext context) {
                              //     return  AlertDialog(
                              //       backgroundColor: Colors.black,
                              //       title: Center(child: Text('Sorry',style: TextStyle(color: yellow),)),
                              //       content: Text('Your Estimated Fare is less than standard fare....',style: TextStyle(color: Colors.white),),
                              //       actions:
                              //       [
                              //         FlatButton(
                              //             onPressed: ()
                              //             {
                              //               Navigator.of(context).pop();
                              //             },
                              //             child: Text('OK',style: TextStyle(color: yellow),)
                              //         ),
                              //       ],
                              //     );
                              // },);
                            }*/

                        }
                      : () {},
                  child: Text(
                    S.of(context).Estimated_Fare,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
