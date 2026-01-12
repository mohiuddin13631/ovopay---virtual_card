import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';

import '../../../../../core/utils/util_exporter.dart';
import 'freeze_card_bottom_sheet.dart';

class TerminateCardBottomSheet {
  static void terminateCardBottomSheet(BuildContext context) {// Load country data

    CustomBottomSheetPlus(
      isNeedAnimatedPadding: false,
      isNeedPadding: false,
      child: SafeArea(
        child: Builder(
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Container(
                  height: MediaQuery.of(context).size.height * .87,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.getWhiteColor(),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.space16, vertical: Dimensions.space12),
                        decoration: BoxDecoration(
                          color: MyColor.naturalLight.withValues(alpha: .2),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(MyStrings.terminateCard.tr, style: MyTextStyle.sectionTitle3,),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Icons.cancel_outlined, size: 26, color: MyColor.naturalLight)
                            ),

                          ],
                        ),
                      ),

                      spaceDown(Dimensions.space16.h),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsetsGeometry.all(11),
                                decoration: BoxDecoration(
                                  color: MyColor.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: MyAssetImageWidget(assetPath: MyIcons.lock, isSvg: true, color: MyColor.white, width: 17, height: 17,),
                              ),

                              spaceDown(Dimensions.space8.h),

                              Text("Are you sure you want to freeze this card? All transactions will be temporarily blocked.", style: MyTextStyle.sectionSubTitle1.copyWith(color: MyColor.bodyText),textAlign: TextAlign.center),
                              spaceDown(Dimensions.space15.h),

                              CustomAppCard(
                                  padding: EdgeInsetsGeometry.all(Dimensions.space15),
                                  radius: 12,
                                  borderColor: MyColor.warning,
                                  borderWidth: 1,
                                  backgroundColor: MyColor.warning.withValues(alpha: .1),
                                  child: Column(
                                    children: [
                                      Text(MyStrings.afterFreezing.tr, style: MyTextStyle.sectionSubTitle1.copyWith(color: MyColor.black)),
                                      spaceDown(Dimensions.space12.h),
                                      RowItem(
                                        title: "All transections will be blocked",
                                        icon: MyIcons.warning,
                                      ),
                                      RowItem(
                                        title: "All transections will be blocked",
                                        icon: MyIcons.warning,
                                      ),
                                      RowItem(
                                        title: "All transections will be blocked",
                                        icon: MyIcons.warning,
                                      ),
                                      RowItem(
                                        title: "All transections will be blocked",
                                        icon: MyIcons.checkOutline,
                                        isShowSpace: false,
                                        iconColor: MyColor.success,
                                      ),
                                    ],
                                  )
                              ),

                              spaceDown(Dimensions.space24.h),

                              Text(MyStrings.reasonForFreezing.tr, style: MyTextStyle.caption1Style.copyWith(fontSize: Dimensions.space16.sp)),

                              spaceDown(Dimensions.space18.h),

                              Container(
                                padding: EdgeInsetsGeometry.all(Dimensions.space16),
                                decoration: BoxDecoration(
                                  color: MyColor.lightGrey,
                                  borderRadius: BorderRadius.circular(Dimensions.space12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(MyStrings.selectReason.tr, style: MyTextStyle.sectionTitle2.copyWith(fontWeight: FontWeight.w500, color: MyColor.black)),
                                    Icon(Icons.arrow_drop_down, size: 24, color: MyColor.bodyText,)
                                  ],
                                ),
                              ),

                              spaceDown(Dimensions.space16.h),

                              CustomAppCard(
                                borderColor: MyColor.primary,
                                borderWidth: 1,
                                backgroundColor: MyColor.primary.withValues(alpha: .1),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline, color: MyColor.primary, size: 20,),

                                        spaceSide(Dimensions.space3.w),

                                        Text(MyStrings.importantInformation.tr, style: MyTextStyle.sectionTitle3.copyWith(color:MyColor.headingText),)
                                      ],
                                    ),

                                    spaceDown(Dimensions.space4),

                                    Row(
                                      children: [
                                        SizedBox(height: 20, width: 25,),
                                        Expanded(child: Text("You can unfreeze your card instantly at any time. Your balance and card details remain unchanged.", style: MyTextStyle.caption1Style.copyWith(color: MyColor.bodyText),))
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              spaceDown(Dimensions.space24.h),

                              CustomElevatedBtn(text: MyStrings.freezeCard, onTap: () {})
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    ).show(context);
  }
}
