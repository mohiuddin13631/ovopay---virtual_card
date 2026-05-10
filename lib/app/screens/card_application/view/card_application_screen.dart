import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';
import 'package:ovopay/app/screens/card_application/view/widget/new_user_section.dart';
import 'package:ovopay/app/screens/card_application/view/widget/physical_card_section.dart';
import 'package:ovopay/app/screens/choose_card/controller/create_new_card_controller.dart';
import 'package:ovopay/core/helper/string_format_helper.dart';
import 'package:ovopay/core/utils/my_strings.dart';

import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_icons.dart';
import '../../../../core/utils/my_images.dart';
import '../../../../core/utils/text_style.dart';
import '../../../components/buttons/custom_elevated_button.dart';
import '../../../components/image/my_asset_widget.dart';
class CardApplicationScreen extends StatefulWidget {

  final bool isPhysicalCard;

  const CardApplicationScreen({super.key, required this.isPhysicalCard});

  @override
  State<CardApplicationScreen> createState() => _CardApplicationScreenState();
}

class _CardApplicationScreenState extends State<CardApplicationScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateNewCardController>(
      builder: (controller) => MyCustomScaffold(
        pageTitle: MyStrings.cardApplications,
        body: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                height: 230,
                width: context.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  image: DecorationImage(image: AssetImage(Get.find<CardController>().selectedCardImage), fit: BoxFit.cover)
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(MyImages.appLogoWhite, width: context.height * .15)
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: MyAssetImageWidget(assetPath: MyIcons.visa, width: 76, height: 24, isSvg: true,)
                    ),
                  ],
                ),
              ),

              spaceDown(Dimensions.space24.h),

              // ExistingUserSection(),
              // spaceDown(Dimensions.space12.h),
              NewUserSection(),

              spaceDown(Dimensions.space12.h),

              PhysicalCardSection(isPhysicalCard: widget.isPhysicalCard),

              CustomAppCard(
                padding: EdgeInsetsGeometry.all(Dimensions.space16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(MyStrings.cardCreationFee.tr, style: MyTextStyle.caption1Style.copyWith(fontSize: 13.5.sp),)),
                        Text("${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.creationFee ?? "", forceShowPrecision: true)}", style: MyTextStyle.caption1Style.copyWith(fontSize: 13.5.sp),)
                      ],
                    ),
                    CustomDivider(space: Dimensions.space10.h),
                    Row(
                      children: [
                        Expanded(child: Text(MyStrings.initialDepositAmount.tr, style: MyTextStyle.caption1Style.copyWith(fontSize: 13.5.sp),)),
                        Text("${controller.currency}${controller.initialDepositController.text.isEmpty ? "0.00" : controller.initialDepositController.text}", style: MyTextStyle.caption1Style.copyWith(fontSize: 13.5.sp),)
                      ],
                    ),
                    CustomDivider(space: Dimensions.space10.h),
                    Row(
                      children: [
                        Expanded(child: Text(MyStrings.perTransactionFee.tr, style: MyTextStyle.caption1Style.copyWith(fontSize: 13.5.sp),)),
                        Text("${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.perOperationCharge ?? "")}", style: MyTextStyle.caption1Style.copyWith(fontSize: 13.5.sp),)
                      ],
                    ),
                    CustomDivider(space: Dimensions.space10.h),
                    Row(
                      children: [
                        Expanded(child: Text(MyStrings.total.tr, style: MyTextStyle.caption1Style.copyWith(fontSize: 13.5.sp),)),
                        Text("${controller.currency}${controller.getTotal()}", style: MyTextStyle.caption1Style.copyWith(fontSize: 13.5.sp),)
                      ],
                    ),

                  ],
                )
              ),

              spaceDown(Dimensions.space12.h),

              CustomAppCard(
                borderColor: MyColor.warning,
                borderWidth: 1,
                backgroundColor: MyColor.warning.withValues(alpha: .1),
                child: Column(
                  children: [
                    Row(
                      children: [
                        MyAssetImageWidget(assetPath: MyIcons.warning, width: 20, height: 20, isSvg: true),

                        spaceSide(Dimensions.space3.w),

                        Text(MyStrings.termsAndCondition.tr, style: MyTextStyle.sectionTitle3.copyWith(color:MyColor.headingText),)
                      ],
                    ),

                    spaceDown(Dimensions.space4),

                    Row(
                      children: [
                        SizedBox(height: 20, width: 25,),
                        Expanded(child: Text("By confirming, you agree to the card terms, fee schedule, and recurring monthly charges. All fees are non-refundable.", style: MyTextStyle.caption1Style.copyWith(color: MyColor.bodyText),))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16, vertical: Dimensions.space8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomElevatedBtn(
                  isLoading: controller.isSubmitLoading,
                  text: "${MyStrings.confirmAndPay.tr} - ${controller.currency}${controller.getTotal()}",
                  onTap: () {
                    // if(controller.selectedExistingCardHolder != null && controller.isExistingUser){
                    //   controller.createNewCardFromExistingUser(cardType: widget.isPhysicalCard ? "Physical" : "Virtual");
                    // }
                    // else if (controller.newCardFormKey.currentState!.validate() && !controller.isExistingUser) {
                    //   controller.createNewCard(cardType: widget.isPhysicalCard ? "Physical" : "Virtual");
                    // }

                      controller.createNewCard(cardType: widget.isPhysicalCard ? "Physical" : "Virtual");

                  },
                ),
                spaceDown(Dimensions.space8.h),
                Text(MyStrings.paymentWillBeDeductedFromYourMainAccountBalance.tr, style: MyTextStyle.caption1Style,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


