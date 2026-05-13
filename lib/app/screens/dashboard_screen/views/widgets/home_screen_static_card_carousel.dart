import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/dialog/app_dialog.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/screens/card/controller/card_controller.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/utils/util_exporter.dart';

import '../../../../components/snack_bar/show_custom_snackbar.dart';

class HomeScreenCardCarousel extends StatefulWidget {
  const HomeScreenCardCarousel({super.key});

  @override
  State<HomeScreenCardCarousel> createState() =>
      _HomeScreenCardCarouselState();
}

class _HomeScreenCardCarouselState
    extends State<HomeScreenCardCarousel> {
  late final PageController _pageController = PageController(
    viewportFraction: 0.88,
  );

  @override
  void initState() {
    super.initState();
    CardController.ensureInitialized();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Padding(
            padding: EdgeInsetsDirectional.only(top: Dimensions.space20.w),
            child: SizedBox(
              height: 215.h,
              child: _HomeStaticCardUi(
                cardModel: CardModel(bgImage: 'image_one.png'),
                currency: controller.currency,
              ),
            ),
          );
        }

        if (controller.cardList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsetsDirectional.only(top: Dimensions.space20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: Dimensions.space4.w,
                ),
                child: HeaderText(
                  text: MyStrings.virtualCards.tr,
                  textStyle: MyTextStyle.sectionTitle2.copyWith(
                    color: MyColor.getHeaderTextColor(),
                  ),
                ),
              ),
              spaceDown(Dimensions.space12),
              SizedBox(
                height: 215.h,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: controller.cardList.length,
                  clipBehavior: Clip.none,
                  padEnds: false,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == controller.cardList.length - 1 ? 0 : 10.w,
                      ),
                      child: _HomeStaticCardUi(
                        cardModel: controller.cardList[index],
                        currency: controller.currency,
                        onViewTap: () {
                          final card = controller.cardList[index];

                          if (card.isShowCardView) {
                            controller.hideCardDetails(index);
                          } else {
                            AppDialogs.pinDialog(
                              context,
                              onTap: () {
                                controller.cardPinVerification(
                                  cardId: card.id.toString(),
                                  index: index,
                                );
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeStaticCardUi extends StatelessWidget {
  final CardModel cardModel;
  final String currency;
  final VoidCallback? onViewTap;

  const _HomeStaticCardUi({
    required this.cardModel,
    required this.currency,
    this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.cardExtraRadius.r),
        image: DecorationImage(
          image: AssetImage(
            cardModel.bgImage != null
                ? 'assets/images/card_image/${cardModel.bgImage}'
                : MyImages.imageOne,
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyAssetImageWidget(
                assetPath: MyIcons.network,
                isSvg: true,
                width: 16.w,
                height: 22.h,
              ),
              MyAssetImageWidget(
                assetPath: MyIcons.visa,
                width: 66.w,
                height: 22.h,
                isSvg: true,
              ),
            ],
          ),
          const Spacer(),
          Text(
            MyStrings.balance.tr,
            style: MyTextStyle.bodyTextStyle1.copyWith(
              color: Colors.white70,
              fontSize: Dimensions.fontSmall,
            ),
          ),
          spaceDown(Dimensions.space4),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$currency${cardModel.isShowCardView ? cardModel.balance ?? "" : "••••••••"}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: MyTextStyle.sectionTitle.copyWith(
                    color: MyColor.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              spaceSide(Dimensions.space8),
              CustomAppCard(
                onPressed: onViewTap,
                height: 34,
                width: 34,
                showBorder: false,
                radius: Dimensions.radiusProMax,
                backgroundColor: MyColor.black.withValues(alpha: 0.45),
                padding: EdgeInsets.all(Dimensions.space7),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    cardModel.isShowCardView
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: MyColor.getWhiteColor(),
                    size: Dimensions.space24,
                  ),
                ),
              ),
            ],
          ),
          spaceDown(Dimensions.space14),
          Row(
            children: [
              Expanded(
                child: Text(
                  cardModel.isShowCardView
                      ? MyUtils.addSpaceEvery4(cardModel.cardNumber ?? "")
                      : '••• ${cardModel.lastFour ?? ""}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: MyTextStyle.sectionSubTitle1.copyWith(
                    color: MyColor.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Visibility(
                visible: cardModel.isShowCardView,
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: cardModel.cardNumber ?? ""),
                    ).then((_) {
                      CustomSnackBar.showToast(
                        message: MyStrings.copiedToClipBoard.tr,
                      );
                    });
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 8.w),
                    child: MyAssetImageWidget(
                      assetPath: MyIcons.copy,
                      isSvg: true,
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
          spaceDown(Dimensions.space12),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  title: MyStrings.cardName.tr,
                  value: cardModel.nameOnCard ?? "",
                ),
              ),
              spaceSide(Dimensions.space12),
              Expanded(
                child: _InfoItem(
                  title: MyStrings.expirationDate.tr,
                  value: cardModel.isShowCardView
                      ? cardModel.expiry ?? ""
                      : '•••/•••',
                ),
              ),
              spaceSide(Dimensions.space12),
              Expanded(
                child: _InfoItem(
                  title: MyStrings.cvv.tr,
                  value: cardModel.isShowCardView ? cardModel.cvv ?? "" : '•••',
                ),
              ),
              spaceSide(Dimensions.space8),
              MyAssetImageWidget(
                assetPath: MyIcons.chip,
                width: 34.w,
                height: 26.h,
                isSvg: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: MyTextStyle.bodyTextStyle1.copyWith(
            color: MyColor.white,
            fontSize: 8.sp,
          ),
        ),
        spaceDown(2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: MyTextStyle.caption2Style.copyWith(
            color: MyColor.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
