import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/models/user/user_model.dart';
import 'package:ovopay/core/data/repositories/card_repo/create_card_repo.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/environment.dart';

import '../../../../core/data/models/card/topup_wallet_response_model.dart';
import '../../../../core/data/models/country_model/country_model.dart';
import '../../../../core/data/models/global/response_model/response_model.dart';
import '../../../../core/data/services/shared_pref_service.dart';
import '../../../../core/helper/date_converter.dart';
import '../../../../core/helper/string_format_helper.dart';
import '../../../../core/utils/file_selectors.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/util.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class CreateNewCardController extends GetxController {
  CreateCardRepo repo = CreateCardRepo();

  CreateNewCardController({required this.repo});


  TextEditingController fullNameController = TextEditingController();
  TextEditingController carNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController initialDepositController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  TextEditingController roadNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController billingAddressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  final newCardFormKey = GlobalKey<FormState>();

  ChargeSetting? chargeSetting;
  UserModel? user;
  bool isLoading = true;
  String currency = "\$";

  List<ExistingCardHolder> existingCardHoldersList = [];

  Future<void> createNewCardInfo() async {

    currency = SharedPreferenceService.getCurrencySymbol();

    isLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.createNewCardInfo();
      if (responseModel.statusCode == 200) {
        existingCardHoldersList.clear();
        final model = topUpWalletResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (model.status == "success") {
          chargeSetting = model.data?.chargeSetting;
          user = model.data?.user;

          initialDepositController.text = chargeSetting?.minLimit ?? "";

          // existingCardHoldersList.add(ExistingCardHolder(firstName: "Select", lastName: "One", id: -1));
          // existingCardHoldersList.addAll(model.data?.existingCardHolders ?? []);
          existingCardHoldersList = model.data?.existingCardHolders ?? [];
          // selectedExistingUser = existingCardHoldersList[0];
          update();
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

  List<String> idTypeList = [
    "National ID",
    "Passport",
    "Driver's License",
  ];



  String dobDay = "";
  String dobMonth = "";
  String dobYear = "";

  void setDob(DateTime date) {
    dobDay = date.day.toString();
    dobMonth = date.month.toString();
    dobYear = date.year.toString();
    dobController.text = DateConverter.formatDate(date.toString());
    update();
  }

  final FileSelector _fileSelector = FileSelector();
  List<File> attachmentList = [];

  String? selectedIdType = MyStrings.selectOne.tr;

  void setIdType(String? newValue) {
    selectedIdType = newValue;
    update();
  }

  String? selectedExistingCardHolderEmail = MyStrings.selectOne;
  ExistingCardHolder? selectedExistingCardHolder;
  void setExistingUser(String? newValue) {
    selectedExistingCardHolderEmail = newValue;
    selectedExistingCardHolder = existingCardHoldersList.firstWhere((element) => element.customerEmail == newValue);
    updateUserInformation(true);
    update();
  }


  File? idCardImage;
  void pickIdCardImage() async {
    File? filesResult = await _fileSelector.selectImageFromGallery().then((value) {
      idCardImage = value;
    });
    update();
    return;
  }

  File? userImage;
  void pickUserImage() async {
    File? filesResult = await _fileSelector.selectImageFromGallery().then((value) {
      userImage = value;
    });
    update();
    return;
  }

  // String getIdCardHintText(){
  //   if(idCardImage != null){
  //     return idCardImage?.path.split('/').last ?? "";
  //   }else if(selectedExistingCardHolder?.idImage != null && isExistingUser){
  //     return selectedExistingCardHolder?.idImage?.split("/").last ?? "";
  //   }else{
  //     return MyStrings.chooseAFile.tr;
  //   }
  // }
  // String getUserImageHintText(){
  //   if(idCardImage != null){
  //     return idCardImage?.path.split('/').last ?? "";
  //   }else if(selectedExistingCardHolder?.idImage != null && isExistingUser){
  //     return selectedExistingCardHolder?.idImage?.split("/").last ?? "";
  //   }else{
  //     return MyStrings.chooseAFile.tr;
  //   }
  // }

  bool isExistingUser = false;
  void updateUserInformation(bool isExisting){
    isExistingUser = isExisting;
    /*if(isExistingUser && selectedExistingCardHolder != null){
      firstNameController.text = selectedExistingCardHolder?.firstName ?? "";
      lastNameController.text = selectedExistingCardHolder?.lastName?? "";
      emailController.text = selectedExistingCardHolder?.customerEmail?? "";
      mobileController.text = selectedExistingCardHolder?.phoneNumber?? "";
      idNumberController.text = selectedExistingCardHolder?.idNumber?? "";
      dobController.text = selectedExistingCardHolder?.dateOfBirth?? "";
      cityController.text = selectedExistingCardHolder?.city?? "";
      stateController.text = selectedExistingCardHolder?.state?? "";
      zipCodeController.text = selectedExistingCardHolder?.zipCode?? "";
      houseNumberController.text = selectedExistingCardHolder?.houseNumber?? "";
      roadNumberController.text = selectedExistingCardHolder?.line1?? "";

    }else{
      carNameController.clear();
      emailController.clear();
    }*/
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
      "bg_image" : Get.find<CardController>().selectedCardImage.split('/').last,
      "card_type" : cardType,
      "name" : carNameController.text,
      "amount" : initialDepositController.text,
      "country" : countryData?.id.toString() ?? Environment.defaultCountryId,
      "phone_number" : "${countryData?.dialCode ?? Environment.defaultPhoneDialCode}${mobileNumberController.text}",
      "id_number" : idNumberController.text,
      "id_type" : selectedIdType?.toLowerCase().replaceAll(" ", "_"),
      "birthday_month" : dobMonth,
      "birthday" : dobDay,
      "birthday_year" : dobYear,
      "city" : cityController.text,
      "state" : stateController.text,
      "postal_code" : zipCodeController.text,
      "line_1" : roadNumberController.text,
      // "info_type" : "new",
      // "first_name" : firstNameController.text,
      // "last_name" : lastNameController.text,
      // "customer_email" : emailController.text,
      // "house_number" : houseNumberController.text,
    };

    // Map<String, File> attachment = {
    //   "id_image" : idCardImage ?? File(""),
    //   "user_photo" : userImage ?? File(""),
    // };

    try {
      ResponseModel responseModel = await repo.createNewCard(map: map);
      if (responseModel.statusCode == 200) {
        final model = topUpWalletResponseModelFromJson(jsonEncode(responseModel.responseJson));
        if (model.status == "success") {
          Get.offAndToNamed(RouteHelper.cardDetailsScreen, arguments: CardInfo(cardModel: model.data?.card ?? CardModel()));
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


  Future<void> createNewCardFromExistingUser({required String cardType}) async {

    isSubmitLoading = true;
    update();

    Map<String, dynamic> map = {
      "card_type" : cardType,
      "name_on_card" : carNameController.text,
      "amount" : initialDepositController.text,
      "bg_image" : Get.find<CardController>().selectedCardImage.split('/').last,
      "info_type" : "existing",
      "card_holder_id" : selectedExistingCardHolder?.id.toString(),
    };

    try {
      ResponseModel responseModel = await repo.createNewCardFromExistingUser(map: map);
      if (responseModel.statusCode == 200) {
        final model = topUpWalletResponseModelFromJson(jsonEncode(responseModel.responseJson));
        if (model.status == "success") {
          Get.offAndToNamed(RouteHelper.cardDetailsScreen, arguments: CardInfo(cardModel: model.data?.card ?? CardModel()));
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