import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/core/data/models/transaction_history/transaction_history_model.dart';
import 'package:ovopay/core/data/services/service_exporter.dart';
import 'package:ovopay/core/utils/util_exporter.dart';
import '../../../core/route/route.dart';

class SuccessScreen extends StatefulWidget {

  final SuccessScreenModel successScreenModel;

  const SuccessScreen({super.key, required this.successScreenModel});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final double amountAdded =
        double.tryParse(widget.successScreenModel.transaction?.amount ?? "0") ?? 0;
    final double processingFee =
        double.tryParse(widget.successScreenModel.processingFee ?? "0") ?? 0;
    final double totalDeducted = amountAdded + processingFee;

    return Scaffold(
      body: SafeArea(child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            spaceDown(Dimensions.space16.h),

            MyAssetImageWidget(assetPath: MyIcons.check, isSvg: true, width: 100, height: 100),
            spaceDown(Dimensions.space4.h),

            Text(widget.successScreenModel.isFromTopUp ? MyStrings.topUpSuccessful.tr : MyStrings.withdrawSuccessful.tr, style: MyTextStyle.sectionTitle.copyWith(fontSize: Dimensions.space22.sp)),
            spaceDown(Dimensions.space4),
            Text("${widget.successScreenModel.isFromTopUp ? MyStrings.yourCardHasBeenToppedUpWith.tr : MyStrings.yourCardHasBeenWithdrawWith.tr} ${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(widget.successScreenModel.transaction?.amount ?? "", forceShowPrecision: true)} ", style: MyTextStyle.caption1Style.copyWith(fontSize: 13.sp)),
            
            spaceDown(Dimensions.space16.h),
            
            CustomAppCard(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Visibility(
                    visible: widget.successScreenModel.isFromTopUp,
                    child: RowItem(
                      title: MyStrings.transactionReference.tr,
                      subtitle: widget.successScreenModel.transaction?.reference ?? "",
                    ),
                  ),

                  RowItem(
                    title: MyStrings.dateAndTime.tr,
                    subtitle:widget.successScreenModel.isFromTopUp ? DateConverter.formatDate2(widget.successScreenModel.createdAt ?? "") : widget.successScreenModel.createdAt ?? "",
                  ),

                  RowItem(
                    title: MyStrings.method,
                    subtitle: widget.successScreenModel.method ?? "",
                  ),

                  RowItem(
                    title: MyStrings.amount,
                    subtitle: "${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(widget.successScreenModel.transaction?.amount ?? "", forceShowPrecision: true)}",
                  ),

                  RowItem(
                    title: MyStrings.processingFee.tr,
                    subtitle: "${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(widget.successScreenModel.processingFee ?? "", forceShowPrecision: true)}",
                  ),

                  Visibility(
                    visible: widget.successScreenModel.isFromTopUp,
                    child: RowItem(
                      title: MyStrings.totalDeducted.tr,
                      subtitle: "${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(totalDeducted.toString(), forceShowPrecision: true)}",
                    ),
                  ),

                  RowItem(
                    isShowDivider: false,
                    title: MyStrings.status,
                    subtitle: widget.successScreenModel.transaction?.status ?? "",
                  ),

                ],
              )
            ),

            spaceDown(Dimensions.space16.h),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16),
              child: CustomElevatedBtn(text: MyStrings.backToHome, onTap: () {
                Get.offAllNamed(RouteHelper.dashboardScreen);
              }),
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

class SuccessScreenModel{
  final TransactionHistoryModel? transaction;
  final String? processingFee;
  final String? method;
  final String? createdAt;
  final bool isFromTopUp;

  SuccessScreenModel({this.transaction, this.processingFee, this.method, this.createdAt, this.isFromTopUp = true});
}
