import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovopay/core/data/models/card/card_details_response_model.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/models/card/card_pin_verify_response_model.dart';
import 'package:ovopay/core/data/repositories/card/card_repo.dart';
import 'package:ovopay/core/data/services/service_exporter.dart';
import 'package:ovopay/core/utils/my_images.dart';

import '../../../../core/data/models/global/response_model/response_model.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/util.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class CardController extends GetxController {

  CardRepo cardRepo;
  CardController({required this.cardRepo});

  final double cardHeight = 344;
  final double overlap = 40;

  bool isAnimating = false;
  bool swipeDown = true;

  String selectedCardImage = MyImages.imageOne;

  List<String> cardImages = [
    MyImages.imageOne,
    MyImages.imageTwo,
    MyImages.imageThree,
  ];

  void onSwipe(bool down) async {
    if (isAnimating) return;

      isAnimating = true;
      swipeDown = down;
      update();


    // Wait for animation
    await Future.delayed(const Duration(milliseconds: 260));
      if (down) {
        cardList.add(cardList.removeAt(0));
        cardImages.add(cardImages.removeAt(0));
      } else {
        cardList.insert(0, cardList.removeLast());
        cardImages.insert(0, cardImages.removeLast());
      }
      isAnimating = false;
      update();
  }

  TextEditingController pinController = TextEditingController();

  bool isLoading = true;
  int page = 0;
  String? nextPageUrl;

  List<CardModel> cardList = [];
  String currency = "";

  CardModel? cardModel;

  Future<void> loadData({bool forceLoad = true}) async {
    currency = SharedPreferenceService.getCurrencySymbol();
    try {
      page = page + 1;
      isLoading = forceLoad;
      update();

      if(page == 1){
        cardList.clear();
      }

      ResponseModel responseModel = await cardRepo.getCardList();

      if (responseModel.statusCode == 200) {
        final cardListResponseModel = cardListResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (cardListResponseModel.status == "success") {
          nextPageUrl = cardListResponseModel.data?.cards?.nextPageUrl;
          cardList.addAll(cardListResponseModel.data?.cards?.data ?? []);
        } else {
          CustomSnackBar.error(
            errorList: cardListResponseModel.message ?? [MyStrings.somethingWentWrong],
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

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  void hideCardDetails(int index) {
    if (index < 0 || index >= cardList.length) return;

    cardList[index].isShowCardView = false;
    update();
  }


  bool isCardDetailsLoading = false;
  Future<void> getCardDetails(String id) async {

    isCardDetailsLoading = true;
    update();

    try {
      ResponseModel responseModel = await cardRepo.getCardDetails(id);
      if (responseModel.statusCode == 200) {
        final cardDetails = cardDetailsResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (cardDetails.status == "success") {
          cardModel = cardDetails.data?.card;
        } else {
          CustomSnackBar.error(
            errorList: cardDetails.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
        isCardDetailsLoading = false;
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
    isCardDetailsLoading = false;
    update();
  }


  Future<void> cardPinVerification({int index = -1, required String cardId, CardModel? cardData}) async {

    if(pinController.text.isEmpty){
      return CustomSnackBar.error(errorList: [MyStrings.pleaseEnterPin]);
    }

    try {

      isCardDetailsLoading = true;
      update();

      ResponseModel responseModel = await cardRepo.pinVerificationRequest(pin: pinController.text,cardId: cardId);
      if (responseModel.statusCode == 200) {
        CardPinVerifyResponseModel model =  cardPinVerifyResponseModelFromJson(jsonEncode(responseModel.responseJson));

        if (model.status == "success") {

          CardModel? cardModel = model.data?.card;

          if (cardModel != null && index != -1) {
            cardList[index] = cardModel;
            cardList[index].isShowCardView = true;
          }else{
            cardModel = cardData;
            cardModel?.isShowCardView = true;
          }
          pinController.clear();
          Get.back();
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
      isCardDetailsLoading = false;
      update();
      printE(e.toString());
    } finally {
      isCardDetailsLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    pinController.dispose();
    super.onClose();
  }

}

class CardInfo{
  String? cardBgImage;
  CardModel cardModel;
  CardInfo({this.cardBgImage, required this.cardModel});
}
