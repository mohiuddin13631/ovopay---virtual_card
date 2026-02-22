import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/screens/dashboard_screen/controller/home_controller.dart';
import 'package:ovopay/core/data/repositories/top_up/top_up_repo.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/app_style.dart';
import 'package:ovopay/core/utils/dimensions.dart';
import 'package:ovopay/core/utils/my_color.dart';
import 'package:ovopay/core/utils/my_icons.dart';
import 'package:ovopay/core/utils/my_strings.dart';
import 'package:ovopay/core/utils/text_style.dart';

import '../../../../core/helper/string_format_helper.dart';
import '../controller/topup_controller.dart';

class TopUpCardScreen extends StatefulWidget {

  final String id;

  const TopUpCardScreen({super.key, required this.id});

  @override
  State<TopUpCardScreen> createState() => _TopUpCardScreenState();
}

class _TopUpCardScreenState extends State<TopUpCardScreen> {

  @override
  void initState() {

    super.initState();

    Get.put(TopUpRepo());
    var controller = Get.put(TopUpController(topUpRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        controller.loadData(widget.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopUpController>(
      builder: (controller) => MyCustomScaffold(
        pageTitle: MyStrings.topUpCard.tr,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spaceDown(Dimensions.space16.h),

              Container(
                padding: EdgeInsets.all(Dimensions.space24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.space20.r),
                  gradient: LinearGradient(
                      colors: [
                        MyColor.getPrimaryColor(),
                        Color(0xff193488)
                      ]
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(MyStrings.mainAccountBalance.tr, style: MyTextStyle.caption1Style.copyWith(fontSize: Dimensions.space14.sp, color: MyColor.white)),
                    spaceDown(Dimensions.space4.h),
                    Text("${controller.currency}${AppConverter.formatNumber(Get.find<HomeController>().accountBalanceFormatted, forceShowPrecision: true)}", style: MyTextStyle.sectionTitle.copyWith(color: MyColor.white, fontSize: 26.sp)),
                    spaceDown(Dimensions.space16.h),
                    Row(
                      children: [
                        MyAssetImageWidget(assetPath: MyIcons.security, isSvg: true, width: 16, height: 16),
                        spaceSide(Dimensions.space4),
                        Text(MyStrings.availableForInstantTransfer, style: MyTextStyle.caption1Style.copyWith(fontSize: 13.sp, color: MyColor.white))
                      ],
                    ),
                  ],
                ),
              ),

              spaceDown(Dimensions.space40.h),

              Text(MyStrings.chooseHowYouWantToUpYourCard.tr, style: MyTextStyle.sectionTitle3,),

              spaceDown(Dimensions.space12.h),

              CustomAppCard(
                onPressed: () {
                  Get.toNamed(RouteHelper.enterAmountScreen, arguments: TopUpInfo(topUpMethod: MyStrings.fromMainBalance));
                },
                padding: EdgeInsetsGeometry.all(Dimensions.space8),
                radius: 12,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsetsGeometry.all(Dimensions.space14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.space8),
                        gradient: LinearGradient(
                            begin: AlignmentGeometry.topLeft,
                            end: AlignmentGeometry.bottomRight,
                            colors: [
                              Color(0xff193488),
                              MyColor.getPrimaryColor(),
                            ]
                        ),
                      ),
                      child: MyAssetImageWidget(assetPath: MyIcons.wallet, width: 56, height: 56, isSvg: true),
                    ),

                    spaceSide(Dimensions.space8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(MyStrings.fromMainBalance.tr, style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.black, fontSize: Dimensions.space16.sp)),

                              spaceSide(6),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.space8),
                                  color: MyColor.success.withValues(alpha: .1),
                                ),
                                child: Text(MyStrings.instant, style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.success, fontSize: 11.sp),),
                              )
                            ],
                          ),
                          spaceDown(Dimensions.space4.h),
                          Text(MyStrings.transferFromYourAccountBalance.tr, style: MyTextStyle.caption1Style.copyWith(color: MyColor.bodyText))
                        ],
                      ),
                    )
                  ],
                ),
              ),

              spaceDown(Dimensions.space12.h),

              CustomAppCard(
                onPressed: () {
                  Get.toNamed(RouteHelper.enterAmountScreen, arguments: TopUpInfo(topUpMethod: MyStrings.fromCryptoBalance));
                },
                padding: EdgeInsetsGeometry.all(Dimensions.space8),
                radius: 12,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsetsGeometry.all(Dimensions.space14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.space8),
                        gradient: LinearGradient(
                            begin: AlignmentGeometry.topLeft,
                            end: AlignmentGeometry.bottomRight,
                            colors: [
                              Color(0xffA435FF),
                              Color(0xff622099),
                            ]
                        ),
                      ),
                      child: MyAssetImageWidget(assetPath: MyIcons.bitCoin, width: 56, height: 56, isSvg: true),
                    ),

                    spaceSide(Dimensions.space8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(MyStrings.cryptoDeposit.tr, style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.black, fontSize: Dimensions.space16.sp)),
                              spaceSide(6),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.space8),
                                  color: MyColor.success.withValues(alpha: .1),
                                ),
                                child: Text(MyStrings.direct, style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.success, fontSize: 11.sp),),
                              )
                            ],
                          ),
                          spaceDown(Dimensions.space4.h),
                          Text("${MyStrings.processingFee.tr}: ${controller.chargeSettingForWallet?.topupChargeFromCrypto ?? ""}%", style: MyTextStyle.caption1Style.copyWith(color: MyColor.bodyText))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAppCard(
                margin: EdgeInsets.symmetric(horizontal: Dimensions.space16),
                borderColor: MyColor.warning,
                borderWidth: 1,
                backgroundColor: MyColor.warning.withValues(alpha: .1),
                child: Column(
                  children: [
                    Row(
                      children: [
                        MyAssetImageWidget(assetPath: MyIcons.warning, width: 20, height: 20, isSvg: true),

                        spaceSide(Dimensions.space3.w),

                        Text(MyStrings.processingTime.tr, style: MyTextStyle.sectionTitle3.copyWith(color:MyColor.headingText),)
                      ],
                    ),

                    spaceDown(Dimensions.space4),

                    Row(
                      children: [
                        SizedBox(height: 20, width: 25),
                        Expanded(child: Text(MyStrings.balanceTermsAndConditions.tr, style: MyTextStyle.caption1Style.copyWith(color: MyColor.bodyText),))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
