// To parse this JSON data, do
//
//     final cryptoAddressResponseModel = cryptoAddressResponseModelFromJson(jsonString);

import 'dart:convert';

CryptoAddressResponseModel cryptoAddressResponseModelFromJson(String str) => CryptoAddressResponseModel.fromJson(json.decode(str));

String cryptoAddressResponseModelToJson(CryptoAddressResponseModel data) => json.encode(data.toJson());

class CryptoAddressResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  CryptoAddress? data;

  CryptoAddressResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory CryptoAddressResponseModel.fromJson(Map<String, dynamic> json) => CryptoAddressResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
    data: json["data"] == null ? null : CryptoAddress.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "remark": remark,
    "status": status,
    "message": message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
    "data": data?.toJson(),
  };
}

class CryptoAddress {
  String? amount;
  String? sendto;
  String? img;
  String? currency;

  CryptoAddress({
    this.amount,
    this.sendto,
    this.img,
    this.currency,
  });

  factory CryptoAddress.fromJson(Map<String, dynamic> json) => CryptoAddress(
    amount: json["amount"]?.toString(),
    sendto: json["sendto"]?.toString(),
    img: json["img"]?.toString(),
    currency: json["currency"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "sendto": sendto,
    "img": img,
    "currency": currency,
  };
}
