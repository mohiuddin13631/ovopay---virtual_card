import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopay/app/screens/withdraw/controller/withdraw_controller.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/data/repositories/withdraw/withdraw_repo.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/util_exporter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../components/text-field/rounded_text_field.dart';
import '../../../components/text/header_text.dart';
import '../../dashboard_screen/controller/home_controller.dart';
class WithdrawScreen extends StatefulWidget {

  final CardModel cardModel;

  const WithdrawScreen({super.key, required this.cardModel});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {

  @override
  void initState() {
    Get.put(WithdrawRepo());
    var controller = Get.put(WithdrawController(withdrawRepo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        controller.loadData(widget.cardModel.id.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawController>(
      builder: (controller) => MyCustomScaffold(
          pageTitle: MyStrings.enterAmount.tr,
          body: Skeletonizer(
            enabled: controller.isLoading,
            child: Column(
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
                                      Text(MyStrings.withdrawFrom.tr, style: MyTextStyle.caption1Style),
                                      spaceDown(Dimensions.space2.h),
                                      Text(MyStrings.cardBalance.tr, style: MyTextStyle.sectionTitle3)
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(MyStrings.feeRate.tr, style: MyTextStyle.caption1Style),
                                    spaceDown(Dimensions.space2.h),
                                    Text('${AppConverter.formatNumber(controller.chargeSetting?.cardWithdrawCharge ?? "")}%', style: MyTextStyle.sectionTitle3)
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

                              spaceDown(Dimensions.space8),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${MyStrings.availableBalance.tr}: ",
                                      style: MyTextStyle.sectionBodyTextStyle.copyWith(
                                        color: MyColor.getBodyTextColor(),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${controller.currency}${AppConverter.formatNumber(controller.cardModel?.balance ?? "", forceShowPrecision: true)}",
                                      style: MyTextStyle.sectionBodyBoldTextStyle.copyWith(color: MyColor.getPrimaryColor()),
                                    ),
                                  ],
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
                                    Text("${controller.minimumAmount} ${controller.textCurrency}")
                                  ],
                                ),

                                spaceDown(Dimensions.space10.h),
                                Row(
                                  children: [
                                    Expanded(child: Text(MyStrings.maximumAmount, style: MyTextStyle.caption1Style,)),
                                    Text("${controller.maximumAmount} ${controller.textCurrency}")
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
                        if(controller.amountController.text.isEmpty){
                          CustomSnackBar.error(errorList: [MyStrings.enterAmount]);
                        }
                        else if(AppConverter.formatNumberDouble(controller.amountController.text) > controller.maximumAmount){
                          CustomSnackBar.error(errorList: ["${MyStrings.valueMustBeLess.tr} ${controller.maximumAmount}"]);
                        }else if(AppConverter.formatNumberDouble(controller.amountController.text) < controller.minimumAmount){
                          CustomSnackBar.error(errorList: ["${MyStrings.valueMustBeGreater.tr} ${controller.minimumAmount}"]);
                        }else{
                          Get.toNamed(RouteHelper.confirmWithdrawScreen);
                        }
                    }
                )
              ],
            ),
          )
      ),
    );
  }
}
