// To parse this JSON data, do
//
//     final topUpWalletResponseModel = topUpWalletResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopay/core/data/models/card/card_list_response_model.dart';

import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/models/user/user_model.dart';

TopUpWalletResponseModel topUpWalletResponseModelFromJson(String str) => TopUpWalletResponseModel.fromJson(json.decode(str));

class TopUpWalletResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  TopUpWalletResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory TopUpWalletResponseModel.fromJson(Map<String, dynamic> json) => TopUpWalletResponseModel(
    remark: json["remark"],
    status: json["status"],
    message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  CardModel? card;
  ChargeSetting? chargeSetting;
  UserModel? user;

  Data({
    this.card,
    this.chargeSetting,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    card: json["card"] == null ? null : CardModel.fromJson(json["card"]),
    chargeSetting: json["charge_setting"] == null ? null : ChargeSetting.fromJson(json["charge_setting"]),
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
  );

}

class ChargeSetting {
  int? id;
  String? name;
  String? slug;
  String? fixedCharge;
  String? percentCharge;
  String? minLimit;
  String? maxLimit;
  String? agentCommissionFixed;
  String? agentCommissionPercent;
  String? merchantFixedCharge;
  String? merchantPercentCharge;
  String? monthlyLimit;
  String? dailyLimit;
  String? dailyRequestAcceptLimit;
  String? monthlyRequestAcceptLimit;
  String? cap;
  String? maximumCardGenerate;
  String? creationFee;
  String? monthlyFee;
  String? topupChargeFromWallet;
  String? topupChargeFromCrypto;
  String? shippingCost;
  String? topupChargeType;
  String? cardWithdrawCharge;
  String? cardWithdrawChargeType;
  String? perOperationCharge;
  String? cardTopupMinLimit;
  String? cardTopupMaxLimit;
  String? withdrawFromCardMinLimit;
  String? withdrawFromCardMaxLimit;
  String? declineCharge;
  String? crossBorderTransactionCharge;
  String? walletRequiredBalance;
  String? createdAt;
  String? updatedAt;

  ChargeSetting({
    this.id,
    this.name,
    this.slug,
    this.fixedCharge,
    this.percentCharge,
    this.minLimit,
    this.maxLimit,
    this.agentCommissionFixed,
    this.agentCommissionPercent,
    this.merchantFixedCharge,
    this.merchantPercentCharge,
    this.monthlyLimit,
    this.dailyLimit,
    this.dailyRequestAcceptLimit,
    this.monthlyRequestAcceptLimit,
    this.cap,
    this.maximumCardGenerate,
    this.creationFee,
    this.monthlyFee,
    this.topupChargeFromWallet,
    this.topupChargeFromCrypto,
    this.shippingCost,
    this.topupChargeType,
    this.cardWithdrawCharge,
    this.cardWithdrawChargeType,
    this.perOperationCharge,
    this.cardTopupMinLimit,
    this.cardTopupMaxLimit,
    this.withdrawFromCardMinLimit,
    this.withdrawFromCardMaxLimit,
    this.declineCharge,
    this.crossBorderTransactionCharge,
    this.walletRequiredBalance,
    this.createdAt,
    this.updatedAt,
  });

  factory ChargeSetting.fromJson(Map<String, dynamic> json) => ChargeSetting(
    id: json["id"],
    name: json["name"]?.toString(),
    slug: json["slug"]?.toString(),
    fixedCharge: json["fixed_charge"]?.toString(),
    percentCharge: json["percent_charge"]?.toString(),
    minLimit: json["min_limit"]?.toString(),
    maxLimit: json["max_limit"]?.toString(),
    agentCommissionFixed: json["agent_commission_fixed"]?.toString(),
    agentCommissionPercent: json["agent_commission_percent"]?.toString(),
    merchantFixedCharge: json["merchant_fixed_charge"]?.toString(),
    merchantPercentCharge: json["merchant_percent_charge"]?.toString(),
    monthlyLimit: json["monthly_limit"]?.toString(),
    dailyLimit: json["daily_limit"]?.toString(),
    dailyRequestAcceptLimit: json["daily_request_accept_limit"]?.toString(),
    monthlyRequestAcceptLimit: json["monthly_request_accept_limit"]?.toString(),
    cap: json["cap"]?.toString(),
    maximumCardGenerate: json["maximum_card_generate"]?.toString(),
    creationFee: json["creation_fee"]?.toString(),
    monthlyFee: json["monthly_fee"]?.toString(),
    topupChargeFromWallet: json["topup_charge_from_wallet"]?.toString(),
    topupChargeFromCrypto: json["topup_charge_from_crypto"]?.toString(),
    shippingCost: json["shipping_cost"]?.toString(),
    topupChargeType: json["topup_charge_type"]?.toString(),
    cardWithdrawCharge: json["card_withdraw_charge"]?.toString(),
    cardWithdrawChargeType: json["card_withdraw_charge_type"]?.toString(),
    perOperationCharge: json["per_operation_charge"]?.toString(),
    cardTopupMinLimit: json["card_topup_min_limit"]?.toString(),
    cardTopupMaxLimit: json["card_topup_max_limit"]?.toString(),
    withdrawFromCardMinLimit: json["withdraw_from_card_min_limit"]?.toString(),
    withdrawFromCardMaxLimit: json["withdraw_from_card_max_limit"]?.toString(),
    declineCharge: json["decline_charge"]?.toString(),
    crossBorderTransactionCharge: json["cross_border_transaction_charge"]?.toString(),
    walletRequiredBalance: json["wallet_required_balance"]?.toString(),
    createdAt: json["created_at"]?.toString(),
    updatedAt: json["updated_at"]?.toString(),
  );
}
