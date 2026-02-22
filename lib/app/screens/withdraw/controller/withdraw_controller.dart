import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/models/card/confirm_topup_response_model.dart';
import 'package:ovopay/core/data/models/card/crypto_address_response_model.dart';
import 'package:ovopay/core/data/models/card/crypto_address_response_model.dart';
import 'package:ovopay/core/data/repositories/top_up/top_up_repo.dart';
import 'package:ovopay/core/data/repositories/withdraw/withdraw_repo.dart';
import 'package:ovopay/core/helper/string_format_helper.dart';

import '../../../../core/data/models/card/topup_wallet_response_model.dart';
import '../../../../core/data/models/global/response_model/response_model.dart';
import '../../../../core/data/services/shared_pref_service.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/util.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class WithdrawController extends GetxController {

  WithdrawRepo withdrawRepo;

  WithdrawController({required this.withdrawRepo});

  TextEditingController pinController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  bool isSubmitLoading = false;

  String currency = "";
  String textCurrency = "";

  bool isLoading = false;

  ChargeSetting? chargeSetting;
  CardModel? cardModel;

  double minimumAmount = 0.00;
  double maximumAmount = 0.00;

  Future<void> loadData(String id) async {

    isLoading = true;
    update();

    await getWithdrawInfo(id);

    isLoading = false;
    update();
  }

  Future<void> getWithdrawInfo(String id) async {

    currency = SharedPreferenceService.getCurrencySymbol();
    textCurrency = SharedPreferenceService.getCurrencySymbol(isFullText: true);

    try {
      ResponseModel responseModel = await withdrawRepo.getWithdrawInfo(id);
      if (responseModel.statusCode == 200) {
        final model = topUpWalletResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (model.status == "success") {
          cardModel = model.data?.card;
          chargeSetting = model.data?.chargeSetting;
          minimumAmount = AppConverter.formatNumberDouble(chargeSetting?.withdrawFromCardMinLimit ?? "");
          maximumAmount = AppConverter.formatNumberDouble(chargeSetting?.withdrawFromCardMaxLimit ?? "");
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
  }

  Future<void> onConfirmWithdraw({
    void Function(ConfirmTopUpResponseModel)? onSuccessCallback,
  }) async {
    try {
      isSubmitLoading = true;
      update();
      ResponseModel responseModel = await withdrawRepo.confirmWithdraw(pin: pinController.text, amount: amountController.text, id: cardModel?.id.toString() ?? "");
      if (responseModel.statusCode == 200) {
        ConfirmTopUpResponseModel model = ConfirmTopUpResponseModel.fromJson(responseModel.responseJson);

        if (model.status == "success") {
          if (onSuccessCallback != null) {
            onSuccessCallback(model);
          }
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
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

  String getNetAmount(){

    double amount = AppConverter.formatNumberDouble(amountController.text);
    double fee = AppConverter.formatNumberDouble(getProcessingFee(chargeSetting?.cardWithdrawCharge ?? ""));
    double processingFee = AppConverter.formatNumberDouble(chargeSetting?.perOperationCharge??"");

    double totalCost = amount - (fee + processingFee);

    return AppConverter.formatNumber(totalCost.toString());
  }

  String getNewBalance(){
    double amount = AppConverter.formatNumberDouble(amountController.text);
    double balance = AppConverter.formatNumberDouble(cardModel?.balance ?? "");

    return AppConverter.formatNumber((balance - amount).toString());
  }
}

class TopUpInfo {
  final String topUpMethod;
  TopUpInfo({required this.topUpMethod});
}