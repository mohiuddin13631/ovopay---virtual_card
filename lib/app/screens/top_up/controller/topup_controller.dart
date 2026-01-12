import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/data/models/global/response_model/response_model.dart';
import '../../../../core/data/models/modules/gift_card/gift_submit_response_model.dart';
import '../../../../core/data/repositories/modules/gift_card/gift_card_repo.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/util.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class TopUpController extends GetxController {

  GiftCardRepo giftCardRepo;
  TopUpController({required this.giftCardRepo});

  TextEditingController pinController = TextEditingController();

  bool isSubmitLoading = false;

  String currencySymbol = "\$";
  String currency = "USD";

  Future<void> pinVerificationProcess({
    void Function(GiftSubmitResponseModel)? onSuccessCallback,
  }) async {
    try {
      isSubmitLoading = true;
      update();
      ResponseModel responseModel = await giftCardRepo.pinVerificationRequest(pin: pinController.text);
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

}