import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/app_style.dart';
import 'package:ovopay/core/utils/dimensions.dart';
import 'package:ovopay/core/utils/my_strings.dart';
import 'package:ovopay/core/utils/text_style.dart';

import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/util.dart';
import '../../../components/text-field/rounded_text_field.dart';
import '../../../components/text/header_text.dart';
class EnterAmountScreen extends StatefulWidget {
  const EnterAmountScreen({super.key});

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      pageTitle: MyStrings.enterAmount.tr,
      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppCard(
                      radius: Dimensions.space12,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(MyStrings.topUpMethod.tr, style: MyTextStyle.caption1Style),
                              spaceDown(Dimensions.space2.h),
                              Text(MyStrings.mainAccountBalance.tr, style: MyTextStyle.sectionTitle3)
                            ],
                          )
                        ],
                      )
                  ),
              
                  spaceDown(Dimensions.space16.h),
              
                  CustomAppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderText(
                            text: MyStrings.enterAmount.tr,
                            textStyle: MyTextStyle.sectionTitle.copyWith(
                              color: MyColor.getHeaderTextColor(),
                            ),
                          ),
                          spaceDown(Dimensions.space24.h),
              
                          RoundedTextField(
                            contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.space20, vertical: Dimensions.space18),
                            showLabelText: false,
                            labelText: MyStrings.enterAmount.tr,
                            hintText: MyStrings.enterAmount,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textStyle: MyTextStyle.headerH3.copyWith(
                              color: MyColor.getHeaderTextColor(),
                            ),
                            focusBorderColor: MyColor.getPrimaryColor(),
                            textInputFormatter: [
                              // Limits decimal places (optional, adjust as needed)
                            ],
                            onChanged: (value) {
              
                            },
                            validator: (value) {
              
                            },
                          ),
              
                          spaceDown(Dimensions.space8),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${MyStrings.availableBalance.tr}: ",
                                  style: MyTextStyle.sectionBodyTextStyle.copyWith(
                                    color: MyColor.getBodyTextColor(),
                                  ),
                                ),
                                TextSpan(
                                  text: MyUtils.getUserAmount(
                                      "04154"
                                  ),
                                  style: MyTextStyle.sectionBodyBoldTextStyle.copyWith(color: MyColor.getPrimaryColor()),
                                ),
                              ],
                            ),
                          ),
              
                          spaceDown(Dimensions.space24.h),
              
                          Wrap(
                              runSpacing: Dimensions.space8.h,
                              spacing: Dimensions.space8.w,
                              children: List.generate(5, (index) {
              
                                return GestureDetector(
                                  onTap: () {
              
                                  },
                                  child: CustomAppCard(
                                    radius: Dimensions.largeRadius,
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.space18, vertical: Dimensions.space14),
                                    backgroundColor: MyColor.getWhiteColor(),
                                    borderColor: MyColor.getBorderColor(),
                                    child: Text("500", style: MyTextStyle.caption1Style.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.space15.sp)),
                                  ),
                                );
                              })),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),

          CustomElevatedBtn(
            bgColor: MyColor.transparentColor,
            borderColor: MyColor.primary,
            textColor: MyColor.black,
            text: MyStrings.next, onTap: () {Get.toNamed(RouteHelper.confirmTopUpScreen);},)
        ],
      )
    );
  }
}
