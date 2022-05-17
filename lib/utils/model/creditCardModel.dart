import 'package:flutter/material.dart';

class CreditCardModel {

  String cardHolderName;
  String cardNumber;
  String cvcNumber;
  String expiryDate;

  CreditCardModel({
    @required this.cardHolderName,
    @required this.cardNumber,
    @required this.cvcNumber,
    @required this.expiryDate
  });

  Map toJson() =>
  {
    'cardHolderName' : cardHolderName,
    'cardNumber' : cardNumber,
    'cvcNumber' : cvcNumber,
    'expiryDate' : expiryDate
  };

  CreditCardModel.fromJson(Map<String,dynamic> json)
      : cardHolderName = json['cardHolderName'],
        cardNumber = json['cardNumber'],
        cvcNumber = json['cvcNumber'],
        expiryDate = json['expiryDate'];

}
