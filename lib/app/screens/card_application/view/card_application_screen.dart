import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/screens/card_application/view/widget/existing_user_section.dart';
import 'package:ovopay/app/screens/card_application/view/widget/new_user_section.dart';
import 'package:ovopay/core/utils/my_strings.dart';

import '../../../../core/route/route.dart';
import '../../../../core/utils/app_style.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_icons.dart';
import '../../../../core/utils/text_style.dart';
import '../../../components/buttons/custom_elevated_button.dart';
import '../../../components/image/my_asset_widget.dart';
import '../controller/card_application_controller.dart';
class CardApplicationScreen extends StatefulWidget {

  final bool isPhysicalCard;

  const CardApplicationScreen({super.key, required this.isPhysicalCard});

  @override
  State<CardApplicationScreen> createState() => _CardApplicationScreenState();
}

class _CardApplicationScreenState extends State<CardApplicationScreen> {

  @override
  void initState() {
    Get.put(CardApplicationController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardApplicationController>(
      builder: (controller) => MyCustomScaffold(
        pageTitle: MyStrings.cardApplications,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 230,
                width: context.width * .9,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors:   [
                      Color(0xff0D0B2A),
                      Color(0xff481928),
                      Color(0xffEA3E23),
                      Color(0xffF89E26),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("OVOpay", style: MyTextStyle.sectionBodyBoldTextStyle.copyWith(color: MyColor.white, fontSize: 30),),
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

              ExistingUserSection(),
              spaceDown(Dimensions.space12.h),
              NewUserSection(),

              spaceDown(Dimensions.space12.h),

              Visibility(
                visible: widget.isPhysicalCard,
                child: CustomAppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(MyStrings.shippingMethod.tr, style: MyTextStyle.caption1Style.copyWith(color: MyColor.headingText)),

                      spaceDown(13.sp),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(controller.shippingMethodList.length, (index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.changeShippingMethod(index);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: MyColor.transparentColor,
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(width: controller.selectedShippingMethod == index ? 6 : 1.5, color: controller.selectedShippingMethod == index ? MyColor.primary : MyColor.unselectedColor)
                                      ),
                                    ),
                                    spaceSide(6.w,),
                                    Text(controller.shippingMethodList[index].tr, style: MyTextStyle.sectionTitle2.copyWith(color: MyColor.headingText))
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: index == 0,
                                child: CustomDivider(space: 16,)
                              )
                            ],
                          );
                        },),
                      )
                    ],
                  )
                ),
              ),

              spaceDown(Dimensions.space12.h),

              Visibility(
                visible: widget.isPhysicalCard,
                child: CustomAppCard(
                  onPressed: () {
                    Get.toNamed(RouteHelper.shippingAddressScreen);
                  },child: Row(
                      children: [
                        Expanded(child: Text(MyStrings.shippingAddress.tr, style: MyTextStyle.sectionTitle2.copyWith(color: MyColor.headingText))),

                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1.5, color: MyColor.dark),
                          ),
                          child: Icon(Icons.add, color: MyColor.dark, size: 15,),
                        )
                      ],
                    )
                ),
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
                  text: "${MyStrings.confirmAndPay.tr} - \$10.00 USD",
                  onTap: () {
                    Get.toNamed(RouteHelper.cardApplicationScreen);
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


