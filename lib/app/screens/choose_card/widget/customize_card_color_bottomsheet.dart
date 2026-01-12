import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:ovopay/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';

import '../../../../../core/utils/util_exporter.dart';

class CustomizeCardColorBottomSheet {
  static void customizeCardColorBottomSheet(BuildContext context) {
    CustomBottomSheetPlus(
      isNeedAnimatedPadding: false,
      child: SafeArea(
        child: Builder(
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Container(
                  height: MediaQuery.of(context).size.height * .4,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.getWhiteColor(),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BottomSheetBar(),
                      spaceDown(Dimensions.space20),
                      Row(
                        children: [
                          Expanded(
                            child: HeaderText(
                              text: "Choose Card Color",
                              textStyle: MyTextStyle.headerH3.copyWith(
                                color: MyColor.getHeaderTextColor(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: IconButton(
                              padding: EdgeInsets.all(Dimensions.space3.w),
                              style: IconButton.styleFrom(),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: MyAssetImageWidget(
                                color: MyColor.getHeaderTextColor(),
                                isSvg: true,
                                assetPath: MyIcons.closeButton,
                                width: Dimensions.space40.w,
                                height: Dimensions.space40.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceDown(Dimensions.space20),

                      GetBuilder<CardController>(
                        builder: (controller) => Wrap(
                          children: List.generate(controller.cards.length, (index) {
                            return  GestureDetector(
                              onTap: () {
                                controller.selectedCardColorIndex = index;
                                controller.update();
                              },
                              child: Stack(
                                // fit: StackFit.loose,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    margin: EdgeInsets.only(right: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            colors: controller.cards[index]
                                        )
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 6,
                                    top: 0,
                                    bottom: 10,
                                    child: Visibility(
                                      visible: controller.selectedCardColorIndex == index,
                                      child: Icon(Icons.check, size: 25, color: MyColor.white,))
                                  )
                                ],
                              ),
                            );
                          },),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    ).show(context);
  }
}
