import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/core/utils/app_style.dart';
import 'package:ovopay/core/utils/dimensions.dart';
import 'package:ovopay/core/utils/my_icons.dart';
import 'package:ovopay/core/utils/util_exporter.dart';
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            spaceDown(Dimensions.space16.h),

            MyAssetImageWidget(assetPath: MyIcons.check, isSvg: true, width: 100, height: 100),
            spaceDown(Dimensions.space4.h),

            Text("Top-Up Successful!", style: MyTextStyle.sectionTitle.copyWith(fontSize: Dimensions.space22.sp)),
            spaceDown(Dimensions.space4),
            Text("Your card has been topped  up with \$100.00 ", style: MyTextStyle.caption1Style.copyWith(fontSize: 13.sp)),
            
            spaceDown(Dimensions.space16.h),
            
            CustomAppCard(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Setup & Monthly Fees", style: MyTextStyle.caption1Style.copyWith(fontSize: 13.sp)),
                  spaceDown(Dimensions.space8.h),

                  RowItem(
                    title: MyStrings.transactionId.tr,
                    subtitle: "TXN7011201746",
                  ),

                  RowItem(
                    title: "Date & Time",
                    subtitle: "Dec 29, 2025, 06:26 PM",
                  ),

                  RowItem(
                    title: "Method",
                    subtitle: "Crypto Deposit",
                  ),

                  RowItem(
                    title: "Amount Added",
                    subtitle: "\$100",
                  ),

                  RowItem(
                    title: "Processing Fee",
                    subtitle: "\$100",
                  ),

                  RowItem(
                    isShowDivider: false,
                    title: MyStrings.status,
                    subtitle: "Completed",
                  ),

                ],
              )
            ),

            spaceDown(Dimensions.space16.h),

            Row(
              children: [
                CustomAppCard(
                  radius: 12,
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.space16),
                  padding: EdgeInsets.symmetric(horizontal: 38, vertical: Dimensions.space16),
                  child: Row(
                    children: [
                      MyAssetImageWidget(assetPath: MyIcons.download, isSvg: true, width: 24, height: 24, radius: 12),
                      spaceSide(6),
                      Text("Receipt", style: MyTextStyle.sectionTitle.copyWith(fontWeight: FontWeight.w500, color: MyColor.black))
                    ],
                  )
                ),
                CustomAppCard(
                  radius: 12,
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.space16),
                  padding: EdgeInsets.symmetric(horizontal: 38, vertical: Dimensions.space16),
                  child: Row(
                    children: [
                      MyAssetImageWidget(assetPath: MyIcons.share, isSvg: true, width: 24, height: 24, radius: 12),
                      spaceSide(6),
                      Text("Share", style: MyTextStyle.sectionTitle.copyWith(fontWeight: FontWeight.w500, color: MyColor.black))
                    ],
                  )
                ),
              ],
            )
            
          ],
        ),
      )),
    );
  }
}

class RowItem extends StatelessWidget {

  final String title;
  final String subtitle;
  final bool isShowDivider;

  const RowItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.isShowDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title.tr, style: MyTextStyle.sectionBodyTextStyle.copyWith(color: MyColor.headingText, fontSize: Dimensions.space15.sp)),
            Text(subtitle.tr,style: MyTextStyle.sectionBodyTextStyle.copyWith(color: MyColor.headingText))
          ],
        ),
        Visibility(
            visible: isShowDivider,
            child: CustomDivider(space: Dimensions.space12)),
      ],
    );
  }
}
