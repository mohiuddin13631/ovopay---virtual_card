import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/core/utils/my_strings.dart';

import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/text_style.dart';

class ExistingUserSection extends StatelessWidget {
  const ExistingUserSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppCard(
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
                      border: Border.all(width: 6, color: MyColor.primary)
                  ),
                ),
                spaceSide(6.w,),
                Text(MyStrings.existingUserInformation.tr, style: MyTextStyle.sectionTitle2.copyWith(color: MyColor.headingText))
              ],
            ),

            CustomDivider(space: 16,),

            Text(MyStrings.fullName, style: MyTextStyle.caption1Style,),
            Text("Jacob Jones", style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.dark, fontWeight: FontWeight.w400)),

            spaceDown(Dimensions.space12.h),

            Text(MyStrings.cardName, style: MyTextStyle.caption1Style,),
            Text("Jacob Jones", style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.dark, fontWeight: FontWeight.w400)),

            spaceDown(Dimensions.space12.h),

            Text(MyStrings.billingAddress, style: MyTextStyle.caption1Style,),
            Text("1024/1 Ibrahimpur Eidgah Road, Dhaka 1206 Bangladesh ", style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.dark, fontWeight: FontWeight.w400)),


          ],
        )
    );
  }
}