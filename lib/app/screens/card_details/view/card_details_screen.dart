import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';
import 'package:ovopay/app/screens/card/view/widget/card_ui.dart';
import 'package:ovopay/app/screens/card_details/view/widget/freeze_card_bottom_sheet.dart';
import 'package:ovopay/app/screens/card_details/view/widget/terminate_card_bottom_sheet.dart';
import 'package:ovopay/app/screens/statements/controller/statement_history_controller.dart';
import 'package:ovopay/core/data/repositories/transaction_history/transaction_history_repo.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/util_exporter.dart';
import '../../../components/image/my_asset_widget.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key, this.cardInfo});
  final CardInfo? cardInfo;

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  @override
  void initState() {
    super.initState();

    Get.put(TransactionHistoryRepo());
    final controller = Get.put(
      StatementHistoryController(transactionHistoryRepo: Get.find()),
    );

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        controller.initialHistoryData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatementHistoryController>(
      builder: (controller) {
        return MyCustomScaffold(
          pageTitle: MyStrings.virtualCard,
          padding: EdgeInsets.zero,
          onBackButtonTap: () {
            Get.back();
          },
          actionButton: [],
          body: RefreshIndicator(
            color: MyColor.getPrimaryColor(),
            onRefresh: () async {
              controller.getStatementsHistoryDataList(forceLoad: true);
            },
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Skeletonizer(
                enabled: controller.isStatementLoading,
                child: Column(
                  children: [

                    CardUi(color: widget.cardInfo?.color ?? []),

                    spaceDown(Dimensions.space24.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.space16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReUsableCard(title:  MyStrings.topUp, icon: MyIcons.sendIcon, onTap: () {
                            Get.toNamed(RouteHelper.topUpCardScreen);
                          }),
                          ReUsableCard(title: MyStrings.withdraw, icon: MyIcons.withdraw),
                          ReUsableCard(
                            onTap: () {
                              FreezeCardBottomSheet.freezeCardBottomSheet(context);
                            },
                            title: MyStrings.freeze,
                            icon: MyIcons.freeze
                          ),
                          ReUsableCard(
                            onTap: () {
                              TerminateCardBottomSheet.terminateCardBottomSheet(context);
                            },
                            title: MyStrings.terminate,
                            icon: MyIcons.terminate
                          ),
                        ],
                      ),
                    ),

                    spaceDown(Dimensions.space24.h),
                    
                    CustomAppCard(
                      margin: EdgeInsets.symmetric(horizontal: Dimensions.space16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Transactions", style: MyTextStyle.sectionTitle2,),
                          spaceDown(Dimensions.space18.h),

                          Column(
                            children: List.generate(10, (index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("•••• •••• •••• 3507", style: MyTextStyle.sectionTitle3),
                                            Text("google", style: MyTextStyle.caption1Style)
                                          ],
                                        ),
                                      ),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("- \$56.00", style: MyTextStyle.sectionBodyBoldTextStyle.copyWith(color: MyColor.error)),
                                          Text("12-10-2024 6:45", style: MyTextStyle.caption1Style)
                                        ],
                                      )
                                    ],
                                  ),
                                  CustomDivider(),
                                ]
                              );
                            }),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ReUsableCard extends StatelessWidget {

  final String title;
  final String icon;
  final VoidCallback? onTap;

  const ReUsableCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.space16),
            decoration: BoxDecoration(
              color: MyColor.getWhiteColor(),
              shape: BoxShape.circle
            ),
            child: MyAssetImageWidget(assetPath: icon, isSvg: true, color: MyColor.black, width: Dimensions.space24, height: Dimensions.space24),
          ),
          spaceDown(Dimensions.space4.h),
          Text(title, style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.black)),
        ],
      ),
    );
  }
}
