// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `SuperCab`
  String get app_name {
    return Intl.message(
      'SuperCab',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Name {
    return Intl.message(
      'Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get Phone {
    return Intl.message(
      'Phone',
      name: 'Phone',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get Accept {
    return Intl.message(
      'Accept',
      name: 'Accept',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get Yes {
    return Intl.message(
      'Yes',
      name: 'Yes',
      desc: '',
      args: [],
    );
  }

  /// `Decline`
  String get Decline {
    return Intl.message(
      'Decline',
      name: 'Decline',
      desc: '',
      args: [],
    );
  }

  /// `Save Card`
  String get Save_Card {
    return Intl.message(
      'Save Card',
      name: 'Save_Card',
      desc: '',
      args: [],
    );
  }

  /// `Thank You`
  String get Thank_You {
    return Intl.message(
      'Thank You',
      name: 'Thank_You',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get Ok {
    return Intl.message(
      'Ok',
      name: 'Ok',
      desc: '',
      args: [],
    );
  }

  /// `Our Rates`
  String get Our_Rates {
    return Intl.message(
      'Our Rates',
      name: 'Our_Rates',
      desc: '',
      args: [],
    );
  }

  /// `Sedan`
  String get Sedan {
    return Intl.message(
      'Sedan',
      name: 'Sedan',
      desc: '',
      args: [],
    );
  }

  /// `Prestige`
  String get Prestige {
    return Intl.message(
      'Prestige',
      name: 'Prestige',
      desc: '',
      args: [],
    );
  }

  /// `SUV`
  String get suv {
    return Intl.message(
      'SUV',
      name: 'suv',
      desc: '',
      args: [],
    );
  }

  /// `VAN`
  String get VAN {
    return Intl.message(
      'VAN',
      name: 'VAN',
      desc: '',
      args: [],
    );
  }

  /// `SuperCab currently provides Fixed Fare service for all Metropolitan Melbourne Areas To/From Airport.`
  String get FixedFare {
    return Intl.message(
      'SuperCab currently provides Fixed Fare service for all Metropolitan Melbourne Areas To/From Airport.',
      name: 'FixedFare',
      desc: '',
      args: [],
    );
  }

  /// `For other Australian cities we currently have fixed fares To/From CBD and Airport. For other Areas and regional please use Request a Quote feature and we will reply with Custom Quote in 30 mins.`
  String get OtherCities {
    return Intl.message(
      'For other Australian cities we currently have fixed fares To/From CBD and Airport. For other Areas and regional please use Request a Quote feature and we will reply with Custom Quote in 30 mins.',
      name: 'OtherCities',
      desc: '',
      args: [],
    );
  }

  /// `Minimum Fare`
  String get Minimum_Fare {
    return Intl.message(
      'Minimum Fare',
      name: 'Minimum_Fare',
      desc: '',
      args: [],
    );
  }

  /// `SuperCab All Inclusive Fares include 10 min free Waiting Time, Tolls, Gst.`
  String get SuperCab_All_Inclusive_Fares_include_10_min_free_Waiting_Time {
    return Intl.message(
      'SuperCab All Inclusive Fares include 10 min free Waiting Time, Tolls, Gst.',
      name: 'SuperCab_All_Inclusive_Fares_include_10_min_free_Waiting_Time',
      desc: '',
      args: [],
    );
  }

  /// `SuperCab currently provides Fixed Fare service for all Metropolitan Melbourne Areas to/from Airport For other Australian cities  we currently have fixed fares to/from CBD and Airport . For other Areas and regional, please use Request a Quote feature and we will reply with Custom Quote in 30 mins.`
  String get SuperCab_currently_provides_Fixed_Fare_service_for_all_Metropolitan_Melbourne_Areas_to_from_Airport_For_other_Australian_cities_we_currently_have_fixed_fares_to_from_CBD_and_Airport_For_other_Areas_and_regional_please_use_Request_a_Quote_feature_and_we_will_reply_with_Custom_Quote_in_30mins {
    return Intl.message(
      'SuperCab currently provides Fixed Fare service for all Metropolitan Melbourne Areas to/from Airport For other Australian cities  we currently have fixed fares to/from CBD and Airport . For other Areas and regional, please use Request a Quote feature and we will reply with Custom Quote in 30 mins.',
      name: 'SuperCab_currently_provides_Fixed_Fare_service_for_all_Metropolitan_Melbourne_Areas_to_from_Airport_For_other_Australian_cities_we_currently_have_fixed_fares_to_from_CBD_and_Airport_For_other_Areas_and_regional_please_use_Request_a_Quote_feature_and_we_will_reply_with_Custom_Quote_in_30mins',
      desc: '',
      args: [],
    );
  }

  /// `We are Offering Services to Only Melbourne Airports!`
  String get Melbourne_Services {
    return Intl.message(
      'We are Offering Services to Only Melbourne Airports!',
      name: 'Melbourne_Services',
      desc: '',
      args: [],
    );
  }

  /// `All Inclusive Pricing`
  String get All_Inclusive_Pricing {
    return Intl.message(
      'All Inclusive Pricing',
      name: 'All_Inclusive_Pricing',
      desc: '',
      args: [],
    );
  }

  /// `We are Offering Services to Only CBD Areas!`
  String get We_are_Offering_Services_to_Only_CBD_Areas {
    return Intl.message(
      'We are Offering Services to Only CBD Areas!',
      name: 'We_are_Offering_Services_to_Only_CBD_Areas',
      desc: '',
      args: [],
    );
  }

  /// `You will receive a confirmation shortly with Driver Details and Estimated Arrival Time`
  String get Booking_Confirmation_Message {
    return Intl.message(
      'You will receive a confirmation shortly with Driver Details and Estimated Arrival Time',
      name: 'Booking_Confirmation_Message',
      desc: '',
      args: [],
    );
  }

  /// `All inclusive fares including 10 mints free waiting time, Tolls, GST and EFTpos free`
  String get All_inclusive_fares_including_10_mints_free_waiting_time_Tolls_GST_and_EFTpos_free {
    return Intl.message(
      'All inclusive fares including 10 mints free waiting time, Tolls, GST and EFTpos free',
      name: 'All_inclusive_fares_including_10_mints_free_waiting_time_Tolls_GST_and_EFTpos_free',
      desc: '',
      args: [],
    );
  }

  /// `Melbourne Tullamarine Airport`
  String get Melbourne_Tullamarine_Airport {
    return Intl.message(
      'Melbourne Tullamarine Airport',
      name: 'Melbourne_Tullamarine_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Melbourne Avalon Airport`
  String get Melbourne_Avalon_Airport {
    return Intl.message(
      'Melbourne Avalon Airport',
      name: 'Melbourne_Avalon_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Adelaide Airport`
  String get Adelaide_Airport {
    return Intl.message(
      'Adelaide Airport',
      name: 'Adelaide_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Brisbane Airport`
  String get Brisbane_Airport {
    return Intl.message(
      'Brisbane Airport',
      name: 'Brisbane_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Canberra Airport`
  String get Canberra_Airport {
    return Intl.message(
      'Canberra Airport',
      name: 'Canberra_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Cairns Airport`
  String get Cairns_Airport {
    return Intl.message(
      'Cairns Airport',
      name: 'Cairns_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Darwin Airport`
  String get Darwin_Airport {
    return Intl.message(
      'Darwin Airport',
      name: 'Darwin_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Gold Cost Airport`
  String get Gold_Cost_Airport {
    return Intl.message(
      'Gold Cost Airport',
      name: 'Gold_Cost_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Perth Airport`
  String get Perth_Airport {
    return Intl.message(
      'Perth Airport',
      name: 'Perth_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Sydney Airport`
  String get Sydney_Airport {
    return Intl.message(
      'Sydney Airport',
      name: 'Sydney_Airport',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Current_Address ' key

  /// `Want the flexibility of upfront fixed fares without any worry of surge pricing or variations`
  String get Want_the_flexibility_of_upfront_fixed_fares_without_any_worry_of_surge_pricing_or_variations {
    return Intl.message(
      'Want the flexibility of upfront fixed fares without any worry of surge pricing or variations',
      name: 'Want_the_flexibility_of_upfront_fixed_fares_without_any_worry_of_surge_pricing_or_variations',
      desc: '',
      args: [],
    );
  }

  /// `Airport`
  String get airport {
    return Intl.message(
      'Airport',
      name: 'airport',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Destination Area!`
  String get Invalid_Area_Location {
    return Intl.message(
      'Invalid Destination Area!',
      name: 'Invalid_Area_Location',
      desc: '',
      args: [],
    );
  }

  /// `Select Airport`
  String get Select_Airport {
    return Intl.message(
      'Select Airport',
      name: 'Select_Airport',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Fare`
  String get Estimated_Fare {
    return Intl.message(
      'Estimated Fare',
      name: 'Estimated_Fare',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get From {
    return Intl.message(
      'From',
      name: 'From',
      desc: '',
      args: [],
    );
  }

  /// `Selected Airport Name`
  String get Selected_Airport_Name {
    return Intl.message(
      'Selected Airport Name',
      name: 'Selected_Airport_Name',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get City {
    return Intl.message(
      'City',
      name: 'City',
      desc: '',
      args: [],
    );
  }

  /// `Local Transfer`
  String get Local_Transfer {
    return Intl.message(
      'Local Transfer',
      name: 'Local_Transfer',
      desc: '',
      args: [],
    );
  }

  /// `Airport Fare`
  String get Airport_Fare {
    return Intl.message(
      'Airport Fare',
      name: 'Airport_Fare',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get No {
    return Intl.message(
      'No',
      name: 'No',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get Pending {
    return Intl.message(
      'Pending',
      name: 'Pending',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get name {
    return Intl.message(
      'name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `phone`
  String get phone {
    return Intl.message(
      'phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email {
    return Intl.message(
      'email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `vehicle`
  String get vehicle {
    return Intl.message(
      'vehicle',
      name: 'vehicle',
      desc: '',
      args: [],
    );
  }

  /// `trip Cost`
  String get trip_Cost {
    return Intl.message(
      'trip Cost',
      name: 'trip_Cost',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get day {
    return Intl.message(
      'day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `time`
  String get time {
    return Intl.message(
      'time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `baby Seat`
  String get baby_Seat {
    return Intl.message(
      'baby Seat',
      name: 'baby_Seat',
      desc: '',
      args: [],
    );
  }

  /// `booster_Seat`
  String get booster_Seat {
    return Intl.message(
      'booster_Seat',
      name: 'booster_Seat',
      desc: '',
      args: [],
    );
  }

  /// `midNight Pickup`
  String get midNight_Pickup {
    return Intl.message(
      'midNight Pickup',
      name: 'midNight_Pickup',
      desc: '',
      args: [],
    );
  }

  /// `comment`
  String get comment {
    return Intl.message(
      'comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `current User ID`
  String get current_User_ID {
    return Intl.message(
      'current User ID',
      name: 'current_User_ID',
      desc: '',
      args: [],
    );
  }

  /// `transfer Type`
  String get transfer_Type {
    return Intl.message(
      'transfer Type',
      name: 'transfer_Type',
      desc: '',
      args: [],
    );
  }

  /// `time Stamp`
  String get time_Stamp {
    return Intl.message(
      'time Stamp',
      name: 'time_Stamp',
      desc: '',
      args: [],
    );
  }

  /// `booking Status`
  String get booking_Status {
    return Intl.message(
      'booking Status',
      name: 'booking_Status',
      desc: '',
      args: [],
    );
  }

  /// `Label`
  String get Label {
    return Intl.message(
      'Label',
      name: 'Label',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get Alert {
    return Intl.message(
      'Alert',
      name: 'Alert',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message(
      'Email',
      name: 'Email',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get Phone_Number {
    return Intl.message(
      'Phone Number',
      name: 'Phone_Number',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message(
      'Save',
      name: 'Save',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Error Fetching Data`
  String get Error_Fetching_Data {
    return Intl.message(
      'Error Fetching Data',
      name: 'Error_Fetching_Data',
      desc: '',
      args: [],
    );
  }

  /// `Booking`
  String get Booking {
    return Intl.message(
      'Booking',
      name: 'Booking',
      desc: '',
      args: [],
    );
  }

  /// `Airport Pickup`
  String get Airport_Pickup {
    return Intl.message(
      'Airport Pickup',
      name: 'Airport_Pickup',
      desc: '',
      args: [],
    );
  }

  /// `Flight No`
  String get Flight_no {
    return Intl.message(
      'Flight No',
      name: 'Flight_no',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get Date {
    return Intl.message(
      'Date',
      name: 'Date',
      desc: '',
      args: [],
    );
  }

  /// `Not Selected`
  String get Not_Selected {
    return Intl.message(
      'Not Selected',
      name: 'Not_Selected',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get Time {
    return Intl.message(
      'Time',
      name: 'Time',
      desc: '',
      args: [],
    );
  }

  /// `Am`
  String get AM {
    return Intl.message(
      'Am',
      name: 'AM',
      desc: '',
      args: [],
    );
  }

  /// `PM`
  String get PM {
    return Intl.message(
      'PM',
      name: 'PM',
      desc: '',
      args: [],
    );
  }

  /// `Baby Seat`
  String get Baby_Seat {
    return Intl.message(
      'Baby Seat',
      name: 'Baby_Seat',
      desc: '',
      args: [],
    );
  }

  /// `Midnight 5 AM PickUp Sucharge`
  String get MidNight_5_AM_pick_up_sucharge {
    return Intl.message(
      'Midnight 5 AM PickUp Sucharge',
      name: 'MidNight_5_AM_pick_up_sucharge',
      desc: '',
      args: [],
    );
  }

  /// `Pick up Instructions`
  String get Pick_up_instructions {
    return Intl.message(
      'Pick up Instructions',
      name: 'Pick_up_instructions',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Payment`
  String get Proceed_to_Payment {
    return Intl.message(
      'Proceed to Payment',
      name: 'Proceed_to_Payment',
      desc: '',
      args: [],
    );
  }

  /// `Some Error`
  String get Some_Error {
    return Intl.message(
      'Some Error',
      name: 'Some_Error',
      desc: '',
      args: [],
    );
  }

  /// `Booking Type : `
  String get Booking_Type {
    return Intl.message(
      'Booking Type : ',
      name: 'Booking_Type',
      desc: '',
      args: [],
    );
  }

  /// `city To Airport`
  String get cityToAirport {
    return Intl.message(
      'city To Airport',
      name: 'cityToAirport',
      desc: '',
      args: [],
    );
  }

  /// `Mid Night PickUp`
  String get MidNightPickUp {
    return Intl.message(
      'Mid Night PickUp',
      name: 'MidNightPickUp',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Total_Cost ' key

  /// `Booking Status`
  String get Booking_Status {
    return Intl.message(
      'Booking Status',
      name: 'Booking_Status',
      desc: '',
      args: [],
    );
  }

  /// `Book Now`
  String get Book_Now {
    return Intl.message(
      'Book Now',
      name: 'Book_Now',
      desc: '',
      args: [],
    );
  }

  /// `Reorder`
  String get Reorder {
    return Intl.message(
      'Reorder',
      name: 'Reorder',
      desc: '',
      args: [],
    );
  }

  /// `Contact Details`
  String get Contact_Details {
    return Intl.message(
      'Contact Details',
      name: 'Contact_Details',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'smith_@_gmail.com' key

  /// `Selected vehicle class`
  String get Selected_vehicle_class {
    return Intl.message(
      'Selected vehicle class',
      name: 'Selected_vehicle_class',
      desc: '',
      args: [],
    );
  }

  /// `Trip Cost`
  String get Trip_Cost {
    return Intl.message(
      'Trip Cost',
      name: 'Trip_Cost',
      desc: '',
      args: [],
    );
  }

  /// `Invoice Billing Details`
  String get Invoice_Billing_Details {
    return Intl.message(
      'Invoice Billing Details',
      name: 'Invoice_Billing_Details',
      desc: '',
      args: [],
    );
  }

  /// `Same as above`
  String get Same_as_above {
    return Intl.message(
      'Same as above',
      name: 'Same_as_above',
      desc: '',
      args: [],
    );
  }

  /// `Company Name`
  String get Company_Name {
    return Intl.message(
      'Company Name',
      name: 'Company_Name',
      desc: '',
      args: [],
    );
  }

  /// `Contact Name`
  String get Contact_Name {
    return Intl.message(
      'Contact Name',
      name: 'Contact_Name',
      desc: '',
      args: [],
    );
  }

  /// `Billing Address`
  String get Billing_Address {
    return Intl.message(
      'Billing Address',
      name: 'Billing_Address',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get State {
    return Intl.message(
      'State',
      name: 'State',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get Country {
    return Intl.message(
      'Country',
      name: 'Country',
      desc: '',
      args: [],
    );
  }

  /// `Ph`
  String get Ph {
    return Intl.message(
      'Ph',
      name: 'Ph',
      desc: '',
      args: [],
    );
  }

  /// `Payment Option`
  String get Payment_Option {
    return Intl.message(
      'Payment Option',
      name: 'Payment_Option',
      desc: '',
      args: [],
    );
  }

  /// `PayPal`
  String get Pay_Pal {
    return Intl.message(
      'PayPal',
      name: 'Pay_Pal',
      desc: '',
      args: [],
    );
  }

  /// `Use My Cash Balance`
  String get Use_My_Cash_Balance {
    return Intl.message(
      'Use My Cash Balance',
      name: 'Use_My_Cash_Balance',
      desc: '',
      args: [],
    );
  }

  /// `Promo Code`
  String get Promo_Code {
    return Intl.message(
      'Promo Code',
      name: 'Promo_Code',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get Total {
    return Intl.message(
      'Total',
      name: 'Total',
      desc: '',
      args: [],
    );
  }

  /// `Invoice & Booking`
  String get Place_Booking {
    return Intl.message(
      'Invoice & Booking',
      name: 'Place_Booking',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get Today {
    return Intl.message(
      'Today',
      name: 'Today',
      desc: '',
      args: [],
    );
  }

  /// `Updating Phone Number`
  String get Updating_Phone_Number {
    return Intl.message(
      'Updating Phone Number',
      name: 'Updating_Phone_Number',
      desc: '',
      args: [],
    );
  }

  /// `booknow`
  String get book_now {
    return Intl.message(
      'booknow',
      name: 'book_now',
      desc: '',
      args: [],
    );
  }

  /// `Lorem Ipsum`
  String get Lorem_Ipsum {
    return Intl.message(
      'Lorem Ipsum',
      name: 'Lorem_Ipsum',
      desc: '',
      args: [],
    );
  }

  /// `Selected Vehicle`
  String get Selected_Vehicle {
    return Intl.message(
      'Selected Vehicle',
      name: 'Selected_Vehicle',
      desc: '',
      args: [],
    );
  }

  /// `No Vehicle Selected`
  String get No_Vehicle_Selected {
    return Intl.message(
      'No Vehicle Selected',
      name: 'No_Vehicle_Selected',
      desc: '',
      args: [],
    );
  }

  /// `Required Field`
  String get Required_Field {
    return Intl.message(
      'Required Field',
      name: 'Required_Field',
      desc: '',
      args: [],
    );
  }

  /// `Additional Comments`
  String get Additional_Comments {
    return Intl.message(
      'Additional Comments',
      name: 'Additional_Comments',
      desc: '',
      args: [],
    );
  }

  /// `Business Sedan`
  String get Business_Sedan {
    return Intl.message(
      'Business Sedan',
      name: 'Business_Sedan',
      desc: '',
      args: [],
    );
  }

  /// `European Prestige`
  String get European_Prestige {
    return Intl.message(
      'European Prestige',
      name: 'European_Prestige',
      desc: '',
      args: [],
    );
  }

  /// `SUV`
  String get SUV {
    return Intl.message(
      'SUV',
      name: 'SUV',
      desc: '',
      args: [],
    );
  }

  /// `Mini Van`
  String get Mini_Van {
    return Intl.message(
      'Mini Van',
      name: 'Mini_Van',
      desc: '',
      args: [],
    );
  }

  /// `Select vehicle to proceed`
  String get Select_vehicle_to_proceed {
    return Intl.message(
      'Select vehicle to proceed',
      name: 'Select_vehicle_to_proceed',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get Contact {
    return Intl.message(
      'Contact',
      name: 'Contact',
      desc: '',
      args: [],
    );
  }

  /// `Contact Number`
  String get Contact_Number {
    return Intl.message(
      'Contact Number',
      name: 'Contact_Number',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Request a Quote`
  String get Request_a_Quote {
    return Intl.message(
      'Request a Quote',
      name: 'Request_a_Quote',
      desc: '',
      args: [],
    );
  }

  /// `Extra services`
  String get Extra_services {
    return Intl.message(
      'Extra services',
      name: 'Extra_services',
      desc: '',
      args: [],
    );
  }

  /// `Stretch Limo`
  String get Stretch_Limo {
    return Intl.message(
      'Stretch Limo',
      name: 'Stretch_Limo',
      desc: '',
      args: [],
    );
  }

  /// `Buses upto 60 PAX`
  String get Buses_upto_60_PAX {
    return Intl.message(
      'Buses upto 60 PAX',
      name: 'Buses_upto_60_PAX',
      desc: '',
      args: [],
    );
  }

  /// `Wedding and Party Quotes`
  String get Wedding_and_Party_Quotes {
    return Intl.message(
      'Wedding and Party Quotes',
      name: 'Wedding_and_Party_Quotes',
      desc: '',
      args: [],
    );
  }

  /// `Tours and Sight Seeing`
  String get Tours_and_Sight_Seeing {
    return Intl.message(
      'Tours and Sight Seeing',
      name: 'Tours_and_Sight_Seeing',
      desc: '',
      args: [],
    );
  }

  /// `Promotions`
  String get Promotions {
    return Intl.message(
      'Promotions',
      name: 'Promotions',
      desc: '',
      args: [],
    );
  }

  /// `Example share`
  String get Example_share {
    return Intl.message(
      'Example share',
      name: 'Example_share',
      desc: '',
      args: [],
    );
  }

  /// `Example share text`
  String get Example_share_text {
    return Intl.message(
      'Example share text',
      name: 'Example_share_text',
      desc: '',
      args: [],
    );
  }

  /// `Example Chooser Title`
  String get Example_Chooser_Title {
    return Intl.message(
      'Example Chooser Title',
      name: 'Example_Chooser_Title',
      desc: '',
      args: [],
    );
  }

  /// `Share & Earn`
  String get Share_us {
    return Intl.message(
      'Share & Earn',
      name: 'Share_us',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get My_Account {
    return Intl.message(
      'My Account',
      name: 'My_Account',
      desc: '',
      args: [],
    );
  }

  /// `My Bookings`
  String get My_Bookings {
    return Intl.message(
      'My Bookings',
      name: 'My_Bookings',
      desc: '',
      args: [],
    );
  }

  /// `My Cards`
  String get My_Cards {
    return Intl.message(
      'My Cards',
      name: 'My_Cards',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get Log_Out {
    return Intl.message(
      'Log Out',
      name: 'Log_Out',
      desc: '',
      args: [],
    );
  }

  /// `Estimate Fare`
  String get Estimate_Fare {
    return Intl.message(
      'Estimate Fare',
      name: 'Estimate_Fare',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'All_inclusive_fares_including_10_mints_free_waiting_time,_Tolls,_GST_and_EFT_pos_free' key

  /// `Seater Bus`
  String get bus {
    return Intl.message(
      'Seater Bus',
      name: 'bus',
      desc: '',
      args: [],
    );
  }

  /// `Wedding Hire`
  String get wedding {
    return Intl.message(
      'Wedding Hire',
      name: 'wedding',
      desc: '',
      args: [],
    );
  }

  /// `Tour Quote`
  String get tours {
    return Intl.message(
      'Tour Quote',
      name: 'tours',
      desc: '',
      args: [],
    );
  }

  /// `Additional Information`
  String get Additional_Information {
    return Intl.message(
      'Additional Information',
      name: 'Additional_Information',
      desc: '',
      args: [],
    );
  }

  /// `extraservice`
  String get extra_service {
    return Intl.message(
      'extraservice',
      name: 'extra_service',
      desc: '',
      args: [],
    );
  }

  /// `RESET PASSWORD`
  String get RESET_PASSWORD {
    return Intl.message(
      'RESET PASSWORD',
      name: 'RESET_PASSWORD',
      desc: '',
      args: [],
    );
  }

  /// `RESET PASSWORD LINK`
  String get RESET_PASSWORD_LINK {
    return Intl.message(
      'RESET PASSWORD LINK',
      name: 'RESET_PASSWORD_LINK',
      desc: '',
      args: [],
    );
  }

  /// `back`
  String get back {
    return Intl.message(
      'back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Transfer`
  String get Hourly_Transfer {
    return Intl.message(
      'Hourly Transfer',
      name: 'Hourly_Transfer',
      desc: '',
      args: [],
    );
  }

  /// `No Bookings`
  String get No_Bookings {
    return Intl.message(
      'No Bookings',
      name: 'No_Bookings',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get To {
    return Intl.message(
      'To',
      name: 'To',
      desc: '',
      args: [],
    );
  }

  /// `Total Cost`
  String get Total_Cost {
    return Intl.message(
      'Total Cost',
      name: 'Total_Cost',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get Comments {
    return Intl.message(
      'Comments',
      name: 'Comments',
      desc: '',
      args: [],
    );
  }

  /// `OutSide`
  String get Out_Side {
    return Intl.message(
      'OutSide',
      name: 'Out_Side',
      desc: '',
      args: [],
    );
  }

  /// `Non PromoCode`
  String get Non_Promo_Code {
    return Intl.message(
      'Non PromoCode',
      name: 'Non_Promo_Code',
      desc: '',
      args: [],
    );
  }

  /// `prebooking`
  String get pre_booking {
    return Intl.message(
      'prebooking',
      name: 'pre_booking',
      desc: '',
      args: [],
    );
  }

  /// `hourlyBooking`
  String get hourly_Booking {
    return Intl.message(
      'hourlyBooking',
      name: 'hourly_Booking',
      desc: '',
      args: [],
    );
  }

  /// `airPortBooking`
  String get air_Port_Booking {
    return Intl.message(
      'airPortBooking',
      name: 'air_Port_Booking',
      desc: '',
      args: [],
    );
  }

  /// `driverContact`
  String get driver_Contact {
    return Intl.message(
      'driverContact',
      name: 'driver_Contact',
      desc: '',
      args: [],
    );
  }

  /// `drivervehicleNumber`
  String get driver_vehicle_Number {
    return Intl.message(
      'drivervehicleNumber',
      name: 'driver_vehicle_Number',
      desc: '',
      args: [],
    );
  }

  /// `arrivalTime`
  String get arrival_Time {
    return Intl.message(
      'arrivalTime',
      name: 'arrival_Time',
      desc: '',
      args: [],
    );
  }

  /// `bookingStatus`
  String get bookingStatus {
    return Intl.message(
      'bookingStatus',
      name: 'bookingStatus',
      desc: '',
      args: [],
    );
  }

  /// `Melbourne`
  String get Melbourne {
    return Intl.message(
      'Melbourne',
      name: 'Melbourne',
      desc: '',
      args: [],
    );
  }

  /// `Sydney`
  String get Sydney {
    return Intl.message(
      'Sydney',
      name: 'Sydney',
      desc: '',
      args: [],
    );
  }

  /// `Adelaide`
  String get Adelaide {
    return Intl.message(
      'Adelaide',
      name: 'Adelaide',
      desc: '',
      args: [],
    );
  }

  /// `Perth`
  String get Perth {
    return Intl.message(
      'Perth',
      name: 'Perth',
      desc: '',
      args: [],
    );
  }

  /// `Brisbane`
  String get Brisbane {
    return Intl.message(
      'Brisbane',
      name: 'Brisbane',
      desc: '',
      args: [],
    );
  }

  /// `Canberra`
  String get Canberra {
    return Intl.message(
      'Canberra',
      name: 'Canberra',
      desc: '',
      args: [],
    );
  }

  /// `Darwin`
  String get Darwin {
    return Intl.message(
      'Darwin',
      name: 'Darwin',
      desc: '',
      args: [],
    );
  }

  /// `Gold Coast`
  String get Gold_Coast {
    return Intl.message(
      'Gold Coast',
      name: 'Gold_Coast',
      desc: '',
      args: [],
    );
  }

  /// `Cairns`
  String get Cairns {
    return Intl.message(
      'Cairns',
      name: 'Cairns',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get Duration {
    return Intl.message(
      'Duration',
      name: 'Duration',
      desc: '',
      args: [],
    );
  }

  /// `Selected Hour`
  String get Selected_Hour {
    return Intl.message(
      'Selected Hour',
      name: 'Selected_Hour',
      desc: '',
      args: [],
    );
  }

  /// `Some Information is Missing`
  String get Some_Information_is_Missing {
    return Intl.message(
      'Some Information is Missing',
      name: 'Some_Information_is_Missing',
      desc: '',
      args: [],
    );
  }

  /// `Select City`
  String get Select_City {
    return Intl.message(
      'Select City',
      name: 'Select_City',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Selected_City ' key

  /// `Hour`
  String get Hour {
    return Intl.message(
      'Hour',
      name: 'Hour',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get Hours {
    return Intl.message(
      'Hours',
      name: 'Hours',
      desc: '',
      args: [],
    );
  }

  /// `totalRides`
  String get total_Rides {
    return Intl.message(
      'totalRides',
      name: 'total_Rides',
      desc: '',
      args: [],
    );
  }

  /// `Billing Details`
  String get Billing_Details {
    return Intl.message(
      'Billing Details',
      name: 'Billing_Details',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get Next {
    return Intl.message(
      'Next',
      name: 'Next',
      desc: '',
      args: [],
    );
  }

  /// `Business Name`
  String get company_Name {
    return Intl.message(
      'Business Name',
      name: 'company_Name',
      desc: '',
      args: [],
    );
  }

  /// `CreditCard`
  String get Credit_Card {
    return Intl.message(
      'CreditCard',
      name: 'Credit_Card',
      desc: '',
      args: [],
    );
  }

  /// `Map is Loading`
  String get Map_is_Loading {
    return Intl.message(
      'Map is Loading',
      name: 'Map_is_Loading',
      desc: '',
      args: [],
    );
  }

  /// `Destination Address`
  String get Destination_Address {
    return Intl.message(
      'Destination Address',
      name: 'Destination_Address',
      desc: '',
      args: [],
    );
  }

  /// `Km`
  String get Km {
    return Intl.message(
      'Km',
      name: 'Km',
      desc: '',
      args: [],
    );
  }

  /// `Distance`
  String get Distance {
    return Intl.message(
      'Distance',
      name: 'Distance',
      desc: '',
      args: [],
    );
  }

  /// `notification`
  String get notification {
    return Intl.message(
      'notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Enter Card Number`
  String get Enter_Card_Number {
    return Intl.message(
      'Enter Card Number',
      name: 'Enter_Card_Number',
      desc: '',
      args: [],
    );
  }

  /// `Expiry Date`
  String get Expiry_Date {
    return Intl.message(
      'Expiry Date',
      name: 'Expiry_Date',
      desc: '',
      args: [],
    );
  }

  /// `CVC Code`
  String get CVC_Code {
    return Intl.message(
      'CVC Code',
      name: 'CVC_Code',
      desc: '',
      args: [],
    );
  }

  /// `Card Holder Name`
  String get Card_Holder_Name {
    return Intl.message(
      'Card Holder Name',
      name: 'Card_Holder_Name',
      desc: '',
      args: [],
    );
  }

  /// `Scan Card`
  String get Scan_Card {
    return Intl.message(
      'Scan Card',
      name: 'Scan_Card',
      desc: '',
      args: [],
    );
  }

  /// `Contact No`
  String get Contact_No {
    return Intl.message(
      'Contact No',
      name: 'Contact_No',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Vehicle_Number ' key

  /// `Arrival Time`
  String get Arrival_Time {
    return Intl.message(
      'Arrival Time',
      name: 'Arrival_Time',
      desc: '',
      args: [],
    );
  }

  /// `Admin Message`
  String get Admin_Message {
    return Intl.message(
      'Admin Message',
      name: 'Admin_Message',
      desc: '',
      args: [],
    );
  }

  /// `PreBooking`
  String get Pre_Booking {
    return Intl.message(
      'PreBooking',
      name: 'Pre_Booking',
      desc: '',
      args: [],
    );
  }

  /// `Special Offer`
  String get Special_Offer {
    return Intl.message(
      'Special Offer',
      name: 'Special_Offer',
      desc: '',
      args: [],
    );
  }

  /// `ADD PROMO CODE`
  String get ADD_PROMO_CODE {
    return Intl.message(
      'ADD PROMO CODE',
      name: 'ADD_PROMO_CODE',
      desc: '',
      args: [],
    );
  }

  /// `Total Rides`
  String get Total_Rides {
    return Intl.message(
      'Total Rides',
      name: 'Total_Rides',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get Code {
    return Intl.message(
      'Code',
      name: 'Code',
      desc: '',
      args: [],
    );
  }

  /// `Text Copied`
  String get Text_Copied {
    return Intl.message(
      'Text Copied',
      name: 'Text_Copied',
      desc: '',
      args: [],
    );
  }

  /// `Expires`
  String get Expires {
    return Intl.message(
      'Expires',
      name: 'Expires',
      desc: '',
      args: [],
    );
  }

  /// `expiryDate`
  String get expiry_Date {
    return Intl.message(
      'expiryDate',
      name: 'expiry_Date',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get Message {
    return Intl.message(
      'Message',
      name: 'Message',
      desc: '',
      args: [],
    );
  }

  /// `Phone number verification failed`
  String get Phone_number_verification_failed {
    return Intl.message(
      'Phone number verification failed',
      name: 'Phone_number_verification_failed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to Verify Phone Number`
  String get Failed_to_Verify_Phone_Number {
    return Intl.message(
      'Failed to Verify Phone Number',
      name: 'Failed_to_Verify_Phone_Number',
      desc: '',
      args: [],
    );
  }

  /// `A confirmation code has been sent on this phone number`
  String get A_confirmation_code_has_been_sent_on_this_phone_number {
    return Intl.message(
      'A confirmation code has been sent on this phone number',
      name: 'A_confirmation_code_has_been_sent_on_this_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation Code`
  String get Confirmation_Code {
    return Intl.message(
      'Confirmation Code',
      name: 'Confirmation_Code',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get Check {
    return Intl.message(
      'Check',
      name: 'Check',
      desc: '',
      args: [],
    );
  }

  /// `I didn't receive confirmation the code`
  String get I_did_not_receive_confirmation_the_code {
    return Intl.message(
      'I didn\'t receive confirmation the code',
      name: 'I_did_not_receive_confirmation_the_code',
      desc: '',
      args: [],
    );
  }

  /// `Payment Options`
  String get Payment_Options {
    return Intl.message(
      'Payment Options',
      name: 'Payment_Options',
      desc: '',
      args: [],
    );
  }

  /// `Pay Now`
  String get Pay_Now {
    return Intl.message(
      'Pay Now',
      name: 'Pay_Now',
      desc: '',
      args: [],
    );
  }

  /// `Pay Later`
  String get Pay_Later {
    return Intl.message(
      'Pay Later',
      name: 'Pay_Later',
      desc: '',
      args: [],
    );
  }

  /// `My payment methods`
  String get My_payment_methods {
    return Intl.message(
      'My payment methods',
      name: 'My_payment_methods',
      desc: '',
      args: [],
    );
  }

  /// `Apple Pay`
  String get Apple_Pay {
    return Intl.message(
      'Apple Pay',
      name: 'Apple_Pay',
      desc: '',
      args: [],
    );
  }

  /// `Google Pay`
  String get Google_Pay {
    return Intl.message(
      'Google Pay',
      name: 'Google_Pay',
      desc: '',
      args: [],
    );
  }

  /// `Pay with PAYPAL`
  String get Pay_with_PAYPAL {
    return Intl.message(
      'Pay with PAYPAL',
      name: 'Pay_with_PAYPAL',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Credit/Debit_Card' key

  /// `Pay ID`
  String get Pay_ID {
    return Intl.message(
      'Pay ID',
      name: 'Pay_ID',
      desc: '',
      args: [],
    );
  }

  /// `Pay on Pickup (Cash/Card)`
  String get Pay_on_Pickup {
    return Intl.message(
      'Pay on Pickup (Cash/Card)',
      name: 'Pay_on_Pickup',
      desc: '',
      args: [],
    );
  }

  /// `Booster Seat`
  String get Booster_Seat {
    return Intl.message(
      'Booster Seat',
      name: 'Booster_Seat',
      desc: '',
      args: [],
    );
  }

  /// `Discount Offers`
  String get Discount_Offers {
    return Intl.message(
      'Discount Offers',
      name: 'Discount_Offers',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get Posts {
    return Intl.message(
      'Posts',
      name: 'Posts',
      desc: '',
      args: [],
    );
  }

  /// `Get access to hundreds of Cabs`
  String get Get_access_to_hundreds_of_Cabs {
    return Intl.message(
      'Get access to hundreds of Cabs',
      name: 'Get_access_to_hundreds_of_Cabs',
      desc: '',
      args: [],
    );
  }

  /// `John Smith`
  String get John_Smith {
    return Intl.message(
      'John Smith',
      name: 'John_Smith',
      desc: '',
      args: [],
    );
  }

  /// `member`
  String get member {
    return Intl.message(
      'member',
      name: 'member',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get Sign_in {
    return Intl.message(
      'Sign in',
      name: 'Sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `I forgot my Password`
  String get I_forgot_my_Password {
    return Intl.message(
      'I forgot my Password',
      name: 'I_forgot_my_Password',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'Don\'t_have_an_account' key

  /// `SIGN UP`
  String get SIGN_UP {
    return Intl.message(
      'SIGN UP',
      name: 'SIGN_UP',
      desc: '',
      args: [],
    );
  }

  /// `here`
  String get here {
    return Intl.message(
      'here',
      name: 'here',
      desc: '',
      args: [],
    );
  }

  /// `Check your Internet Connection`
  String get Check_your_Internet_Connection {
    return Intl.message(
      'Check your Internet Connection',
      name: 'Check_your_Internet_Connection',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get Select_Language {
    return Intl.message(
      'Select Language',
      name: 'Select_Language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get English {
    return Intl.message(
      'English',
      name: 'English',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get Chinese {
    return Intl.message(
      'Chinese',
      name: 'Chinese',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get First_Name {
    return Intl.message(
      'First Name',
      name: 'First_Name',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get Last_Name {
    return Intl.message(
      'Last Name',
      name: 'Last_Name',
      desc: '',
      args: [],
    );
  }

  /// `Au`
  String get Au {
    return Intl.message(
      'Au',
      name: 'Au',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Number`
  String get Invalid_Number {
    return Intl.message(
      'Invalid Number',
      name: 'Invalid_Number',
      desc: '',
      args: [],
    );
  }

  /// `Password should be 8 character long`
  String get Password_should_be_8_character_long {
    return Intl.message(
      'Password should be 8 character long',
      name: 'Password_should_be_8_character_long',
      desc: '',
      args: [],
    );
  }

  /// `Passwords should be matched`
  String get Passwords_should_be_matched {
    return Intl.message(
      'Passwords should be matched',
      name: 'Passwords_should_be_matched',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get Confirm_Password {
    return Intl.message(
      'Confirm Password',
      name: 'Confirm_Password',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get Continue {
    return Intl.message(
      'Continue',
      name: 'Continue',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get OR {
    return Intl.message(
      'OR',
      name: 'OR',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get Google {
    return Intl.message(
      'Google',
      name: 'Google',
      desc: '',
      args: [],
    );
  }

  /// `Have an account`
  String get Have_an_account {
    return Intl.message(
      'Have an account',
      name: 'Have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `SIGN IN`
  String get SIGN_IN {
    return Intl.message(
      'SIGN IN',
      name: 'SIGN_IN',
      desc: '',
      args: [],
    );
  }

  /// `PRIVACY POLICY`
  String get PRIVACY_POLICY {
    return Intl.message(
      'PRIVACY POLICY',
      name: 'PRIVACY_POLICY',
      desc: '',
      args: [],
    );
  }

  /// `TERMS & CONDITIONS`
  String get TERMS_AND_CONDITIONS {
    return Intl.message(
      'TERMS & CONDITIONS',
      name: 'TERMS_AND_CONDITIONS',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get FAQ {
    return Intl.message(
      'FAQ',
      name: 'FAQ',
      desc: '',
      args: [],
    );
  }

  /// `ABOUT`
  String get ABOUT {
    return Intl.message(
      'ABOUT',
      name: 'ABOUT',
      desc: '',
      args: [],
    );
  }

  /// `RATE OUR APP`
  String get RATE_OUR_APP {
    return Intl.message(
      'RATE OUR APP',
      name: 'RATE_OUR_APP',
      desc: '',
      args: [],
    );
  }

  /// `SHARE OUR APP`
  String get SHARE_OUR_APP {
    return Intl.message(
      'SHARE OUR APP',
      name: 'SHARE_OUR_APP',
      desc: '',
      args: [],
    );
  }

  /// `CONTACT US`
  String get CONTACT_US {
    return Intl.message(
      'CONTACT US',
      name: 'CONTACT_US',
      desc: '',
      args: [],
    );
  }

  /// `DELETE ACCOUNT`
  String get DELETE_ACCOUNT {
    return Intl.message(
      'DELETE ACCOUNT',
      name: 'DELETE_ACCOUNT',
      desc: '',
      args: [],
    );
  }

  /// `LOGOUT`
  String get LOG_OUT {
    return Intl.message(
      'LOGOUT',
      name: 'LOG_OUT',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get Wallet {
    return Intl.message(
      'Wallet',
      name: 'Wallet',
      desc: '',
      args: [],
    );
  }

  /// `CASH`
  String get CASH {
    return Intl.message(
      'CASH',
      name: 'CASH',
      desc: '',
      args: [],
    );
  }

  /// `CARD`
  String get CARD {
    return Intl.message(
      'CARD',
      name: 'CARD',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get Search {
    return Intl.message(
      'Search',
      name: 'Search',
      desc: '',
      args: [],
    );
  }

  /// `Super Cab`
  String get Super_Cab {
    return Intl.message(
      'Super Cab',
      name: 'Super_Cab',
      desc: '',
      args: [],
    );
  }

  /// `vehicleNumber`
  String get vehicle_Number {
    return Intl.message(
      'vehicleNumber',
      name: 'vehicle_Number',
      desc: '',
      args: [],
    );
  }

  /// `driverName`
  String get driver_Name {
    return Intl.message(
      'driverName',
      name: 'driver_Name',
      desc: '',
      args: [],
    );
  }

  /// `discount`
  String get discount {
    return Intl.message(
      'discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `cardHolderName`
  String get card_Holder_Name {
    return Intl.message(
      'cardHolderName',
      name: 'card_Holder_Name',
      desc: '',
      args: [],
    );
  }

  /// `cardNumber`
  String get card_Number {
    return Intl.message(
      'cardNumber',
      name: 'card_Number',
      desc: '',
      args: [],
    );
  }

  /// `Promo Code Activation`
  String get Promo_Code_Activation {
    return Intl.message(
      'Promo Code Activation',
      name: 'Promo_Code_Activation',
      desc: '',
      args: [],
    );
  }

  /// `Already Activated the Offer`
  String get Already_Activated_the_Offer {
    return Intl.message(
      'Already Activated the Offer',
      name: 'Already_Activated_the_Offer',
      desc: '',
      args: [],
    );
  }

  /// `Offer is Not Available Now`
  String get Offer_is_Not_Available_Now {
    return Intl.message(
      'Offer is Not Available Now',
      name: 'Offer_is_Not_Available_Now',
      desc: '',
      args: [],
    );
  }

  /// `Activate`
  String get Activate {
    return Intl.message(
      'Activate',
      name: 'Activate',
      desc: '',
      args: [],
    );
  }

  /// `Reorder Now`
  String get Reorder_Now {
    return Intl.message(
      'Reorder Now',
      name: 'Reorder_Now',
      desc: '',
      args: [],
    );
  }

  /// `Merc E Class, Lexus ES 300, or similar, etc`
  String get Merc_E_Class_Lexus_ES_300_or_similar_etc {
    return Intl.message(
      'Merc E Class, Lexus ES 300, or similar, etc',
      name: 'Merc_E_Class_Lexus_ES_300_or_similar_etc',
      desc: '',
      args: [],
    );
  }

  /// `Merc S Class, BMW 7 Series, or similar, etc`
  String get Merc_S_Class_BMW_7_Series_or_similar_etc {
    return Intl.message(
      'Merc S Class, BMW 7 Series, or similar, etc',
      name: 'Merc_S_Class_BMW_7_Series_or_similar_etc',
      desc: '',
      args: [],
    );
  }

  /// `Audi Q7, Merc GL or similar, etc`
  String get Audi_Q7_Merc_GL_or_similar_etc {
    return Intl.message(
      'Audi Q7, Merc GL or similar, etc',
      name: 'Audi_Q7_Merc_GL_or_similar_etc',
      desc: '',
      args: [],
    );
  }

  /// `Merc Viano, LDV or similar, etc`
  String get Merc_Viano_LDV_or_similar_etc {
    return Intl.message(
      'Merc Viano, LDV or similar, etc',
      name: 'Merc_Viano_LDV_or_similar_etc',
      desc: '',
      args: [],
    );
  }

  /// `Card Detail`
  String get card_detail {
    return Intl.message(
      'Card Detail',
      name: 'card_detail',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Address Line 1`
  String get address_line_one {
    return Intl.message(
      'Address Line 1',
      name: 'address_line_one',
      desc: '',
      args: [],
    );
  }

  /// `Address Line 2`
  String get address_line_two {
    return Intl.message(
      'Address Line 2',
      name: 'address_line_two',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Postal code`
  String get postal_code {
    return Intl.message(
      'Postal code',
      name: 'postal_code',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}