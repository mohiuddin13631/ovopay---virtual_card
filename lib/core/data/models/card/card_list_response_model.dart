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
  List<Link>? links;
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
    this.links,
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
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
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
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
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
  String? nameOnCard;
  String? cardProviderCardId;
  String? email;
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

  CardModel({
    this.id,
    this.userId,
    this.userIdOfCard,
    this.cardName,
    this.nameOnCard,
    this.cardProviderCardId,
    this.email,
    this.cardCreatedDate,
    this.cardType,
    this.cardBrand,
    this.cardUserId,
    this.reference,
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
  });

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    id: json["id"],
    userId: json["user_id"]?.toString(),
    userIdOfCard: json["user_id_of_card"]?.toString(),
    cardName: json["card_name"]?.toString(),
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

class Transaction {
  int? id;
  String? userId;
  String? agentId;
  String? merchantId;
  String? cardId;
  dynamic cardTransactionId;
  int? amount;
  double? charge;
  double? postBalance;
  TrxType? trxType;
  String? trx;
  Details? details;
  Remark? remark;
  String? virtualCardId;
  String? forVirtualCardId;
  String? cardTransactionType;
  String? currency;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? totalAmount;

  Transaction({
    this.id,
    this.userId,
    this.agentId,
    this.merchantId,
    this.cardId,
    this.cardTransactionId,
    this.amount,
    this.charge,
    this.postBalance,
    this.trxType,
    this.trx,
    this.details,
    this.remark,
    this.virtualCardId,
    this.forVirtualCardId,
    this.cardTransactionType,
    this.currency,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.totalAmount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    userId: json["user_id"],
    agentId: json["agent_id"],
    merchantId: json["merchant_id"],
    cardId: json["card_id"],
    cardTransactionId: json["card_transaction_id"],
    amount: json["amount"],
    charge: json["charge"]?.toDouble(),
    postBalance: json["post_balance"]?.toDouble(),
    trxType: trxTypeValues.map[json["trx_type"]]!,
    trx: json["trx"],
    details: detailsValues.map[json["details"]]!,
    remark: remarkValues.map[json["remark"]]!,
    virtualCardId: json["virtual_card_id"],
    forVirtualCardId: json["for_virtual_card_id"],
    cardTransactionType: json["card_transaction_type"]?.toString(),
    currency: json["currency"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    totalAmount: json["total_amount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "agent_id": agentId,
    "merchant_id": merchantId,
    "card_id": cardId,
    "card_transaction_id": cardTransactionId,
    "amount": amount,
    "charge": charge,
    "post_balance": postBalance,
    "trx_type": trxTypeValues.reverse[trxType],
    "trx": trx,
    "details": detailsValues.reverse[details],
    "remark": remarkValues.reverse[remark],
    "virtual_card_id": virtualCardId,
    "for_virtual_card_id": forVirtualCardId,
    "card_transaction_type": cardTransactionTypeValues.reverse[cardTransactionType],
    "currency": currency,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "total_amount": totalAmount,
  };
}

enum CardTransactionType {
  MAIN_ACCOUNT_BALANCE
}

final cardTransactionTypeValues = EnumValues({
  "Main Account Balance": CardTransactionType.MAIN_ACCOUNT_BALANCE
});

enum Details {
  INITIAL_DEPOSIT_AMOUNT,
  TOP_UP_TO_CARD
}

final detailsValues = EnumValues({
  "Initial deposit amount": Details.INITIAL_DEPOSIT_AMOUNT,
  "Top-up to card ": Details.TOP_UP_TO_CARD
});

enum Remark {
  ADD_MONEY_TO_CARD,
  INITIAL_DEPOSIT
}

final remarkValues = EnumValues({
  "add_money_to_card": Remark.ADD_MONEY_TO_CARD,
  "initial_deposit": Remark.INITIAL_DEPOSIT
});

enum TrxType {
  EMPTY,
  TRX_TYPE
}

final trxTypeValues = EnumValues({
  "+": TrxType.EMPTY,
  "-": TrxType.TRX_TYPE
});

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
