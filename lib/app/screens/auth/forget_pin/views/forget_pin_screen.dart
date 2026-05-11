import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/otp_field_widget/otp_field_widget.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/components/text/header_text_smaller.dart';
import 'package:ovopay/app/screens/auth/forget_pin/controller/forget_pin_controller.dart';
import 'package:ovopay/app/screens/onboard/views/widget/onboard_body.dart';
import 'package:ovopay/core/data/models/onboard/onboard_model.dart';
import 'package:ovopay/core/data/repositories/auth/login_repo.dart';
import 'package:ovopay/core/route/route.dart';

import '../../../../../core/utils/util_exporter.dart';

class ForgotPinScreen extends StatefulWidget {
  const ForgotPinScreen({super.key});

  @override
  State<ForgotPinScreen> createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends State<ForgotPinScreen> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    Get.put(LoginRepo());
    Get.put(ForgetPinController(loginRepo: Get.find()));

    super.initState();
    // Add listener to track page changes
    _pageController.addListener(_pageChangeListener);
  }

  void _pageChangeListener() {
    int newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  @override
  void dispose() {
    // Remove listener when the widget is disposed to avoid memory leaks
    _pageController.removeListener(_pageChangeListener);
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage({int? goToPage}) {
    setState(() {
      _pageController.animateToPage(
        goToPage ?? ++_currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  void _previousPage({int? goToPage}) {
    setState(() {
      _pageController.animateToPage(
        goToPage ?? --_currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      // hideAppBar: _currentPage == 0,
      pageTitle: MyStrings.forgetPassword,
      onBackButtonTap: () {
        if (_currentPage != 0) {
          _previousPage();
        } else {
          Get.back();
        }
      },
      body: GetBuilder<ForgetPinController>(
        builder: (controller) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // _buildForgotPinFirstStepPage(),
              _buildIdentityVerificationPage(controller),
              _buildCodeVerificationPage(controller),
              _buildPasswordResetPage(controller),
              _buildSuccessPage(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForgotPinFirstStepPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnBoardBody(
            data: OnBoardModel(
              title: MyStrings.forgotYourPin.tr,
              subtitle: MyStrings.forgotPinMSG.tr,
              image: MyImages.forgotFinPageImage,
              isSvg: false,
            ),
          ),
          spaceDown(Dimensions.space50),
          CustomElevatedBtn(
            radius: Dimensions.largeRadius.r,
            bgColor: MyColor.getPrimaryColor(),
            text: MyStrings.resetPin,
            onTap: () async {
              _nextPage(goToPage: 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityVerificationPage(ForgetPinController controller) {
    return SingleChildScrollView(
      child: Form(
        key: formKey1,
        child: Column(
          children: [
            //Identity Verification
            CustomAppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: HeaderText(
                      textAlign: TextAlign.center,
                      text: MyStrings.verifyYourIdentity.tr,
                      textStyle: MyTextStyle.headerH3.copyWith(
                        color: MyColor.getHeaderTextColor(),
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space8),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: HeaderTextSmaller(
                      textAlign: TextAlign.center,
                      text: MyStrings.verifyYourIdentitySubTitle.tr,
                      textStyle: MyTextStyle.sectionSubTitle1.copyWith(
                        color: MyColor.getBodyTextColor(),
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space35),
                  RoundedTextField(
                    controller: controller.userNameOrEmailController,
                    labelText: MyStrings.emailOrUsername,
                    hintText: MyStrings.enterYourEmailOrUsername,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return MyStrings.enterYourEmailOrUsername.tr;
                      }
                      return null;
                    },
                  ),
                  spaceDown(Dimensions.space10),
                ],
              ),
            ),
            spaceDown(Dimensions.space15),
            CustomElevatedBtn(
              radius: Dimensions.largeRadius.r,
              isLoading: controller.submitLoading,
              bgColor: MyColor.getPrimaryColor(),
              text: MyStrings.confirm,
              onTap: () {
                if (formKey1.currentState?.validate() ?? false) {
                  printW("validated");
                  controller.verifyYourEmail(
                    onSuccess: () {
                      _nextPage(goToPage: 1);
                    },
                  );
                } else {
                  // Form is invalid, show validation errors
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeVerificationPage(ForgetPinController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //Code Verification
          CustomAppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.center,
                  child: HeaderText(
                    textAlign: TextAlign.center,
                    text: MyStrings.enterVerificationCode.tr,
                    textStyle: MyTextStyle.headerH3.copyWith(
                      color: MyColor.getHeaderTextColor(),
                    ),
                  ),
                ),
                spaceDown(Dimensions.space8),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: HeaderText(
                    text: "${MyStrings.weHaveSentACodeTo.tr} ${controller.getFormatMail()?.tr ?? MyStrings.yourEmail.tr}",
                    textStyle: MyTextStyle.sectionSubTitle1.copyWith(color: MyColor.getBodyTextColor()),
                  ),
                ),
                spaceDown(Dimensions.space35),
                OTPFieldWidget(
                  // controller: controller.otpController,
                  onChanged: controller.onChangeOtpField,
                ),
                spaceDown(Dimensions.space10),
              ],
            ),
          ),
          spaceDown(Dimensions.space15),
          CustomElevatedBtn(
            radius: Dimensions.largeRadius.r,
            isLoading: controller.submitLoading,
            bgColor: MyColor.getPrimaryColor(),
            text: MyStrings.verifyNow,
            onTap: () {
              controller.verifyForgotPassCode(
                onSuccess: () {
                  _nextPage(goToPage: 2);
                },
              );
            },
          ),
          spaceDown(Dimensions.space24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "${MyStrings.didNotReceiveCode.tr} ",
              style: MyTextStyle.sectionSubTitle1,
              children: <TextSpan>[
                TextSpan(
                  text: controller.resendLoading ? "${MyStrings.resending.tr}..." : MyStrings.resendCode.tr,
                  style: MyTextStyle.sectionSubTitle1.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: MyColor.getPrimaryColor(),
                    color: MyColor.getPrimaryColor(),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (!controller.resendLoading) {
                        controller.sendCodeAgain();
                      }
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordResetPage(ForgetPinController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.center,
                  child: HeaderText(
                    textAlign: TextAlign.center,
                    text: MyStrings.resetYourPassword.tr,
                    textStyle: MyTextStyle.headerH3.copyWith(
                      color: MyColor.getHeaderTextColor(),
                    ),
                  ),
                ),

                spaceDown(Dimensions.space35),
                Form(
                  key: formKey2,
                  child: Column(
                    children: [
                      RoundedTextField(
                        controller: controller.pinController,
                        focusNode: controller.pinFocusNode,
                        labelText: MyStrings.password,
                        hintText: MyStrings.enterYourPassword,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        nextFocus: controller.cPinFocusNode,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return MyStrings.kPasswordIsRequired.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      spaceDown(Dimensions.space16),
                      RoundedTextField(
                        controller: controller.cPinController,
                        focusNode: controller.cPinFocusNode,
                        labelText: MyStrings.confirmPassword,
                        hintText: MyStrings.enterYourConfirmPassword,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return MyStrings.kConfirmPasswordRequired.tr;
                          }
                          if (controller.cPinController.text != controller.pinController.text) {
                            return MyStrings.kMatchPasswordError.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                spaceDown(Dimensions.space10),
              ],
            ),
          ),
          spaceDown(Dimensions.space15),
          CustomElevatedBtn(
            isLoading: controller.submitLoading,
            radius: Dimensions.largeRadius.r,
            bgColor: MyColor.getPrimaryColor(),
            text: MyStrings.continueText,
            onTap: () {
              if (formKey2.currentState?.validate() ?? false) {
                printW("validated");
                controller.resetPassword(
                  onSuccess: () {
                    _nextPage(goToPage: 3);
                  },
                );
              } else {
                // Form is invalid, show validation errors
              }
            },
          ),
          spaceDown(Dimensions.space15),
          CustomElevatedBtn(
            elevation: 0,
            radius: Dimensions.largeRadius.r,
            bgColor: MyColor.getWhiteColor(),
            textColor: MyColor.getDarkColor(),
            text: MyStrings.cancel,
            borderColor: MyColor.getBorderColor(),
            shadowColor: MyColor.getWhiteColor(),
            onTap: () {
              Get.offAllNamed(RouteHelper.loginScreen);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessPage() {
    return Column(
      children: [
        CustomAppCard(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: Dimensions.space16.w,
            vertical: Dimensions.space56.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Lottie.asset(
                    MyIcons.successLottieIcon,
                    repeat: false,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.contain,
                    width: 150.w,
                    height: 150.h,
                  ),
                ),
              ),
              spaceDown(Dimensions.space8),
              Align(
                alignment: AlignmentDirectional.center,
                child: HeaderText(
                  textAlign: TextAlign.center,
                  text: MyStrings.resetYourPasswordSuccess.tr,
                  textStyle: MyTextStyle.headerH3.copyWith(
                    color: MyColor.getHeaderTextColor(),
                  ),
                ),
              ),
              spaceDown(Dimensions.space24),
              CustomElevatedBtn(
                radius: Dimensions.largeRadius.r,
                bgColor: MyColor.getPrimaryColor(),
                text: MyStrings.login,
                onTap: () {
                  Get.offAndToNamed(RouteHelper.loginScreen);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
