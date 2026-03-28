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
  List<ExistingCardHolder>? existingCardHolders;

  Data({
    this.card,
    this.chargeSetting,
    this.user,
    this.existingCardHolders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    card: json["card"] == null ? null : CardModel.fromJson(json["card"]),
    chargeSetting: json["charge_setting"] == null ? null : ChargeSetting.fromJson(json["charge_setting"]),
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    existingCardHolders: json["existing_card_holders"] == null ? [] : List<ExistingCardHolder>.from(json["existing_card_holders"]!.map((x) => ExistingCardHolder.fromJson(x))),
  );

}

class ExistingCardHolder {
  int? id;
  String? userId;
  String? customerEmail;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? city;
  String? state;
  String? country;
  String? line1;
  String? zipCode;
  String? houseNumber;
  String? idNumber;
  String? idType;
  String? idImage;
  String? userPhoto;
  String? customerId;
  String? dateOfBirth;
  DateTime? createdAt;
  DateTime? updatedAt;

  ExistingCardHolder({
    this.id,
    this.userId,
    this.customerEmail,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.city,
    this.state,
    this.country,
    this.line1,
    this.zipCode,
    this.houseNumber,
    this.idNumber,
    this.idType,
    this.idImage,
    this.userPhoto,
    this.customerId,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory ExistingCardHolder.fromJson(Map<String, dynamic> json) => ExistingCardHolder(
    id: json["id"],
    userId: json["user_id"]?.toString(),
    customerEmail: json["customer_email"]?.toString(),
    firstName: json["first_name"]?.toString(),
    lastName: json["last_name"]?.toString(),
    phoneNumber: json["phone_number"]?.toString(),
    city: json["city"]?.toString(),
    state: json["state"]?.toString(),
    country: json["country"]?.toString(),
    line1: json["line_1"]?.toString(),
    zipCode: json["zip_code"]?.toString(),
    houseNumber: json["house_number"]?.toString(),
    idNumber: json["id_number"]?.toString(),
    idType: json["id_type"]?.toString(),
    idImage: json["id_image"]?.toString(),
    userPhoto: json["user_photo"]?.toString(),
    customerId: json["customer_id"]?.toString(),
    dateOfBirth: json["date_of_birth"]?.toString(),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
