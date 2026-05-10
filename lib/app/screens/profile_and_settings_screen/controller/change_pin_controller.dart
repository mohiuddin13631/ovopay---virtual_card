import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopay/core/data/models/authorization/authorization_response_model.dart';
import 'package:ovopay/core/data/models/global/response_model/response_model.dart';

import 'package:ovopay/core/data/repositories/account/change_password_repo.dart';

import '../../../../core/data/models/profile/profile_response_model.dart';
import '../../../../core/data/models/user/user_model.dart';
import '../../../../core/utils/util_exporter.dart';

class ChangePinController extends GetxController {
  ChangePasswordRepo changePasswordRepo;
  ChangePinController({required this.changePasswordRepo});

  String? currentPass, password, confirmPass;

  bool isLoading = false;
  List<String> errors = [];

  TextEditingController pinController = TextEditingController();
  TextEditingController currentPinController = TextEditingController();
  TextEditingController confirmPinController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode currentPinFocusNode = FocusNode();
  FocusNode pinFocusNode = FocusNode();
  FocusNode confirmPinFocusNode = FocusNode();

  FocusNode currentPasswordFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  void addError({required String error}) {
    if (!errors.contains(error)) {
      errors.add(error);
      update();
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      errors.remove(error);
      update();
    }
  }



  UserModel? userModel;
  Future<void> loadUserInfo({bool forceLoad = true}) async {
    if (forceLoad) {
      isLoading = true;
      update();
    }

    try {
      ResponseModel responseModel = await changePasswordRepo.loadUserInfo();
      if (responseModel.statusCode == 200) {
        ProfileResponseModel model = ProfileResponseModel.fromJson(responseModel.responseJson);
        if (model.data != null && model.status?.toLowerCase() == AppStatus.SUCCESS.toLowerCase()) {
          userModel = model.data?.user;
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

  bool submitLoading = false;
  Future<void> changePin({required VoidCallback onSuccess}) async {
    String currentPass = currentPinController.text.toString();
    String password = pinController.text.toString();

    try {
      submitLoading = true;
      update();
      ResponseModel responseModel = await changePasswordRepo.changePin(
        currentPass,
        password,
      );

      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          responseModel.responseJson,
        );
        if (model.status?.toLowerCase() == AppStatus.SUCCESS.toLowerCase()) {
          currentPinController.clear();
          pinController.clear();
          confirmPinController.clear();

          onSuccess();
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.requestFail],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e);
    }
    submitLoading = false;
    update();
  }


  Future<void> changePassword({required VoidCallback onSuccess}) async {
    String currentPass = currentPasswordController.text.toString();
    String password = passwordController.text.toString();

    try {
      submitLoading = true;
      update();
      ResponseModel responseModel = await changePasswordRepo.changePassword(
        currentPass,
        password,
      );

      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          responseModel.responseJson,
        );
        if (model.status?.toLowerCase() == AppStatus.SUCCESS.toLowerCase()) {
          currentPinController.clear();
          pinController.clear();
          confirmPinController.clear();

          onSuccess();
        } else {
          CustomSnackBar.error(
            errorList: model.message ?? [MyStrings.requestFail],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e);
    }
    submitLoading = false;
    update();
  }

  void clearData() {
    isLoading = false;
    errors.clear();
    currentPinController.text = '';
    pinController.text = '';
    confirmPinController.text = '';
  }
}
