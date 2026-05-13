import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/models/card/card_pin_verify_response_model.dart';
import 'package:ovopay/core/data/models/country_model/country_model.dart';
import 'package:ovopay/core/data/models/global/module/app_module_response_model.dart';
import 'package:ovopay/core/data/models/global/response_model/response_model.dart';
import 'package:ovopay/core/data/models/home/dashbaord_response_model.dart';
import 'package:ovopay/core/data/models/home/offers_response_model.dart';
import 'package:ovopay/core/data/models/transaction_history/transaction_history_model.dart';
import 'package:ovopay/core/data/repositories/auth/general_setting_repo.dart';
import 'package:ovopay/core/data/repositories/card/card_repo.dart';
import 'package:ovopay/core/data/repositories/home/home_repo.dart';
import '../../../../core/data/services/service_exporter.dart';
import '../../../../core/utils/util_exporter.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class HomeController extends GetxController {
  HomeRepo homeRepo = HomeRepo();
  CardRepo cardRepo = CardRepo();
  GeneralSettingRepo generalSettingRepo = GeneralSettingRepo();
  bool isPageLoading = true;
  bool isLoading = false;
  List<BannerModel> bannersList = [];
  List<OfferModel> offersList = [];
  List<TransactionHistoryModel> transactionHistoryList = [];
  String accountBalance = "0.00";
  String get accountBalanceFormatted => accountBalance;
  String kycStatus = "1"; //Kyc Status
  String kycReason = ""; //Kyc Reason
  String currency = "";
  List<CardModel> cardList = [];
  TextEditingController pinController = TextEditingController();
  bool isCardLoading = false;
  bool isCardDetailsLoading = false;

  Future initController({bool forceLoad = true}) async {

    isPageLoading = forceLoad;
    update();
    await Future.wait([
      loadCountryDataAndSaveToLocalStorage(),
      loadModuleDataAndSaveToLocalStorage(),
      loadDashBoardInfo(forceLoad: forceLoad),
      loadCardData(forceLoad: forceLoad),
      getTransactionHistoryDataList(forceLoad: forceLoad),
    ]);
    isPageLoading = false;
    update();
  }

  Future loadDashBoardInfo({bool forceLoad = true}) async {

    if (forceLoad) {
      isLoading = forceLoad;
      update();
    }

    try {
      ResponseModel responseModel = await homeRepo.dashboardInfo();
      if (responseModel.statusCode == 200) {
        final dashboardResponseModel = dashboardResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (dashboardResponseModel.status?.toLowerCase() == AppStatus.SUCCESS.toLowerCase()) {
          String kv = dashboardResponseModel.data?.user?.kv ?? "";
          String? kycRejectionReason = dashboardResponseModel.data?.user?.kycRejectionReason;
          kycReason = kycRejectionReason ?? "";
          kycStatus = (kv == "0" && kycRejectionReason == null)
              ? AppStatus.KYC_REQUIRED
              : (kv == "2")
                  ? AppStatus.KYC_PENDING
                  : (kv == "0" && kycRejectionReason != null)
                      ? AppStatus.KYC_REJECTED
                      : AppStatus.KYC_APPROVED;
          accountBalance = dashboardResponseModel.data?.user?.balance ?? "0.00";
          SharedPreferenceService.setUserBalance(accountBalance);
          SharedPreferenceService.setString(
            SharedPreferenceService.userImageKey,
            dashboardResponseModel.data?.user?.getUserImageUrl() ?? "",
          );
          bannersList = dashboardResponseModel.data?.banners ?? [];
          offersList = dashboardResponseModel.data?.offers ?? [];
        } else {
          isLoading = false;
          update();
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  bool isHistoryLoading = false;

  Future<void> getTransactionHistoryDataList({bool forceLoad = true}) async {
    try {
      isHistoryLoading = forceLoad;
      update();
      ResponseModel responseModel = await homeRepo.transactionHistory(1);

      if (responseModel.statusCode == 200) {
        final transactionHistoryResponseModel = transactionHistoryResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (transactionHistoryResponseModel.status == "success") {
          transactionHistoryList = transactionHistoryResponseModel.data?.transactions?.historyData ?? [];
        } else {
          CustomSnackBar.error(
            errorList: transactionHistoryResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
        isHistoryLoading = false;
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
    isHistoryLoading = false;
    update();
  }

  Future loadCountryDataAndSaveToLocalStorage() async {
    try {
      ResponseModel response = await generalSettingRepo.getCountryList();
      if (response.statusCode == 200) {
        CountryModel countryModel = CountryModel.fromJson(
          response.responseJson,
        );

        await SharedPreferenceService.setCountryJsonDataData(countryModel);
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [e.toString()]);
    }
  }

  Future loadModuleDataAndSaveToLocalStorage() async {
    try {
      ResponseModel response = await generalSettingRepo.getModuleList();
      if (response.statusCode == 200) {

        final appModuleResponseModel = appModuleResponseModelFromJson(
          jsonEncode(response.responseJson),
        );

        await SharedPreferenceService.setModuleJsonDataData(
          appModuleResponseModel,
        );
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [e.toString()]);
    }
  }

  Future<void> loadCardData({bool forceLoad = true}) async {
    currency = SharedPreferenceService.getCurrencySymbol();

    if (forceLoad) {
      isCardLoading = true;
      update();
    }

    try {
      final responseModel = await cardRepo.getCardList();

      if (responseModel.statusCode == 200) {
        final cardListResponseModel = cardListResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );

        if (cardListResponseModel.status == AppStatus.SUCCESS.toLowerCase()) {
          cardList = cardListResponseModel.data?.cards?.data ?? [];
        } else {
          CustomSnackBar.error(
            errorList: cardListResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isCardLoading = false;
      update();
    }
  }

  void hideCardDetails(int index) {
    if (index < 0 || index >= cardList.length) return;

    cardList[index].isShowCardView = false;
    update();
  }

  Future<void> cardPinVerification({required String cardId, required int index}) async {
    if (pinController.text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.pleaseEnterPin]);
      return;
    }

    try {
      isCardDetailsLoading = true;
      update();

      final responseModel = await cardRepo.pinVerificationRequest(
        pin: pinController.text,
        cardId: cardId,
      );

      if (responseModel.statusCode == 200) {
        final model = cardPinVerifyResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );

        if (model.status == AppStatus.SUCCESS.toLowerCase()) {
          final verifiedCard = model.data?.card;

          if (verifiedCard != null && index >= 0 && index < cardList.length) {
            cardList[index] = verifiedCard;
            cardList[index].isShowCardView = true;
          }

          pinController.clear();
          Get.back();
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isCardDetailsLoading = false;
      update();
    }
  }

  //Balance Hide Unhide Logics
  bool isBalanceVisible = false;
  Timer? _autoHideTimer;

  void toggleBalanceVisibility() {
    isBalanceVisible = !isBalanceVisible;
    update(); // triggers GetBuilder

    if (isBalanceVisible) {
      _startAutoHideTimer();
    } else {
      _autoHideTimer?.cancel();
    }
  }

  void _startAutoHideTimer() {
    _autoHideTimer?.cancel(); // clear any existing timer
    _autoHideTimer = Timer(Duration(seconds: 10), () {
      isBalanceVisible = false;
      update(); // auto-hide triggered
    });
  }

  @override
  void onClose() {
    _autoHideTimer?.cancel();
    pinController.dispose();
    super.onClose();
  }
}
