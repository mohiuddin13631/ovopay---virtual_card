import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/screens/auth/register/controller/registration_controller.dart';

import '../../../../../../core/utils/util_exporter.dart';

class ProfileCompleteScreen extends StatefulWidget {
  final PageController pageController;
  final int currentPage;
  final Function({int? goToPage}) nextPage;
  final Function({int? goToPage}) previousPage;

  const ProfileCompleteScreen({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.nextPage,
    required this.previousPage,
  });

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomAppCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderText(
                            text: MyStrings.personalInformation.tr,
                            textStyle: MyTextStyle.sectionTitle2.copyWith(
                              color: MyColor.getHeaderTextColor(),
                            ),
                          ),
                          spaceDown(Dimensions.space25),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                RoundedTextField(
                                  controller: controller.fNameController,
                                  labelText: MyStrings.firstName,
                                  hintText: MyStrings.enterYourFirstName,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value.toString().trim().isEmpty) {
                                      return MyStrings.kFirstNameNullError.tr;
                                    }

                                    return null;
                                  },
                                ),
                                spaceDown(Dimensions.space20),
                                RoundedTextField(
                                  controller: controller.lNameController,
                                  labelText: MyStrings.lastName,
                                  hintText: MyStrings.enterYourLastName,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value.toString().trim().isEmpty) {
                                      return MyStrings.kLastNameNullError.tr;
                                    }

                                    return null;
                                  },
                                ),
                                spaceDown(Dimensions.space20),
                                RoundedTextField(
                                  controller: controller.uNameController,
                                  labelText: MyStrings.username,
                                  hintText: MyStrings.enterYourUsername,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value.toString().trim().isEmpty) {
                                      return MyStrings.kUsernameIsRequired.tr;
                                    }

                                    return null;
                                  },
                                ),
                                spaceDown(Dimensions.space20),
                                RoundedTextField(
                                  controller: controller.emailController,
                                  labelText: MyStrings.email,
                                  hintText: MyStrings.enterYourEmailExample,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    final email = value.toString().trim();
                                    if (email.isEmpty || !GetUtils.isEmail(email)) {
                                      return MyStrings.invalidEmailMsg.tr;
                                    }

                                    return null;
                                  },
                                ),
                                spaceDown(Dimensions.space20),
                                RoundedTextField(
                                  controller: controller.pinController,
                                  labelText: MyStrings.password,
                                  hintText: MyStrings.enterYourPassword,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.visiblePassword,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value.toString().trim().isEmpty) {
                                      return MyStrings.kPasswordIsRequired.tr;
                                    }

                                    return null;
                                  },
                                ),
                                spaceDown(Dimensions.space20),
                                RoundedTextField(
                                  controller: controller.cPinController,
                                  labelText: MyStrings.confirmPassword,
                                  hintText: MyStrings.enterYourConfirmPassword,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.visiblePassword,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value.toString().trim().isEmpty) {
                                      return MyStrings.kConfirmPasswordRequired.tr;
                                    }

                                    if (controller.pinController.text != controller.cPinController.text) {
                                      return MyStrings.kMatchPasswordError.tr;
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceDown(Dimensions.space15),
                    CustomElevatedBtn(
                      radius: Dimensions.largeRadius.r,
                      bgColor: MyColor.getPrimaryColor(),
                      isLoading: controller.submitProfileCompleteLoading,
                      text: MyStrings.confirm,
                      onTap: () {
                        MyUtils.clearAllTypeFocusNodes();
                        if (formKey.currentState?.validate() ?? false) {
                          controller.profileCompleteSubmit();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
