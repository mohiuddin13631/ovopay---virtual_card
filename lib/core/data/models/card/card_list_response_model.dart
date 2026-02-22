// To parse this JSON data, do
//
//     final cardListResponseModel = cardListResponseModelFromJson(jsonString);

import 'dart:convert';

CardListResponseModel cardListResponseModelFromJson(String str) => CardListResponseModel.fromJson(json.decode(str));

String cardListResponseModelToJson(CardListResponseModel data) => json.encode(data.toJson());

class CardListResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CardListResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory CardListResponseModel.fromJson(Map<String, dynamic> json) => CardListResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "remark": remark,
    "status": status,
    "message": message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
    "data": data?.toJson(),
  };
}

class Data {
  Cards? cards;

  Data({
    this.cards,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cards: json["cards"] == null ? null : Cards.fromJson(json["cards"]),
  );

  Map<String, dynamic> toJson() => {
    "cards": cards?.toJson(),
  };
}

class Cards {
  String? currentPage;
  List<CardModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Cards({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Cards.fromJson(Map<String, dynamic> json) => Cards(
    currentPage: json["current_page"]?.toString(),
    data: json["data"] == null ? [] : List<CardModel>.from(json["data"]!.map((x) => CardModel.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class CardModel {
  int? id;
  String? userId;
  String? userIdOfCard;
  String? cardName;
  String? cardNumber;
  String? nameOnCard;
  String? cardProviderCardId;
  String? email;
  String? cvv;
  String? cardCreatedDate;
  String? cardType;
  String? cardBrand;
  String? cardUserId;
  String? reference;
  String? cardStatus;
  String? lastFour;
  String? expiry;
  String? customerId;
  String? balance;
  BillingAddress? billingAddress;
  String? freezingReason;
  String? detailsNotificationSent;
  String? createdAt;
  String? updatedAt;

  bool isShowCardView;

  CardModel({
    this.id,
    this.userId,
    this.userIdOfCard,
    this.cardName,
    this.cardNumber,
    this.nameOnCard,
    this.cardProviderCardId,
    this.email,
    this.cardCreatedDate,
    this.cardType,
    this.cardBrand,
    this.cardUserId,
    this.reference,
    this.cvv,
    this.cardStatus,
    this.lastFour,
    this.expiry,
    this.customerId,
    this.balance,
    this.billingAddress,
    this.freezingReason,
    this.detailsNotificationSent,
    this.createdAt,
    this.updatedAt,
    this.isShowCardView = false
  });

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    id: json["id"],
    userId: json["user_id"]?.toString(),
    userIdOfCard: json["user_id_of_card"]?.toString(),
    cardName: json["card_name"]?.toString(),
    cvv: json["cvv"]?.toString(),
    cardNumber: json["card_number"]?.toString(),
    nameOnCard: json["name_on_card"]?.toString(),
    cardProviderCardId: json["card_provider_card_id"]?.toString(),
    email: json["email"]?.toString(),
    cardCreatedDate: json["card_created_date"]?.toString(),
    cardType: json["card_type"]?.toString(),
    cardBrand: json["card_brand"]?.toString(),
    cardUserId: json["card_user_id"]?.toString(),
    reference: json["reference"]?.toString(),
    cardStatus: json["card_status"]?.toString(),
    lastFour: json["last_four"]?.toString(),
    expiry: json["expiry"]?.toString(),
    customerId: json["customer_id"]?.toString(),
    balance: json["balance"]?.toString(),
    billingAddress: json["billing_address"] == null ? null : BillingAddress.fromJson(json["billing_address"]),
    freezingReason: json["freezing_reason"]?.toString(),
    detailsNotificationSent: json["details_notification_sent"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );
}

class BillingAddress {
  String? billingCountry;
  String? billingCity;
  String? billingStreet;
  String? billingZipCode;

  BillingAddress({
    this.billingCountry,
    this.billingCity,
    this.billingStreet,
    this.billingZipCode,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
    billingCountry: json["billing_country"]?.toString(),
    billingCity: json["billing_city"]?.toString(),
    billingStreet: json["billing_street"]?.toString(),
    billingZipCode: json["billing_zip_code"]?.toString(),
  );
}
