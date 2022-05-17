
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PromoCodeDataModel
{
  String promoCode;
  int expiryDate;
  int discount;
  int totalRides;
  String comment;

  PromoCodeDataModel({this.promoCode,this.discount,this.expiryDate,this.totalRides,this.comment});

  PromoCodeDataModel.firstPromotion(code)
      : promoCode = code,
        expiryDate = null,
        discount = 10,
        totalRides = 1,
        comment = "First Ride Offer";

  Map<String, dynamic> toMap() =>
      {
        'promoCode' : promoCode,
        'expiryDate' : expiryDate,
        'discount' : discount,
        'totalRides' : totalRides,
        'comment' : comment
      };

  PromoCodeDataModel.fromJson(Map<String,dynamic> json)
      : promoCode = json['promoCode'],
        expiryDate = json['expiryDate'],
        discount = json['discount'],
        totalRides = json['totalRides'],
        comment = json['comment'];

  Future<bool> isExist(code) async {
    final prefs = await SharedPreferences.getInstance();
    var isExist = prefs.containsKey('promoCode');
    return (isExist)
        ? (getPromoCode(prefs.get('promoCode')).promoCode == code):false;
  }


  Future<bool> isExpire(code, expireDate) async {
   bool  isOfferExpire =
        DateTime.now().millisecondsSinceEpoch >=
            (expireDate);
   bool isExists =  await isExist(code);
   return !isExists && !isOfferExpire;
  }

  Future<bool> savePromoCode(PromoCodeDataModel data) async {
    String jsonObject = json.encode(data.toMap());
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('promoCode', jsonObject);
  }

  PromoCodeDataModel  getPromoCode(String str)=> PromoCodeDataModel.fromJson(json.decode(str));

}
PromoCodeDataModel  getPromoCodeFromMap(Map<String, dynamic> str)=> PromoCodeDataModel.fromJson(str);

