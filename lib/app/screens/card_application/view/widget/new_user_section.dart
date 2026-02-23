import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/screens/choose_card/controller/create_new_card_controller.dart';
import 'package:ovopay/core/data/services/service_exporter.dart';
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
    return GetBuilder<CreateNewCardController>(
      builder: (controller) => CustomAppCard(
          onPressed: () {
            controller.updateUserInformation(false);
          },
          padding: EdgeInsetsGeometry.all(Dimensions.space16),
          child: Form(
            key: controller.newCardFormKey,
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
                          border: Border.all(width: !controller.isExistingUser ? 6: 2, color: !controller.isExistingUser ? MyColor.primary : MyColor.unselectedColor)
                      ),
                    ),
                    spaceSide(6.w),
                    Text(MyStrings.newCardInformation.tr, style: MyTextStyle.sectionTitle2.copyWith(color: MyColor.headingText))
                  ],
                ),

                CustomDivider(space: 16,),

                RoundedTextField(
                  readOnly: controller.isExistingUser,
                  labelText: MyStrings.cardName.tr,
                  hintText: MyStrings.enterNameOnCard.tr,
                  controller: controller.carNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
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
                  readOnly: controller.isExistingUser,
                  labelText: MyStrings.email.tr,
                  hintText: MyStrings.enterYourEmail.tr,
                  controller: controller.emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.enterYourEmail.tr;
                    } else {
                      return null;
                    }
                  },
                ),

                spaceDown(Dimensions.space25),

                RoundedTextField(
                  labelText: MyStrings.initialDepositAmount.tr,
                  hintText: "${SharedPreferenceService.getCurrencySymbol()}0.00",
                  controller: controller.initialDepositController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    controller.getTotal();
                    controller.update();
                  },
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.initialDepositAmount.tr;
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }
}