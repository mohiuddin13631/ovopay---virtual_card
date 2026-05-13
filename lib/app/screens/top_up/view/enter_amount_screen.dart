import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/dialog/app_dialog.dart';
import 'package:ovopay/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopay/app/screens/top_up/controller/topup_controller.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/util_exporter.dart';

import '../../../components/text-field/rounded_text_field.dart';
import '../../../components/text/header_text.dart';
import '../../dashboard_screen/controller/home_controller.dart';
class EnterAmountScreen extends StatefulWidget {

  final TopUpInfo topUpInfo;

  const EnterAmountScreen({super.key, required this.topUpInfo});

  @override
  State<EnterAmountScreen> createState() => _EnterAmountScreenState();
}

class _EnterAmountScreenState extends State<EnterAmountScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopUpController>(
      builder: (controller) => MyCustomScaffold(
        pageTitle: MyStrings.enterAmount.tr,
        body: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomAppCard(
                        radius: Dimensions.space12,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(MyStrings.topUpMethod.tr, style: MyTextStyle.caption1Style),
                                  spaceDown(Dimensions.space2.h),
                                  Text(widget.topUpInfo.topUpMethod, style: MyTextStyle.sectionTitle3)
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(MyStrings.feeRate.tr, style: MyTextStyle.caption1Style),
                                spaceDown(Dimensions.space2.h),
                                Text('${AppConverter.formatNumber(widget.topUpInfo.topUpMethod == MyStrings.fromMainBalance ? controller.chargeSettingForWallet?.topupChargeFromWallet ?? "" : controller.chargeSettingForWallet?.topupChargeFromCrypto ?? "")}%', style: MyTextStyle.sectionTitle3)
                              ],
                            ),
                          ],
                        )
                    ),

                    spaceDown(Dimensions.space16.h),

                    CustomAppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderText(
                              text: MyStrings.amount.tr,
                              textStyle: MyTextStyle.sectionTitle.copyWith(
                                color: MyColor.getHeaderTextColor(),
                              ),
                            ),
                            spaceDown(Dimensions.space12.h),

                            RoundedTextField(
                              contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.space20, vertical: Dimensions.space18),
                              showLabelText: false,
                              labelText: MyStrings.enterAmount.tr,
                              hintText: "${controller.currency}0.00",
                              textInputAction: TextInputAction.done,
                              controller: controller.amountController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textStyle: MyTextStyle.headerH3.copyWith(
                                color: MyColor.getHeaderTextColor(),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.space16),
                                child: Text(controller.textCurrency, style: MyTextStyle.sectionTitle.copyWith(fontSize: Dimensions.space15.sp),),
                              ),
                              focusBorderColor: MyColor.getPrimaryColor(),
                              textInputFormatter: [
                                // Limits decimal places (optional, adjust as needed)
                              ],
                              onChanged: (value) {},
                              validator: (value) {},
                            ),

                            spaceDown(widget.topUpInfo.topUpMethod == MyStrings.fromMainBalance ? Dimensions.space8 : 0),
                            Visibility(
                              visible: widget.topUpInfo.topUpMethod == MyStrings.fromMainBalance,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${MyStrings.availableBalance.tr}: ",
                                      style: MyTextStyle.sectionBodyTextStyle.copyWith(
                                        color: MyColor.getBodyTextColor(),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${controller.currency}${AppConverter.formatNumber(Get.find<HomeController>().accountBalanceFormatted, forceShowPrecision: true)}",
                                      style: MyTextStyle.sectionBodyBoldTextStyle.copyWith(color: MyColor.getPrimaryColor()),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            spaceDown(Dimensions.space24.h),

                            Wrap(
                                runSpacing: Dimensions.space8.h,
                                spacing: Dimensions.space8.w,
                                children: List.generate(controller.suggestedAmountList.length, (index) {

                                  return GestureDetector(
                                    onTap: () {
                                      controller.amountController.text = controller.suggestedAmountList[index];
                                    },
                                    child: CustomAppCard(
                                      radius: Dimensions.largeRadius,
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.space18, vertical: Dimensions.space14),
                                      backgroundColor: MyColor.getWhiteColor(),
                                      borderColor: MyColor.getBorderColor(),
                                      child: Text(controller.suggestedAmountList[index], style: MyTextStyle.caption1Style.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.space15.sp)),
                                    ),
                                  );
                                })
                            ),
                          ],
                        ),
                    ),

                    spaceDown(Dimensions.space16.h),

                    CustomAppCard(
                        radius: Dimensions.space12,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(MyStrings.minimumAmount, style: MyTextStyle.caption1Style,)),
                                Text("${widget.topUpInfo.topUpMethod == MyStrings.fromMainBalance ? controller.walletMinimumAmount : controller.cryptoMinimumAmount} ${controller.textCurrency}")
                              ],
                            ),

                            spaceDown(Dimensions.space10.h),
                            Row(
                              children: [
                                Expanded(child: Text(MyStrings.maximumAmount, style: MyTextStyle.caption1Style,)),
                                Text("${widget.topUpInfo.topUpMethod == MyStrings.fromMainBalance ? controller.walletMaximumAmount : controller.cryptoMaximumAmount} ${controller.textCurrency}")
                              ],
                            ),
                          ],
                        )
                    ),
                    
                    spaceDown(Dimensions.space16)
                  ],
                ),
              ),
            ),

            CustomElevatedBtn(
              bgColor: MyColor.transparentColor,
              borderColor: MyColor.primary,
              textColor: MyColor.black,
              isLoading: controller.isSubmitLoading,
              text: MyStrings.next, onTap: () {
                if(widget.topUpInfo.topUpMethod == MyStrings.fromMainBalance){
                  if(controller.amountController.text.isEmpty){
                    CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
                  }
                  else if(AppConverter.formatNumberDouble(controller.amountController.text) > controller.walletMaximumAmount){
                    CustomSnackBar.error(errorList: ["${MyStrings.valueMustBeLess.tr} ${controller.walletMaximumAmount}"]);
                  }else if(AppConverter.formatNumberDouble(controller.amountController.text) < controller.walletMinimumAmount){
                    CustomSnackBar.error(errorList: ["${MyStrings.valueMustBeGreater.tr} ${controller.walletMinimumAmount}"]);
                  }else{
                    Get.toNamed(RouteHelper.confirmTopUpScreen, arguments: TopUpInfo(topUpMethod: controller.mainBalanceType));
                  }
                }else{
                  if(controller.amountController.text.isEmpty){
                    CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
                  } else if(AppConverter.formatNumberDouble(controller.amountController.text) > controller.cryptoMaximumAmount){
                    CustomSnackBar.error(errorList: ["${MyStrings.valueMustBeLess.tr} ${controller.cryptoMaximumAmount}"]);
                  }else if(AppConverter.formatNumberDouble(controller.amountController.text) < controller.cryptoMinimumAmount){
                    CustomSnackBar.error(errorList: ["${MyStrings.valueMustBeGreater.tr} ${controller.cryptoMinimumAmount}"]);
                  }else{
                    controller.generateCryptoAddress(onSuccessCallback: (value) async {
                      await AppDialogs.cryptoDialog(context, cryptoAddress: value.data).then((value) => controller.amountController.clear());
                    });
                  }
                }
              }
            )
          ],
        )
      ),
    );
  }
}
