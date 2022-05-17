import 'package:get/get.dart';

class CurrentUser extends GetxController {
  // User Data
  String userName;
  String userEmail;
  String userPhone;
  String currentUserId;
  bool alreadyGetDiscount = false;

  // Local Transfer Variables
  String selectedVehicle;
  int selectedVehiclePrice;
  int totalKilometers;
  int totalCostOfLocalTransfer;
  bool isLocalTransfer = false;
  int userAlreadySelectedPrice = 0;
  String localBookingDate;
  String localBookingTime;
  String localBookingComments;


  bool isLocalTransferPreBooking = false;
  bool isMidSeatPreBooking = false;
  int babySeatPreBooking = 0;
  int boosterSeatPreBooking = 0;
  String preBookingComments;
  String preBookingDate;
  String preBookingTime;

  // bool isAlreadySelectedVehicle = true;

  // Hourly Transfer Variables
  bool isHourlyTransfer = false;
  int selectedCity;
  int selectedHours;
  String hourlyBookingDate;
  String hourlyBookingTime;

  // AirportFare Variables
  bool isAirportTransfer = false;
  int selectedAirport;
  int areaPriceForAirport;
  String airportBookingDate;
  String airportBookingTime;
  bool isMidSeat = false;
  int babySeat = 0;
  int boosterSeat = 0;
  String airportBookingComments;
  String areaNameForAirport;
  bool fromCityToAirport;
  bool fromAirportToCity;
  bool fromMelbourneAirportsToAreas = false;

  // user Location data
  var userLocationLatLng;
  String userCurrentAddress;
  String userDestinationAddress;


  String userBookingType;
  String userBookingID;
  // add methods to store data in fireStore according to transfer type
}
