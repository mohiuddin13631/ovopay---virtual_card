import 'dart:convert';

import 'package:get/get.dart';
import 'package:ovopay/core/data/models/user/user_model.dart';
import 'package:ovopay/core/data/repositories/card_repo/create_card_repo.dart';

import '../../../../core/data/models/card/topup_wallet_response_model.dart';
import '../../../../core/data/models/global/response_model/response_model.dart';
import '../../../../core/utils/my_strings.dart';
import '../../../../core/utils/util.dart';
import '../../../components/snack_bar/show_custom_snackbar.dart';

class CreateNewCardController extends GetxController {
  CreateCardRepo repo = CreateCardRepo();

  CreateNewCardController({required this.repo});

  ChargeSetting? chargeSetting;
  UserModel? user;
  bool isLoading = true;

  Future<void> createNewCardInfo() async {

    isLoading = true;
    update();

    try {
      ResponseModel responseModel = await repo.createNewCard();
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
}