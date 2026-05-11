// To parse this JSON data, do
//
//     final confirmTopUpResponseModel = confirmTopUpResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/models/transaction_history/transaction_history_model.dart';

ConfirmTopUpResponseModel confirmTopUpResponseModelFromJson(String str) => ConfirmTopUpResponseModel.fromJson(json.decode(str));


class ConfirmTopUpResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  ConfirmTopUpResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory ConfirmTopUpResponseModel.fromJson(Map<String, dynamic> json) => ConfirmTopUpResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  CardModel? card;
  String? amount;
  String? method;
  String? createdAt;
  String? totalAmount;
  String? createdAtFromApi;
  TransactionHistoryModel? transaction;

  Data({
    this.card,
    this.amount,
    this.totalAmount,
    this.transaction,
    this.method,
    this.createdAt,
    this.createdAtFromApi
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    card: json["card"] == null ? null : CardModel.fromJson(json["card"]),
    amount: json["amount"]?.toString(),
    method: json["method"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    createdAtFromApi: json["createdAt"]?.toString(),
    totalAmount: json["total_amount"]?.toString(),
    transaction: json["transaction"] == null ? null : TransactionHistoryModel.fromJson(json["transaction"]),
  );
}
