import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovopay/core/data/models/card/card_details_response_model.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/models/card/card_pin_verify_response_model.dart';
import 'package:ovopay/core/data/repositories/card/card_repo.dart';
import 'package:ovopay/core/data/services/service_exporter.dart';
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

  int selectedCardColorIndex = 0;

  List<List<Color>> cards = [
    [
      Color(0xff24113E),
      Color(0xff24113E),
      // Color(0xff565564),
      Color(0xff641990),
      Color(0xff5B16DF),
    ],
    [
      Color(0xff0D0B2A),
      Color(0xff481928),
      Color(0xffEA3E23),
      Color(0xffF89E26),
    ],
    [
      Color(0xff121630),
      Color(0xff7D13D2),
      Color(0xff5576EF),
      // Color(0xff121630),
      // Color(0xff5CA3F7),
    ],
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
        cards.add(cards.removeAt(0));
      } else {
        cardList.insert(0, cardList.removeLast());
        cards.insert(0, cards.removeLast());
      }
      isAnimating = false;
      update();
  }

  TextEditingController pinController = TextEditingController();

  bool isLoading = false;
  int page = 0;
  String? nextPageUrl;

  List<CardModel> cardList = [];
  String currency = "";

  CardModel? cardModel;

  bool isShowCardDetails = false;

  Future<void> loadData({bool forceLoad = true}) async {
    currency = SharedPreferenceService.getCurrencySymbol();
    try {
      page = page + 1;
      isLoading = forceLoad;
      update();
      ResponseModel responseModel = await cardRepo.getCardList(index: page.toString());

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


  Future<void> cardPinVerification({required int index, required String cardId}) async {

    try {

      isCardDetailsLoading = true;
      update();

      ResponseModel responseModel = await cardRepo.pinVerificationRequest(pin: pinController.text,cardId: cardId);
      if (responseModel.statusCode == 200) {
        CardPinVerifyResponseModel model =  cardPinVerifyResponseModelFromJson(jsonEncode(responseModel.responseJson));

        if (model.status == "success") {

          CardModel? cardModel = model.data?.card;

          if (cardModel != null) {
            cardList[index] = cardModel;
            cardList[index].isShowCardView = true;


            print("card view : ---------");
            print(cardList[index + 1].isShowCardView);
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
}

class CardInfo{
  List<Color> color;

  CardInfo({required this.color});
}