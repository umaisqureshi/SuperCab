import 'dart:convert';

StripeErrorModel stripeErrorModelFromJson(String str) => StripeErrorModel.fromJson(json.decode(str));

String stripeErrorModelToJson(StripeErrorModel data) => json.encode(data.toJson());

class StripeErrorModel {
  StripeErrorModel({
    this.error,
  });

  Error error;

  factory StripeErrorModel.fromJson(Map<String, dynamic> json) => StripeErrorModel(
    error: Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error.toJson(),
  };
}

class Error {
  Error({
    this.code,
    this.declineCode,
    this.docUrl,
    this.message,
    this.param,
    this.type,
  });

  String code;
  String declineCode;
  String docUrl;
  String message;
  String param;
  String type;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    code: json["code"],
    declineCode: json["decline_code"],
    docUrl: json["doc_url"],
    message: json["message"],
    param: json["param"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "decline_code": declineCode,
    "doc_url": docUrl,
    "message": message,
    "param": param,
    "type": type,
  };
}
