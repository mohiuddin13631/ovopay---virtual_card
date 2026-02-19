import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/custom_loader/custom_loader.dart';
import 'package:ovopay/app/components/dialog/app_dialog.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';
import 'package:ovopay/app/screens/card/view/widget/card_ui.dart';
import 'package:ovopay/core/data/repositories/card/card_repo.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/util_exporter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key, this.onItemTapped});
  final Function(int index)? onItemTapped;

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {

  final ScrollController cardScrollController = ScrollController();
  void scrollListener() {
    if (cardScrollController.position.pixels == cardScrollController.position.maxScrollExtent) {
      if (Get.find<CardController>().hasNext()) {
        Get.find<CardController>().loadData(forceLoad: false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Get.put(CardRepo());
    var controller = Get.put(CardController(cardRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        controller.loadData(); // Receiver if index is 0, Sender otherwise

        // Add scroll listeners
        cardScrollController.addListener(() => scrollListener());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (controller) => MyCustomScaffold(
        padding: EdgeInsets.zero,
        pageTitle: MyStrings.virtualCard,
        onBackButtonTap: (widget.onItemTapped != null)
            ? () {
              widget.onItemTapped!(0);
            } : null,
        actionButton: [
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.cardChargesAndFeesScreen);
            },
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(width: 1, color: MyColor.unselectedColor)
              ),
              child: Icon(Icons.info_outline, color: MyColor.primary,)
            ),
          ),

          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.chooseCardScreen);
            },
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(width: 1, color: MyColor.unselectedColor)
              ),
              child: MyAssetImageWidget(assetPath: MyIcons.adCard, isSvg: true, color: MyColor.primary, width: 25, height: 25,)
            ),
          ),
        ],
        body: Skeletonizer(
          enabled: controller.isLoading,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    spaceDown(context.height * .03),
                    Text(MyStrings.cardScreenTitle.tr, style: MyTextStyle.sectionTitle2.copyWith(fontWeight: FontWeight.w400)),
                    SizedBox(height: context.height * .2),
                    GestureDetector(
                      onVerticalDragEnd: (details) {
                        if (details.primaryVelocity == null) return;

                        if (details.primaryVelocity! < 0) {
                          print("upppp");
                          controller.onSwipe(true); // swipe up
                        } else { //increase
                          print("downnn");
                          controller.onSwipe(false); // swipe down
                        }

                      },
                      child: SizedBox(
                        height: controller.cardHeight + controller.overlap * 2,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: List.generate(controller.cardList.length, (i) {

                            final bool isFront = i == 0;

                            double top = -i * controller.overlap;
                            double scale = i == 0 ? 1 : (i == 1 ? 0.97 : 0.94);

                            if (controller.isAnimating && isFront) {
                              top = controller.swipeDown ? 80 : -80;
                            }

                            return AnimatedPositioned(
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOut,
                              top: top,
                              left: 0,
                              right: 0,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 260),
                                scale: scale,
                                child: CardUi(
                                  cardModel: controller.cardList[i],
                                  currency: controller.currency,
                                  onViewTap: () {

                                    if(controller.cardList[i].isShowCardView == true){
                                      controller.cardList[i].isShowCardView = false;
                                      controller.update();
                                    }else{
                                      AppDialogs.pinDialog(context,
                                        onTap: () {
                                          controller.cardPinVerification(cardId: controller.cardList[i].id.toString(), index: i);
                                        },
                                      );
                                    }
                                  },
                                  onTap: () {
                                    Get.toNamed(RouteHelper.cardDetailsScreen, arguments: CardInfo(color: controller.cards[i], cardModel: controller.cardList[i]));
                                  },
                                  color: controller.cards[i%3]
                                ),
                              ),
                            );

                          }).reversed.toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Positioned(
                top: 0,
                child: Container(
                  height: context.height * .08,
                  width: context.width,
                  decoration: BoxDecoration(
                    color: MyColor.screenBGColor,
                  ),
                  child: Column(
                    children: [
                      spaceDown(context.height * .02),
                      Text(MyStrings.cardScreenTitle.tr, style: MyTextStyle.sectionTitle2.copyWith(fontWeight: FontWeight.w400)),
                      spaceDown(Dimensions.space10.h),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}