import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';
import 'package:ovopay/app/screens/choose_card/widget/customize_card_color_bottomsheet.dart';
import 'package:ovopay/core/utils/app_style.dart';
import 'package:ovopay/core/utils/my_strings.dart';
import 'package:ovopay/core/utils/text_style.dart';

import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../../../../core/utils/my_icons.dart';
import '../../../components/image/my_asset_widget.dart';
class VirtualCardSection extends StatelessWidget {
  const VirtualCardSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (controller) => SingleChildScrollView(
        child: Column(
          children: [
            spaceDown(Dimensions.space20.h),
            Container(
              height: context.height * .5,
              width: context.width * .7,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                  colors: controller.cards[controller.selectedCardColorIndex]
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: Text("OVOpay", style: MyTextStyle.sectionBodyBoldTextStyle.copyWith(color: MyColor.white, fontSize: 30),)),
                  ),
                  Spacer(),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: RotatedBox(
                          quarterTurns: 1,
                          child: MyAssetImageWidget(assetPath: MyIcons.visa, width: 76, height: 24, isSvg: true,))
                  ),
                ],
              ),
            ),

            spaceDown(Dimensions.space15.h),

            GestureDetector(
              onTap: () {
                CustomizeCardColorBottomSheet.customizeCardColorBottomSheet(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyAssetImageWidget(assetPath: MyIcons.colorCircle, width: 16, height: 16, isSvg: true),
                  spaceSide(Dimensions.space3.w),
                  Text(MyStrings.customizable.tr, style: MyTextStyle.bodyTextStyle1.copyWith(color: MyColor.black, fontSize: Dimensions.space15.sp),)
                ],
              ),
            ),
            spaceDown(Dimensions.space30.h),

            Text(MyStrings.virtualCard.tr, style: MyTextStyle.headerH3.copyWith(color: MyColor.black)),
            spaceDown(Dimensions.space4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(MyStrings.payContactlessOnlineStore.tr,style: MyTextStyle.bodyTextStyle1.copyWith(fontSize: 13.sp, color: MyColor.bodyText)),
                spaceSide(Dimensions.space4.w),
                MyAssetImageWidget(assetPath: MyIcons.network, isSvg: true, width: 16, height: 16, color: MyColor.bodyText,)
              ],
            )
          ],
        ),
      ),
    );
  }
}