import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/repositories/top_up/top_up_repo.dart';
import 'package:ovopay/core/helper/string_format_helper.dart';

import '../../../../core/data/models/card/topup_wallet_response_model.dart';
import '../../../../core/data/models/global/response_model/response_model.dart';
import '../../../../core/data/models/modules/gift_card/gift_submit_response_model.dart';
import '../../../../core/data/services/shared_pref_service.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/util.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class TopUpController extends GetxController {

  TopUpRepo topUpRepo;

  TopUpController({required this.topUpRepo});

  TextEditingController pinController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  String mainBalanceType = "main_balance";
  String cryptoDepositType = "crypto_deposit";

  bool isSubmitLoading = false;

  String currency = "";
  String textCurrency = "";

  bool isLoading = false;

  ChargeSetting? chargeSetting;
  CardModel? cardModel;

  double minimumAmount = 0.00;
  double maximumAmount = 0.00;

  Future<void> getTopUpWallet(String id) async {


    currency = SharedPreferenceService.getCurrencySymbol();
    textCurrency = SharedPreferenceService.getCurrencySymbol(isFullText: true);

    isLoading = true;
    update();

    try {
      ResponseModel responseModel = await topUpRepo.getTopUpWallet(id);
      if (responseModel.statusCode == 200) {
        final model = topUpWalletResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (model.status == "success") {
          cardModel = model.data?.card;
          chargeSetting = model.data?.chargeSetting;
          minimumAmount = AppConverter.formatNumberDouble(chargeSetting?.cardTopupMinLimit ?? "");
          maximumAmount = AppConverter.formatNumberDouble(chargeSetting?.cardTopupMaxLimit ?? "");
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
        isLoading = false;
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
    isLoading = false;
    update();
  }

  Future<void> pinVerificationProcess({
    void Function(GiftSubmitResponseModel)? onSuccessCallback,
  }) async {
    try {
      isSubmitLoading = true;
      update();
      ResponseModel responseModel = await topUpRepo.pinVerificationRequest(pin: pinController.text);
      if (responseModel.statusCode == 200) {
        GiftSubmitResponseModel giftSubmitResponseModel = GiftSubmitResponseModel.fromJson(responseModel.responseJson);

        if (giftSubmitResponseModel.status != "success") { //todo
          if (onSuccessCallback != null) {
            onSuccessCallback(giftSubmitResponseModel);
          }
        } else {
          CustomSnackBar.error(
            errorList: giftSubmitResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isSubmitLoading = false;
      update();
    }
  }

  List<String> suggestedAmountList = ["500", "1000", "1500", "2000", "3000", "5000"];

  String getProcessingFee(String feeAmount){
    double amount = AppConverter.formatNumberDouble(amountController.text);
    double fee = AppConverter.formatNumberDouble(feeAmount);

    double finalFee = amount * fee / 100;

    return AppConverter.formatNumber(finalFee.toString());
  }

  String getDeductedAmount(){

    double amount = AppConverter.formatNumberDouble(amountController.text);
    double fee = AppConverter.formatNumberDouble(getProcessingFee(chargeSetting?.topupChargeFromWallet ?? ""));
    double processingFee = AppConverter.formatNumberDouble(chargeSetting?.perOperationCharge??"");

    double totalCost = amount + fee + processingFee;

    return AppConverter.formatNumber(totalCost.toString());
  }

  String getNewBalance(){
    double amount = AppConverter.formatNumberDouble(amountController.text);
    double balance = AppConverter.formatNumberDouble(cardModel?.balance ?? "");

    return AppConverter.formatNumber((balance + amount).toString());
  }
}

class TopUpInfo {
  final String topUpMethod;
  TopUpInfo({required this.topUpMethod});
}