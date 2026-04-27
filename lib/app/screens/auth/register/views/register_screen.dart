import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ovopay/app/components/annotated_region/annotated_region_widget.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/image/my_network_image_widget.dart';
import 'package:ovopay/app/components/otp_field_widget/otp_field_widget.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/components/will_pop_widget.dart';
import 'package:ovopay/app/screens/auth/register/controller/registration_controller.dart';
import 'package:ovopay/core/data/models/user/user_model.dart';
import 'package:ovopay/core/data/repositories/auth/signup_repo.dart';
import 'package:ovopay/core/data/services/shared_pref_service.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/util_exporter.dart';
import 'package:ovopay/environment.dart';

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
      child: AnnotatedRegionWidget(
        statusBarBrightness: MyUtils.getOppositeBrightness(
          MyColor.getPrimaryColor(),
        ),
        statusBarIconBrightness: MyUtils.getOppositeBrightness(
          MyColor.getPrimaryColor(),
        ),
        systemNavigationBarIconBrightness: MyUtils.getOppositeBrightness(
          MyColor.getPrimaryColor(),
        ),
        statusBarColor: MyColor.getPrimaryColor(),
        systemNavigationBarColor: MyColor.getPrimaryColor(),
        child: Scaffold(
          backgroundColor: MyColor.white,
          body: GetBuilder<RegistrationController>(
            builder: (controller) => PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (widget.userModel?.sv == "0") ...[
                  _buildOtpCodeVerificationPage(controller),
                ],
                _buildRegisterFormPage(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpCodeVerificationPage(RegistrationController controller) {
    TextSpan buildTimerText(RegistrationController controller) {
      int minutes = controller.time ~/ 60;
      int seconds = controller.time % 60;
      String timeText =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      return TextSpan(text: timeText, style: MyTextStyle.sectionSubTitle1);
    }

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(context),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: Dimensions.space16.sp,
            ),
            child: Column(
              children: [
                spaceDown(Dimensions.space30),
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
                          text:
                              "${MyStrings.weHaveSentACodeTo.tr} +${widget.userModel?.dialCode}${widget.userModel?.mobile?.toNumberMask(unmaskedPrefix: 2, unmaskedSuffix: 2, maskChar: "Ã¢â‚¬Â¢")}",
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
                    text:
                        "${controller.isOtpExpired == false ? MyStrings.waitUtilTheTimerFinishes.tr : MyStrings.didNotReceiveCode.tr} ",
                    style: MyTextStyle.sectionSubTitle1,
                    children: <TextSpan>[
                      if (controller.isOtpExpired == false) ...[
                        buildTimerText(controller),
                      ] else ...[
                        TextSpan(
                          text: controller.resendLoading
                              ? "${MyStrings.resending.tr}..."
                              : MyStrings.resendCode.tr,
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
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterFormPage(RegistrationController controller) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(context),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: Dimensions.space16.sp,
            ),
            child: Column(
              children: [
                spaceDown(Dimensions.space30),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              if (email.isEmpty ||
                                  !GetUtils.isEmail(email)) {
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

                              if (controller.pinController.text !=
                                  controller.cPinController.text) {
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
                spaceDown(Dimensions.space20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColor.getPrimaryColor(),
      ),
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: Dimensions.space15.sp,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: MediaQuery.viewPaddingOf(context).top,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spaceDown(Dimensions.space20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyAssetImageWidget(
                  assetPath: MyImages.appLogoWhite,
                  boxFit: BoxFit.contain,
                  width: (Dimensions.space100 + Dimensions.space50).sp,
                  height: null,
                ),
                Visibility(
                  visible:
                      SharedPreferenceService.isSupportMultiLanguage(),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.languageScreen);
                      },
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: Dimensions.space8.w,
                          vertical: Dimensions.space4.w,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MyColor.getBorderColor()
                                .withValues(alpha: 0.5),
                            width: Dimensions.space2.w,
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimensions.cardRadius,
                          ),
                        ),
                        child: Row(
                          children: [
                            if (SharedPreferenceService.getString(
                                  SharedPreferenceService.languageImagePath,
                                  defaultValue: "",
                                ) ==
                                "")
                              Icon(
                                Icons.g_translate,
                                size: 16.h,
                                color: MyColor.getWhiteColor(),
                              )
                            else
                              MyNetworkImageWidget(
                                imageUrl: SharedPreferenceService.getString(
                                  SharedPreferenceService.languageImagePath,
                                  defaultValue: '',
                                ),
                                width: 16.w,
                                height: 16.h,
                              ),
                            spaceSide(Dimensions.space5),
                            Text(
                              SharedPreferenceService.getString(
                                SharedPreferenceService.languageCode,
                                defaultValue:
                                    Environment.defaultLangCode.toUpperCase(),
                              ).toUpperCase(),
                              style: MyTextStyle.sectionSubTitle1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: MyColor.getWhiteColor(),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: MyColor.getWhiteColor(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            spaceDown(Dimensions.space30),
            Text(
              MyStrings.createYourAccount.tr,
              style: MyTextStyle.headerH1,
            ),
            const SizedBox(height: Dimensions.space8),
            Text(
              MyStrings.registerSubTitle.tr,
              style: MyTextStyle.bodyTextStyle1.copyWith(
                color: MyColor.getWhiteColor(),
              ),
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
