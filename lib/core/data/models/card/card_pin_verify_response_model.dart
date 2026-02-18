// To parse this JSON data, do
//
//     final cardPinVerifyResponseModel = cardPinVerifyResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopay/core/data/models/card/card_list_response_model.dart';

CardPinVerifyResponseModel cardPinVerifyResponseModelFromJson(String str) => CardPinVerifyResponseModel.fromJson(json.decode(str));

class CardPinVerifyResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CardPinVerifyResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory CardPinVerifyResponseModel.fromJson(Map<String, dynamic> json) => CardPinVerifyResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  CardModel? card;

  Data({
    this.card,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    card: json["card"] == null ? null : CardModel.fromJson(json["card"]),
  );
}
