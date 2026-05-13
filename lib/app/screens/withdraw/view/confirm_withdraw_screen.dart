import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopay/app/components/card/amount_details_card.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/dialog/app_dialog.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/screens/success/success_screen.dart';
import 'package:ovopay/app/screens/top_up/controller/topup_controller.dart';
import 'package:ovopay/app/screens/withdraw/controller/withdraw_controller.dart';
import 'package:ovopay/core/route/route.dart';

import '../../../../../core/data/services/service_exporter.dart';
import '../../../../../core/utils/util_exporter.dart';
import '../../../components/column_widget/card_column.dart';

class ConfirmWithdrawScreen extends StatefulWidget {

  const ConfirmWithdrawScreen({super.key});

  @override
  State<ConfirmWithdrawScreen> createState() => _ConfirmWithdrawScreenState();
}

class _ConfirmWithdrawScreenState extends State<ConfirmWithdrawScreen> {

  // Reusable Contact List Tile
  Widget _buildContactTile(
      WithdrawController controller, {
        bool showBorder = true,
        EdgeInsetsGeometry? padding,
      }) {
    return Row(
      children: [
        Container(
            padding: EdgeInsetsGeometry.all(Dimensions.space10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MyColor.primary
            ),
            child: MyAssetImageWidget(assetPath: MyIcons.wallet, isSvg: true, width: 22, height: 22,)
        ),

        spaceSide(Dimensions.space10.w),

        Text(MyStrings.reviewTheDetailsBeforeProceeding.tr, style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.bodyText),)
      ],
    );
  }

  // Reusable Amount Details Card
  Widget _buildAmountDetailsCard(WithdrawController controller) {
    return Column(
      children: [
        AmountDetailsCard(
          firstTitle: MyStrings.withdrawAmount,
          amount: MyStrings.cardBalance,
          endTitle: MyStrings.withdrawMethod.tr,
          total: "${controller.currency} ${controller.amountController.text}",
        ),
        CustomDivider(space: Dimensions.space8,),
        AmountDetailsCard(
          firstTitle: "${MyStrings.processingFee.tr} (${AppConverter.formatNumber(controller.chargeSetting?.cardWithdrawCharge ?? "")}%)",
          amount: "${controller.currency}${controller.getProcessingFee(controller.chargeSetting?.cardWithdrawCharge ?? "")}",
          endTitle: MyStrings.perTransactionCharge.tr,
          total: "${controller.currency}${AppConverter.formatNumber(controller.chargeSetting?.perOperationCharge ?? "")}",
        ),

        CustomDivider(space: Dimensions.space8,),
        Row(
          children: [
            CardColumn(
              headerTextStyle: MyTextStyle.caption1Style.copyWith(
                color: MyColor.getBodyTextColor(),
              ),
              header: MyStrings.netAmountYouWillReceive,
              body: "${controller.currency}${controller.getNetAmount()}",
              space: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              isBodyEllipsis: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalancePreviewCard(WithdrawController controller) {
    return Column(
      children: [
        AmountDetailsCard(
          firstTitle: MyStrings.currentBalance,
          endTitle: MyStrings.newBalance,
          amount: "${controller.currency}${AppConverter.formatNumber(controller.cardModel?.balance ?? "", forceShowPrecision: true)}",
          total: "${controller.currency}${controller.getNewBalance()}",
        ),
      ],
    );
  }

  // Reusable Confirm Dialog
  Future<void> _showConfirmDialog(WithdrawController controller) async {
    MyUtils.clearAllTypeFocusNodes();
    if (controller.pinController.text.toString().length < SharedPreferenceService.getMaxPinNumberDigit()) {
      CustomSnackBar.error(
        errorList: [
          MyStrings.kPinMaxNumberError.tr.rKv({
            "digit": "${SharedPreferenceService.getMaxPinNumberDigit()}",
          }).tr,
        ],
      );
      return;
    }
    await AppDialogs.confirmDialog(
      context,
      title: MyStrings.topUp.replaceAll("-", " "),
      userDetailsWidget: SizedBox(),
      cashDetailsWidget: CustomAppCard(
        radius: Dimensions.largeRadius.r,
        child: _buildAmountDetailsCard(controller),
      ),
      onFinish: () async {
        await controller.onConfirmWithdraw(
          onSuccessCallback: (value) async {
            // Handle the completed progress here
            double amount = AppConverter.formatNumberDouble(value.data?.amount ?? "");
            double totalAmount = AppConverter.formatNumberDouble(value.data?.totalAmount ?? "");
            double processingFee = amount - totalAmount;

            Navigator.pop(context);
            Get.toNamed(RouteHelper.successScreen, arguments: SuccessScreenModel(isFromTopUp: false, method: value.data?.method, createdAt: value.data?.createdAt, transaction: value.data?.transaction, processingFee: AppConverter.formatNumber(processingFee.toString())));
            return;
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawController>(
      builder: (controller) {
        return MyCustomScaffold(
          padding: EdgeInsets.zero,
          pageTitle: MyStrings.confirmWithdraw,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.space14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                spaceDown(Dimensions.space16),

                CustomAppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactTile(
                        controller,
                        padding: EdgeInsetsDirectional.only(
                          bottom: Dimensions.space10,
                        ),
                      ),
                      spaceDown(Dimensions.space16),
                      _buildAmountDetailsCard(controller),
                    ],
                  ),
                ),

                spaceDown(Dimensions.space12),

                CustomAppCard(
                  child: _buildBalancePreviewCard(controller),
                ),

                spaceDown(Dimensions.space16),

                RoundedTextField(
                  showLabelText: false,
                  controller: controller.pinController,
                  labelText: MyStrings.pin,
                  hintText: MyStrings.enterYourPinCode,
                  isPassword: true,
                  forceShowSuffixDesign: true,
                  fillColor: MyColor.getWhiteColor(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                      SharedPreferenceService.getMaxPinNumberDigit(),
                    ),
                  ],
                  prefixIcon: Container(
                    margin: const EdgeInsetsDirectional.only(
                      start: Dimensions.space15,
                      end: Dimensions.space8,
                    ),
                    child: MyAssetImageWidget(
                      color: MyColor.getPrimaryColor(),
                      width: 22.sp,
                      height: 16.sp,
                      boxFit: BoxFit.contain,
                      assetPath: MyIcons.lock,
                      isSvg: true,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => _showConfirmDialog(controller),
                    icon: MyAssetImageWidget(
                      color: MyColor.getPrimaryColor(),
                      width: 20.sp,
                      height: 20.sp,
                      boxFit: BoxFit.contain,
                      assetPath: MyIcons.arrowForward,
                      isSvg: true,
                    ),
                  ),
                ),

                spaceDown(Dimensions.space15),

                AppMainSubmitButton(
                  text: MyStrings.confirm,
                  isLoading: controller.isSubmitLoading,
                  onTap: () {
                    _showConfirmDialog(controller);
                  },
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
