import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/custom_loader/custom_loader.dart';
import 'package:ovopay/app/components/dialog/app_dialog.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/screens/profile_and_settings_screen/controller/change_pin_controller.dart';
import 'package:ovopay/core/data/repositories/account/change_password_repo.dart';
import 'package:ovopay/core/utils/util_exporter.dart';

import '../../../../core/data/services/service_exporter.dart';

class ChangPasswordScreen extends StatefulWidget {
  const ChangPasswordScreen({super.key});

  @override
  State<ChangPasswordScreen> createState() => _ChangPasswordScreenState();
}

class _ChangPasswordScreenState extends State<ChangPasswordScreen> {
  @override
  void initState() {
    Get.put(ChangePasswordRepo());
    var controller = Get.put(ChangePinController(changePasswordRepo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChangePinController>().clearData();

    });
  }

  @override
  void dispose() {
    Get.find<ChangePinController>().clearData();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePinController>(
      builder: (controller) => MyCustomScaffold(
        pageTitle: MyStrings.changePassword,
        body: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            children: [
              CustomAppCard(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //Current pin
                          RoundedTextField(
                            labelText: MyStrings.currentPassword,
                            hintText: MyStrings.enterCurrentPassword,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly, // Allow only digits
                              LengthLimitingTextInputFormatter(
                                SharedPreferenceService.getMaxPinNumberDigit(),
                              ), // Limit to 5 characters
                            ],
                            isPassword: true,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return MyStrings.enterCurrentPassword.tr;
                              } else {
                                return null;
                              }
                            },
                            controller: controller.currentPasswordController,
                            focusNode: controller.currentPasswordFocusNode,
                            nextFocus: controller.passwordFocusNode,
                          ),
                          spaceDown(Dimensions.space20),
                          //Create new pin
                          RoundedTextField(
                            labelText: MyStrings.createNewPassword,
                            hintText: MyStrings.enterNewPassword,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly, // Allow only digits
                              LengthLimitingTextInputFormatter(
                                SharedPreferenceService.getMaxPinNumberDigit(),
                              ), // Limit to 5 characters
                            ],
                            isPassword: true,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return MyStrings.enterNewPassword.tr;
                              } else {
                                return null;
                              }
                            },
                            controller: controller.passwordController,
                            focusNode: controller.passwordFocusNode,
                            nextFocus: controller.confirmPasswordFocusNode,
                          ),
                          spaceDown(Dimensions.space20),
                          //Confirm new pin
                          RoundedTextField(
                            labelText: MyStrings.confirmNewPassword,
                            hintText: MyStrings.enterConfirmPassword,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly, // Allow only digits
                              LengthLimitingTextInputFormatter(
                                SharedPreferenceService.getMaxPinNumberDigit(),
                              ), // Limit to 5 characters
                            ],
                            isPassword: true,
                            validator: (value) {
                              if (controller.confirmPasswordController.text != controller.passwordController.text) {
                                return MyStrings.kMatchPasswordError.tr;
                              } else {
                                return null;
                              }
                            },
                            controller: controller.confirmPasswordController,
                            focusNode: controller.confirmPasswordFocusNode,
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                controller.changePin(
                                  onSuccess: () {
                                    AppDialogs.successDialogForAll(
                                      context,
                                      title: MyStrings.changePassword.tr,
                                      subTitle: MyStrings.passwordChanged.tr,
                                      onTap: () {
                                        Get.back();
                                        Get.back();
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              spaceDown(Dimensions.space20),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedBtn(
                      isLoading: controller.submitLoading,
                      radius: Dimensions.largeRadius.r,
                      bgColor: MyColor.getPrimaryColor(),
                      text: MyStrings.save,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          controller.changePassword(
                            onSuccess: () {
                              AppDialogs.successDialogForAll(
                                context,
                                title: MyStrings.changePassword.tr,
                                subTitle: MyStrings.passwordChanged.tr,
                                onTap: () {
                                  Get.back();
                                  Get.back();
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  spaceSide(Dimensions.space15),
                  Expanded(
                    child: CustomElevatedBtn(
                      radius: Dimensions.largeRadius.r,
                      textColor: MyColor.getDarkColor(),
                      bgColor: MyColor.getWhiteColor(),
                      borderColor: MyColor.getBorderColor(),
                      text: MyStrings.cancel,
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
