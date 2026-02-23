import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/screens/card_charges_fees/controller/charges_and_fees_controller.dart';
import 'package:ovopay/app/screens/card_charges_fees/view/widget/charges_card.dart';
import 'package:ovopay/core/data/repositories/card/card_repo.dart';
import 'package:ovopay/core/helper/string_format_helper.dart';
import 'package:ovopay/core/utils/app_style.dart';
import 'package:ovopay/core/utils/dimensions.dart';
import 'package:ovopay/core/utils/my_strings.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardChargesAndFeesScreen extends StatefulWidget {
  const CardChargesAndFeesScreen({super.key});

  @override
  State<CardChargesAndFeesScreen> createState() => _CardChargesAndFeesScreenState();
}

class _CardChargesAndFeesScreenState extends State<CardChargesAndFeesScreen> {

  @override
  void initState() {

    super.initState();

    Get.put(CardRepo());
    var controller = Get.put(ChargesAndFeesController(cardRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        controller.loadChargeSetting();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChargesAndFeesController>(
      builder: (controller) => MyCustomScaffold(
        pageTitle: MyStrings.cardChargesAndFees,
        body: Skeletonizer(
          enabled: controller.isLoading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                spaceDown(Dimensions.space12.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: EdgeInsets.only(bottom: Dimensions.space12.h),
                      child: CustomAppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              ChargesCard(
                                  title: "${MyStrings.cardCreationCharge}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.creationFee ?? "",  forceShowPrecision: true)}"
                              ),
                              ChargesCard(
                                  title: "${MyStrings.monthlyMaintenanceCharge}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.monthlyFee ?? "", forceShowPrecision: true)}"
                              ),

                              ChargesCard(
                                  isShowDivider: false,
                                  title: "${MyStrings.maximumCardLimit}: ",
                                  value: controller.chargeSetting?.maximumCardGenerate ?? ""
                              )

                            ],
                          )
                      ),
                    ),

                    spaceDown(Dimensions.space10.h),
                    Container(
                      padding: EdgeInsets.only(bottom: Dimensions.space12.h),
                      child: CustomAppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              ChargesCard(
                                  title: "${MyStrings.topUpChargeFromWallet}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.topupChargeFromWallet ?? "",  forceShowPrecision: true)}"
                              ),
                              ChargesCard(
                                  title: "${MyStrings.topUpChargeFromCrypto}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.topupChargeFromCrypto ?? "", forceShowPrecision: true)}"
                              ),

                              ChargesCard(
                                  title: "${MyStrings.minimumTopUpLimit}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.cardTopupMinLimit ?? "", forceShowPrecision: true)}"
                              ),

                              ChargesCard(
                                  isShowDivider: false,
                                  title: "${MyStrings.maximumTopUpLimit}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.cardTopupMaxLimit ?? "", forceShowPrecision: true)}"
                              ),

                            ],
                          )
                      ),
                    ),

                    spaceDown(Dimensions.space10.h),
                    Container(
                      padding: EdgeInsets.only(bottom: Dimensions.space12.h),
                      child: CustomAppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              ChargesCard(
                                title: "${MyStrings.walletRequiredAmount}: ",
                                value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.walletRequiredBalance ?? "",  forceShowPrecision: true)}"
                              ),

                              ChargesCard(
                                title: "${MyStrings.crossBorderTransactionCharge}: ",
                                value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.crossBorderTransactionCharge ?? "", forceShowPrecision: true)}"
                              ),

                              ChargesCard(
                                isShowDivider: false,
                                title: "${MyStrings.perOperationCharge}: ",
                                value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.perOperationCharge ?? "", forceShowPrecision: true)}"
                              ),

                            ],
                          )
                      ),
                    ),

                    spaceDown(Dimensions.space10.h),
                    Container(
                      padding: EdgeInsets.only(bottom: Dimensions.space12.h),
                      child: CustomAppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              ChargesCard(
                                  title: "${MyStrings.withdrawCharge}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.cardWithdrawCharge ?? "",  forceShowPrecision: true)}"
                              ),
                              ChargesCard(
                                  title: "${MyStrings.withdrawMinimumLimit}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.withdrawFromCardMinLimit ?? "", forceShowPrecision: true)}"
                              ),

                              ChargesCard(
                                  title: "${MyStrings.withdrawMaximumLimit}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.withdrawFromCardMaxLimit ?? "", forceShowPrecision: true)}"
                              ),

                              ChargesCard(
                                  isShowDivider: false,
                                  title: "${MyStrings.actionDeclineCharge}: ",
                                  value: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.declineCharge ?? "", forceShowPrecision: true)}"
                              ),

                            ],
                          )
                      ),
                    ),

                  ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
