import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';
import 'package:ovopay/app/screens/card/view/widget/card_ui.dart';
import 'package:ovopay/app/screens/card_details/view/contorller/card_details_controller.dart';
import 'package:ovopay/app/screens/card_details/view/widget/freeze_card_bottom_sheet.dart';
import 'package:ovopay/core/data/repositories/card/card_repo.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/utils/util_exporter.dart';
import '../../../components/dialog/app_dialog.dart';
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
    // Fetch initial data
    Get.put(CardRepo());
    var controller = Get.put(CardDetailsController(cardRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        controller.getCardDetails(widget.cardInfo?.cardModel.id.toString() ?? "-1");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardDetailsController>(
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

            },
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Skeletonizer(
                enabled: controller.isLoading,
                child: Column(
                  children: [
                    CardUi(
                      onViewTap: () {
                        if(controller.cardModel.isShowCardView == true){
                          controller.cardModel.isShowCardView = false;
                          controller.update();
                        }else{
                          AppDialogs.pinDialog(context,
                            onTap: () {
                              Get.find<CardController>().cardPinVerification(index: -1, cardId: controller.cardModel.id.toString(), cardData: controller.cardModel).then((value) {
                                controller.update();
                              },);
                            },
                          );
                        }
                      },
                      color: widget.cardInfo?.color ?? [],
                      cardModel: controller.cardModel,
                      currency: controller.currency,
                    ),

                    spaceDown(Dimensions.space24.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.space20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReUsableCard(title:  MyStrings.topUp, icon: MyIcons.sendIcon, onTap: () {
                            Get.toNamed(RouteHelper.topUpCardScreen, arguments: controller.cardModel.id.toString());
                          }),
                          ReUsableCard(
                            onTap: () {
                              Get.toNamed(RouteHelper.withdrawScreen, arguments: controller.cardModel);
                            },
                            title: MyStrings.withdraw, icon: MyIcons.withdraw
                          ),
                          ReUsableCard(
                            onTap: () {
                              FreezeCardBottomSheet.freezeCardBottomSheet(context);
                            },
                            title: controller.cardModel.freezingReason == null ? MyStrings.freeze : MyStrings.unfreezeCard,
                            icon: MyIcons.freeze
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
                          Text(MyStrings.transaction.tr, style: MyTextStyle.sectionTitle2,),
                          spaceDown(Dimensions.space18.h),

                          ListView.builder(
                            itemCount: controller.transactionHistoryList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {

                              var transactionHistory = controller.transactionHistoryList[index];

                              return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(transactionHistory.details ?? "", style: MyTextStyle.sectionTitle3),
                                              spaceDown(Dimensions.space4),
                                              Text("${controller.getStatus(transactionHistory.status ?? "")} • ${DateConverter.formatDate(transactionHistory.createdAt ?? "")}", style: MyTextStyle.caption1Style)
                                            ],
                                          ),
                                        ),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("${transactionHistory.trxType} ${controller.currency}${AppConverter.formatNumber(transactionHistory.amount ?? "")}", style: MyTextStyle.sectionBodyBoldTextStyle.copyWith(color: MyColor.black)),
                                            spaceDown(Dimensions.space4),
                                            Text(transactionHistory.trxType == "+" ? MyStrings.incoming.tr : MyStrings.outgoing.tr, style: MyTextStyle.caption1Style)
                                          ],
                                        )
                                      ],
                                    ),
                                    Visibility(
                                      visible: index != controller.transactionHistoryList.length - 1,
                                      child: CustomDivider()
                                    ),
                                  ]
                              );
                            },
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
