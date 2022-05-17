import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:supercab/utils/model/DistanceCal.dart';

Future<DistanceCal> fetchCartList(
    LatLng userLocationLatLng, LatLng destinationLocationLatLng, key) async {
  final client = new Client();
  final response = await client.get(
        Uri.parse("https://maps.googleapis.com/maps/api/directions/json?key=$key&origin=${userLocationLatLng.latitude},${userLocationLatLng.longitude}&destination=${destinationLocationLatLng.latitude},${destinationLocationLatLng.longitude}&units=metric"),
      headers: {});
  if (response.statusCode == 200) {
    return distanceCalFromJson(response.body);
  } else {
    throw response.body;
  }
}
