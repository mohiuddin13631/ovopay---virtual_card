import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';
import 'package:ovopay/app/screens/card/view/widget/card_ui.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/util_exporter.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {

  @override
  void initState() {
    super.initState();
    Get.put(CardController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (controller) => MyCustomScaffold(
        padding: EdgeInsets.zero,
        pageTitle: MyStrings.virtualCard,
        onBackButtonTap: () {
          Get.back();
        },
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
        body: Column(
          children: [
            spaceDown(context.height * .03),
            Text(MyStrings.cardScreenTitle.tr, style: MyTextStyle.sectionTitle2.copyWith(fontWeight: FontWeight.w400)),
            SizedBox(height: context.height * .1),
            GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity == null) return;

                if (details.primaryVelocity! < 0) {
                  controller.onSwipe(true); // swipe up
                } else {
                  controller.onSwipe(false); // swipe down
                }

              },
              child: SizedBox(
                height: controller.cardHeight + controller.overlap * 2,
                child: Stack(

                  clipBehavior: Clip.none,
                  children: List.generate(controller.cards.length, (i) {

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
                          onTap: () {
                            Get.toNamed(RouteHelper.cardDetailsScreen, arguments: CardInfo(color: controller.cards[i]));
                          },
                          color: controller.cards[i]
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
    );
  }
}