import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/screens/choose_card/controller/create_new_card_controller.dart';
import 'package:ovopay/core/data/models/card/topup_wallet_response_model.dart';
import 'package:ovopay/core/utils/my_strings.dart';

import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../components/drop_down/my_drop_down_widget.dart';
import '../../../../components/text-field/rounded_text_field.dart';

class ExistingUserSection extends StatelessWidget {
  const ExistingUserSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateNewCardController>(
      builder: (controller) => CustomAppCard(
          onPressed: () {
            controller.updateUserInformation(true);
          },
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
                        border: Border.all(width: controller.isExistingUser ? 6: 2, color: controller.isExistingUser ? MyColor.primary : MyColor.unselectedColor)
                    ),
                  ),
                  spaceSide(6.w,),
                  Text(MyStrings.existingUserInformation.tr, style: MyTextStyle.sectionTitle2.copyWith(color: MyColor.headingText))
                ],
              ),

              CustomDivider(space: 16,),

              AppDropdownWidget(
                items: controller.existingCardHoldersList.map((e) => e.customerEmail).toList(),
                onItemSelected: (String? value) {
                  controller.setExistingUser(value);
                },
                selectedItem: controller.selectedExistingCardHolderEmail,
                child: RoundedTextField(
                  readOnly: true,
                  labelText: MyStrings.chooseCardHolder.tr,
                  hintText: MyStrings.chooseCardHolder.tr,
                  controller: TextEditingController(
                    text: controller.selectedExistingCardHolderEmail ?? "",
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  onTap: () {},
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: MyColor.getDarkColor(),
                  ),
                ),
              ),

              // Text(MyStrings.fullName.tr, style: MyTextStyle.caption1Style,),
              // Text("${controller.user?.firstname ?? ""} ${controller.user?.lastname ?? ""}", style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.dark, fontWeight: FontWeight.w400)),
              //
              // spaceDown(Dimensions.space12.h),
              //
              // Text(MyStrings.email.tr, style: MyTextStyle.caption1Style,),
              // Text(controller.user?.email ?? "", style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.dark, fontWeight: FontWeight.w400)),
              //
              // spaceDown(Dimensions.space12.h),
              //
              // Text(MyStrings.billingAddress.tr, style: MyTextStyle.caption1Style,),
              // Text("${controller.user?.address ?? ""} ${controller.user?.city ?? ""} ${controller.user?.zip ?? ""} ${controller.user?.countryName ?? ""}", style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.dark, fontWeight: FontWeight.w400)),

            ],
          )
      ),
    );
  }
}