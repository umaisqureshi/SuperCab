import 'package:flutter/material.dart';


class NotificationModel
{
  String title;
  String body;
  String userId;
  String id;
  String type;
  String bookingStatus;
  String driverName;
  String vehicleNumber;
  String contactNumber;
  String arrivalTime;
  String comment;

  NotificationModel({
    @required this.title,
    @required this.body,
    @required this.userId,
    @required this.id,
    @required this.type,
    @required this.bookingStatus,
    @required this.driverName,
    @required this.vehicleNumber,
    @required this.contactNumber,
    @required this.arrivalTime,
    @required this.comment
  });

  Map toJson() =>
      {
        'title' : title,
        'body' : body,
        'userId' : userId,
        'id' : id,
        'type' : type,
        'bookingStatus' : bookingStatus,
        'driverName' : driverName,
        'vehicleNumber' : vehicleNumber,
        'driverContact' : contactNumber,
        'arrivalTime' : arrivalTime,
        'comment' : comment
      };

  NotificationModel.fromJson(Map<String,dynamic> json)
      : title = json['title'],
        body = json['body'],
        userId = json['userId'],
        id = json['id'],
        type = json['type'],
        bookingStatus = json['bookingStatus'],
        driverName = json['driverName'],
        vehicleNumber = json['vehicleNumber'],
        contactNumber = json['driverContact'],
        arrivalTime = json['arrivalTime'],
        comment = json['comment'];

}


