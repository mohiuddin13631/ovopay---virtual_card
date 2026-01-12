import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/route/route.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/my_icons.dart';
import '../../../../../core/utils/my_strings.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../components/image/my_asset_widget.dart';
import '../../../../components/snack_bar/show_custom_snackbar.dart';
class CardUi extends StatelessWidget {

  final List<Color> color;
  final double cardHeight;
  final VoidCallback? onTap;

  const CardUi({super.key, required this.color, this.cardHeight = 344, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: color,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyAssetImageWidget(assetPath: MyIcons.network, isSvg: true, width: 18, height: 24),
                  MyAssetImageWidget(assetPath: MyIcons.visa, width: 76, height: 24, isSvg: true,)

                ],
              ),
            ),
            Spacer(),
            Text("Balance", style: TextStyle(color: Colors.white70)),
            SizedBox(height: 2),
            Text(
              "\$2,685.00",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "3455 4562 7710 3507",
                  style: MyTextStyle.sectionTitle.copyWith(color: MyColor.white, fontSize: 18.sp),
                ),
                spaceSide(Dimensions.space8.w),
                GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: ""),
                      ).then((_) {
                        CustomSnackBar.showToast(
                          message: MyStrings.copiedToClipBoard.tr,
                        );
                      });
                    },
                    child: MyAssetImageWidget(assetPath: MyIcons.copy, isSvg: true, width: 24, height: 24,)
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyStrings.cardName.tr, style: MyTextStyle.bodyTextStyle1.copyWith(color: MyColor.white, fontSize: 9.sp,)),
                      Text("Jacob Jones", style: MyTextStyle.caption2Style.copyWith(color: MyColor.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                spaceSide(Dimensions.space24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyStrings.expirationDate.tr, style: MyTextStyle.bodyTextStyle1.copyWith(color: MyColor.white, fontSize: 9.sp,)),
                      Text("••/••", style: MyTextStyle.caption2Style.copyWith(color: MyColor.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                spaceSide(Dimensions.space24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyStrings.cvv.tr, style: MyTextStyle.bodyTextStyle1.copyWith(color: MyColor.white, fontSize: 9.sp,)),
                      Text("•••", style: MyTextStyle.caption2Style.copyWith(color: MyColor.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),

                MyAssetImageWidget(assetPath: MyIcons.chip, width: 43, height: 33, isSvg: true,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
