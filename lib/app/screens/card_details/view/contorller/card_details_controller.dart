import 'dart:convert';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/models/card/topup_wallet_response_model.dart';
import 'package:ovopay/core/data/models/transaction_history/transaction_history_model.dart';

import '../../../../../core/data/models/card/card_details_response_model.dart';
import '../../../../../core/data/models/global/response_model/response_model.dart';
import '../../../../../core/data/repositories/card/card_repo.dart';
import '../../../../../core/data/services/shared_pref_service.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/util.dart';
import '../../../../components/snack_bar/show_custom_snackbar.dart';

class CardDetailsController extends GetxController {

  CardRepo cardRepo;
  CardDetailsController({required this.cardRepo});

  bool isLoading = false;

  CardModel cardModel = CardModel(id: -1);

  List<TransactionHistoryModel> transactionHistoryList = [];

  String currency = "";
  String textCurrency = "";

  ChargeSetting? chargeSetting;

  Future<void> getCardDetails(String id) async {

    currency = SharedPreferenceService.getCurrencySymbol();
    textCurrency = SharedPreferenceService.getCurrencySymbol(isFullText: true);

    isLoading = true;
    update();

    try {
      ResponseModel responseModel = await cardRepo.getCardDetails(id);
      if (responseModel.statusCode == 200) {
        final cardDetails = cardDetailsResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (cardDetails.status == "success") {
          cardModel = cardDetails.data?.card ?? CardModel(id: -1);
          transactionHistoryList.addAll(cardDetails.data?.transactions?.historyData ?? []);
          chargeSetting = cardDetails.data?.chargeSetting;
        } else {
          CustomSnackBar.error(
            errorList: cardDetails.message ?? [MyStrings.somethingWentWrong],
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


  bool isSubmitLoading = false;
  Future<void> freezeUnfreezeCard() async {

    isSubmitLoading = true;
    update();

    try {
      ResponseModel responseModel = await cardRepo.freezeUnfreezeCard(cardId: cardModel.id.toString(), isFreeze: cardModel.freezingReason == null);
      if (responseModel.statusCode == 200) {
        final cardDetails = cardDetailsResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (cardDetails.status == "success") {

        } else {
          CustomSnackBar.error(
            errorList: cardDetails.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
        isSubmitLoading = false;
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
    isSubmitLoading = false;
    update();
  }

  List<String> freezingReasonList = [
    "Select a reason...",
    "Suspicious activity",
    "Policy violation",
    "Payment issue",
    "User request",
    "Temporary hold"
  ];

  String selectedFreezingReason = "Select a reason...";

  void setFreezingReason(String value){
    selectedFreezingReason = value;
    update();
  }


  String getStatus(String status){
    if(status == "0"){
      return "Pending";
    }else if(status == "1"){
      return "Completed";
    }else{
      return "Rejected";
    }
  }

}