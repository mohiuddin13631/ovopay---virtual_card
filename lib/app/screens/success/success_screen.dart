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

  String getStatus(String status){
    if(status == "0"){
      return "Pending";
    }else if(status == "1"){
      return "Completed";
    }else{
      return "Rejected";
    }
  }

  String processingFee = "";
  @override
  void initState() {
    super.initState();
  }
  
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

            Text(MyStrings.topUpSuccessful.tr, style: MyTextStyle.sectionTitle.copyWith(fontSize: Dimensions.space22.sp)),
            spaceDown(Dimensions.space4),
            Text("${MyStrings.yourCardHasBeenToppedUpWith.tr} ${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(widget.successScreenModel.transaction?.amount ?? "")} ", style: MyTextStyle.caption1Style.copyWith(fontSize: 13.sp)),
            
            spaceDown(Dimensions.space16.h),
            
            CustomAppCard(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(MyStrings.setupMonthlyFees.tr, style: MyTextStyle.caption1Style.copyWith(fontSize: 13.sp)),
                  spaceDown(Dimensions.space8.h),

                  RowItem(
                    title: MyStrings.transactionId.tr,
                    subtitle: widget.successScreenModel.transaction?.trx ?? "",
                  ),

                  RowItem(
                    title: MyStrings.dateAndTime.tr,
                    subtitle: DateConverter.formatDate(widget.successScreenModel.transaction?.createdAt ?? ""),
                  ),

                  RowItem(
                    title: MyStrings.method,
                    subtitle: widget.successScreenModel.transaction?.cardTransactionType ?? "",
                  ),

                  RowItem(
                    title: MyStrings.amountAdded,
                    subtitle: "${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(widget.successScreenModel.transaction?.amount ?? "")}",
                  ),

                  RowItem(
                    title: MyStrings.processingFee.tr,
                    subtitle: "${SharedPreferenceService.getCurrencySymbol()}${AppConverter.formatNumber(widget.successScreenModel.processingFee ?? "")}",
                  ),

                  RowItem(
                    isShowDivider: false,
                    title: MyStrings.status,
                    subtitle: getStatus(widget.successScreenModel.transaction?.status ?? ""),
                  ),

                ],
              )
            ),

            spaceDown(Dimensions.space16.h),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16),
              child: CustomElevatedBtn(text: MyStrings.backToHome, onTap: () {
                Get.offAllNamed(RouteHelper.dashboardScreen);
              },),
            )

            /*Row(
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
            )*/
            
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

  SuccessScreenModel({this.transaction, this.processingFee});
}
