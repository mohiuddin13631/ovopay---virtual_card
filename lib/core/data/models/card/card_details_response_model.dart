// To parse this JSON data, do
//
//     final cardDetailsResponseModel = cardDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopay/core/data/models/card/card_list_response_model.dart';

import '../transaction_history/transaction_history_model.dart';

CardDetailsResponseModel cardDetailsResponseModelFromJson(String str) => CardDetailsResponseModel.fromJson(json.decode(str));

class CardDetailsResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  CardDetailsResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory CardDetailsResponseModel.fromJson(Map<String, dynamic> json) => CardDetailsResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  CardModel? card;
  Transactions? transactions;

  Data({
    this.card,
    this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    card: json["card"] == null ? null : CardModel.fromJson(json["card"]),
    transactions: json["transactions"] == null ? null : Transactions.fromJson(json["transactions"]),
  );
}
