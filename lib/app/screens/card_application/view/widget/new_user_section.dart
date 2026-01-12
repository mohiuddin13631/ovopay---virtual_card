import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/screens/card_application/controller/card_application_controller.dart';
import 'package:ovopay/core/utils/my_strings.dart';

import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../components/text-field/rounded_text_field.dart';

class NewUserSection extends StatelessWidget {
  const NewUserSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardApplicationController>(
      builder: (controller) => CustomAppCard(
          padding: EdgeInsetsGeometry.all(Dimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                        color: MyColor.transparentColor,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(width: 2, color: MyColor.unselectedColor)
                    ),
                  ),
                  spaceSide(6.w,),
                  Text(MyStrings.existingUserInformation.tr, style: MyTextStyle.sectionTitle2.copyWith(color: MyColor.headingText))
                ],

              ),

              CustomDivider(space: 16,),

              RoundedTextField(
                labelText: MyStrings.fullName.tr,
                hintText: MyStrings.enterYourName.tr,
                controller: controller.fullNameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return MyStrings.kNameNullError.tr;
                  } else {
                    return null;
                  }
                },
              ),

              spaceDown(Dimensions.space25),

              RoundedTextField(
                labelText: MyStrings.cardName.tr,
                hintText: MyStrings.enterNameOnCard.tr,
                controller: controller.carNameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return MyStrings.enterNameOnCard.tr;
                  } else {
                    return null;
                  }
                },
              ),

              spaceDown(Dimensions.space25),

              RoundedTextField(
                labelText: MyStrings.billingAddress.tr,
                hintText: MyStrings.enterYourAddress.tr,
                controller: controller.billingAddressController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return MyStrings.enterYourAddress.tr;
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
      ),
    );
  }
}