import 'dart:convert';
import 'package:get/get.dart';
import 'package:ovopay/core/data/models/card/topup_wallet_response_model.dart';
import '../../../../core/data/models/card/card_details_response_model.dart';
import '../../../../core/data/models/global/response_model/response_model.dart';
import '../../../../core/data/repositories/card/card_repo.dart';
import '../../../../core/data/services/shared_pref_service.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/util.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class ChargesAndFeesController extends GetxController{

  CardRepo cardRepo;
  ChargesAndFeesController({required this.cardRepo});

  String? currency;
  bool isLoading = true;

  ChargeSetting? chargeSetting;

  Future<void> loadChargeSetting() async {

    currency = SharedPreferenceService.getCurrencySymbol();

    isLoading = true;
    update();

    try {
      ResponseModel responseModel = await cardRepo.getChargeSettings();
      if (responseModel.statusCode == 200) {
        final cardDetails = cardDetailsResponseModelFromJson(jsonEncode(responseModel.responseJson));
        if (cardDetails.status == "success") {
          chargeSetting = cardDetails.data?.chargeSetting;
        } else {
          CustomSnackBar.error(errorList: cardDetails.message ?? [MyStrings.somethingWentWrong]);
        }
        update();
        isLoading = false;
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
    isLoading = false;
    update();
  }
}