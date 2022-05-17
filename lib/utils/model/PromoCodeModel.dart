class PromoCodeModel
{
  String title;
  String body;
  String promoCode;

  PromoCodeModel({this.title,this.body,this.promoCode});

  Map toJson() =>
      {
        'title' : title,
        'body' : body,
        'promoCode' : promoCode
      };

  PromoCodeModel.fromJson(Map<String,dynamic> json)
      : title = json['title'],
        body = json['body'],
        promoCode = json['promoCode'];

}