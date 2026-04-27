import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/components/otp_field_widget/otp_field_widget.dart';
import 'package:ovopay/app/components/will_pop_widget.dart';
import 'package:ovopay/app/screens/auth/register/controller/registration_controller.dart';
import 'package:ovopay/core/data/models/user/user_model.dart';
import 'package:ovopay/core/data/repositories/auth/signup_repo.dart';
import 'package:ovopay/core/route/route.dart';

import '../../../../../core/utils/util_exporter.dart';

class RegisterScreen extends StatefulWidget {
  final UserModel? userModel;
  const RegisterScreen({super.key, this.userModel});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final formKey = GlobalKey<FormState>();
  bool hasAcceptedPolicies = false;

  void _goToLoginScreen() {
    Get.offAllNamed(RouteHelper.loginScreen);
  }

  void _goToRegisterForm() {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    }
  }

  void _openPrivacyScreen() {
    Get.toNamed(RouteHelper.privacyScreen);
  }

  @override
  void initState() {
    Get.put(RegistrationRepo());
    final controller = Get.put(
      RegistrationController(registrationRepo: Get.find()),
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userModel?.sv == "0") {
        controller.sendAuthorizeCode();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: "",
      action: () {
        _goToLoginScreen();
      },
      child: MyCustomScaffold(
        pageTitle: MyStrings.register,
        onBackButtonTap: () {
          _goToLoginScreen();
        },
        actionButton: [],
        body: GetBuilder<RegistrationController>(
          builder: (controller) {
            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (widget.userModel?.sv == "0") ...[
                  _buildOtpCodeVerificationPage(controller),
                ],
                _buildRegisterFormPage(controller),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOtpCodeVerificationPage(RegistrationController controller) {
    TextSpan buildTimerText(RegistrationController controller) {
      int minutes = controller.time ~/ 60;
      int seconds = controller.time % 60;
      String timeText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      return TextSpan(text: timeText, style: MyTextStyle.sectionSubTitle1);
    }

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
                    text: MyStrings.smsVerification.tr,
                    textStyle: MyTextStyle.headerH3.copyWith(
                      color: MyColor.getHeaderTextColor(),
                    ),
                  ),
                ),
                spaceDown(Dimensions.space8),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: HeaderText(
                    text: "${MyStrings.weHaveSentACodeTo.tr} +${widget.userModel?.dialCode}${widget.userModel?.mobile?.toNumberMask(unmaskedPrefix: 2, unmaskedSuffix: 2, maskChar: "â€¢")}",
                    textStyle: MyTextStyle.sectionSubTitle1.copyWith(
                      color: MyColor.getBodyTextColor(),
                    ),
                  ),
                ),
                spaceDown(Dimensions.space35),
                OTPFieldWidget(
                  onChanged: (v) {
                    controller.onChangeOtpWidgetText(value: v);
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
            text: MyStrings.verifyNow,
            onTap: () {
              controller.verifyYourSms(
                onSuccess: () {
                  _goToRegisterForm();
                },
              );
            },
          ),
          spaceDown(Dimensions.space24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "${controller.isOtpExpired == false ? MyStrings.waitUtilTheTimerFinishes.tr : MyStrings.didNotReceiveCode.tr} ",
              style: MyTextStyle.sectionSubTitle1,
              children: <TextSpan>[
                if (controller.isOtpExpired == false) ...[
                  buildTimerText(controller),
                ] else ...[
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
                          controller.resendOtp();
                        }
                      },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterFormPage(RegistrationController controller) {
    return SingleChildScrollView(
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
          spaceDown(Dimensions.space16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(-6, -10),
                child: Checkbox(
                  value: hasAcceptedPolicies,
                  activeColor: MyColor.getPrimaryColor(),
                  side: BorderSide(
                    color: MyColor.getBorderColor(),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (value) {
                    setState(() {
                      hasAcceptedPolicies = value ?? false;
                    });
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '${MyStrings.iAgreeWith.tr} ',
                        style: MyTextStyle.sectionSubTitle1.copyWith(
                          color: MyColor.getBodyTextColor(),
                        ),
                      ),
                      GestureDetector(
                        onTap: _openPrivacyScreen,
                        child: Text(
                          MyStrings.privacyPolicyText.tr,
                          style: MyTextStyle.sectionSubTitle1.copyWith(
                            color: MyColor.getPrimaryColor(),
                          ),
                        ),
                      ),
                      Text(
                        ', ',
                        style: MyTextStyle.sectionSubTitle1.copyWith(
                          color: MyColor.getBodyTextColor(),
                        ),
                      ),
                      GestureDetector(
                        onTap: _openPrivacyScreen,
                        child: Text(
                          MyStrings.termsOfService.tr,
                          style: MyTextStyle.sectionSubTitle1.copyWith(
                            color: MyColor.getPrimaryColor(),
                          ),
                        ),
                      ),
                      Text(
                        ', ',
                        style: MyTextStyle.sectionSubTitle1.copyWith(
                          color: MyColor.getBodyTextColor(),
                        ),
                      ),
                      GestureDetector(
                        onTap: _openPrivacyScreen,
                        child: Text(
                          MyStrings.servicePolicy.tr,
                          style: MyTextStyle.sectionSubTitle1.copyWith(
                            color: MyColor.getPrimaryColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          spaceDown(Dimensions.space15),
          CustomElevatedBtn(
            radius: Dimensions.largeRadius.r,
            bgColor: MyColor.getPrimaryColor(),
            isLoading: controller.submitRegistrationLoading,
            text: MyStrings.register,
            onTap: () {
              MyUtils.clearAllTypeFocusNodes();
              if (formKey.currentState?.validate() ?? false) {
                controller.submitRegistration(
                  hasAcceptedPolicies: hasAcceptedPolicies,
                );
              }
            },
          ),
          spaceDown(Dimensions.space20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: MyTextStyle.sectionSubTitle1.copyWith(
                color: MyColor.getBodyTextColor(),
                fontSize: Dimensions.space15.sp,
              ),
              children: [
                TextSpan(
                  text: '${MyStrings.alreadyHaveAnAccount.tr} ',
                ),
                TextSpan(
                  text: MyStrings.login.tr,
                  style: MyTextStyle.sectionSubTitle1.copyWith(
                    color: MyColor.getPrimaryColor(),
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _goToLoginScreen();
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
