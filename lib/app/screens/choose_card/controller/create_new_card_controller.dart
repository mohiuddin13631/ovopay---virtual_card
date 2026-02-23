import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/models/user/user_model.dart';
import 'package:ovopay/core/data/repositories/card_repo/create_card_repo.dart';
import 'package:ovopay/core/route/route.dart';

import '../../../../core/data/models/card/topup_wallet_response_model.dart';
import '../../../../core/data/models/country_model/country_model.dart';
import '../../../../core/data/models/global/response_model/response_model.dart';
import '../../../../core/data/services/shared_pref_service.dart';
import '../../../../core/helper/string_format_helper.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/util.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class CreateNewCardController extends GetxController {
  CreateCardRepo repo = CreateCardRepo();

  CreateNewCardController({required this.repo});


  TextEditingController fullNameController = TextEditingController();
  TextEditingController carNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController initialDepositController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController billingAddressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  final newCardFormKey = GlobalKey<FormState>();

  ChargeSetting? chargeSetting;
  UserModel? user;
  bool isLoading = true;
  String currency = "\$";

  Future<void> createNewCardInfo() async {

    currency = SharedPreferenceService.getCurrencySymbol();

    isLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.createNewCardInfo();
      if (responseModel.statusCode == 200) {
        final model = topUpWalletResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (model.status == "success") {
          chargeSetting = model.data?.chargeSetting;
          user = model.data?.user;
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

  List<String> shippingMethodList = [
    MyStrings.standardShipping.tr,
    MyStrings.expressShipping.tr,
  ];

  bool isExistingUser = false;
  void updateUserInformation(bool isExisting){
    isExistingUser = isExisting;
    if(isExistingUser){
      carNameController.text = "${user?.firstname ?? ""} ${user?.lastname ?? ""}";
      emailController.text = (user?.email ?? "");
    }else{
      carNameController.clear();
      emailController.clear();
    }
    update();
  }

  int selectedShippingMethod = 1;
  void changeShippingMethod(int index){
    selectedShippingMethod = index;
    update();
  }


  CountryData? countryData;
  TextEditingController countryController = TextEditingController();

  void selectedCountryData(CountryData value) {
    countryData = value;
    countryController.text = value.name ?? "";
    SharedPreferenceService.setSelectedOperatingCountry(value);
    update();
  }

  String getTotal(){
    double creationFee = AppConverter.formatNumberDouble(chargeSetting?.creationFee ?? "");
    double perTransactionFee = AppConverter.formatNumberDouble(chargeSetting?.perOperationCharge ?? "");
    double initialDepositAmount = AppConverter.formatNumberDouble(initialDepositController.text);

    return AppConverter.formatNumber((creationFee + perTransactionFee + initialDepositAmount).toString());
  }


  bool isSubmitLoading = false;
  Future<void> createNewCard({required String cardType}) async {

    isSubmitLoading = true;
    update();

    Map<String, dynamic> map = {
      "card_type" : cardType,
      "name_on_card" : carNameController.text,
      "email" : emailController.text,
      "amount" : initialDepositController.text
    };

    try {
      ResponseModel responseModel = await repo.createNewCard(map: map);
      if (responseModel.statusCode == 200) {
        final model = topUpWalletResponseModelFromJson(jsonEncode(responseModel.responseJson));
        if (model.status == "success") {
          Get.offAndToNamed(RouteHelper.cardDetailsScreen, arguments: CardInfo(color: [
            Color(0xff24113E),
            Color(0xff24113E),
            Color(0xff641990),
            Color(0xff5B16DF),
          ], cardModel: model.data?.card ?? CardModel()));
          CustomSnackBar.success(successList: [MyStrings.cardCreatedSuccessfully]);
        } else {
          CustomSnackBar.error(errorList: model.message ?? [MyStrings.somethingWentWrong]);
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
}