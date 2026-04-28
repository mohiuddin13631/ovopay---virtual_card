import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopay/core/data/models/card/card_list_response_model.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/util_exporter.dart';

class StaticCardPreviewScreen extends StatefulWidget {

  const StaticCardPreviewScreen({super.key, this.onItemTapped});
  final Function(int index)? onItemTapped;

  @override
  State<StaticCardPreviewScreen> createState() => _StaticCardPreviewScreenState();
}

class _StaticCardPreviewScreenState extends State<StaticCardPreviewScreen> {
  static const double _cardHeight = 344;
  static const double _overlap = 40;

  bool isAnimating = false;
  bool swipeDown = true;
  final String currency = '\$';

  late final List<CardModel> cardList = [
    CardModel(
      id: 1,
      bgImage: 'image_one.png',
      balance: '12,480.50',
      cardNumber: '4865123412345678',
      lastFour: '5678',
      nameOnCard: 'ALEX MORGAN',
      expiry: '12/28',
      cvv: '824',
      cardName: 'Primary Card',
      cardBrand: 'Visa',
      isShowCardView: true,
    ),
    CardModel(
      id: 2,
      bgImage: 'image_two.png',
      balance: '8,945.20',
      cardNumber: '5212345678904321',
      lastFour: '4321',
      nameOnCard: 'ALEX MORGAN',
      expiry: '09/27',
      cvv: '553',
      cardName: 'Travel Card',
      cardBrand: 'Mastercard',
    ),
    CardModel(
      id: 3,
      bgImage: 'image_three.png',
      balance: '3,210.00',
      cardNumber: '4532765489127788',
      lastFour: '7788',
      nameOnCard: 'ALEX MORGAN',
      expiry: '05/29',
      cvv: '102',
      cardName: 'Backup Card',
      cardBrand: 'Visa',
    ),
  ];

  late final List<String> cardImages = [
    MyImages.imageOne,
    MyImages.imageTwo,
    MyImages.imageThree,
  ];

  Future<void> _onSwipe(bool down) async {
    if (isAnimating || cardList.length < 2) return;

    setState(() {
      isAnimating = true;
      swipeDown = down;
    });

    await Future.delayed(const Duration(milliseconds: 260));

    setState(() {
      if (down) {
        cardList.add(cardList.removeAt(0));
        cardImages.add(cardImages.removeAt(0));
      } else {
        cardList.insert(0, cardList.removeLast());
        cardImages.insert(0, cardImages.removeLast());
      }
      isAnimating = false;
    });
  }

  void _toggleCardView(int index) {
    setState(() {
      cardList[index].isShowCardView = !cardList[index].isShowCardView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      padding: EdgeInsets.zero,
      pageTitle: MyStrings.virtualCard,
      actionButton: [
        GestureDetector(
          onTap: () {
            Get.toNamed(RouteHelper.cardChargesAndFeesScreen);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(width: 1, color: MyColor.unselectedColor),
            ),
            child: Icon(Icons.info_outline, color: MyColor.primary),
          ),
        ),
        GestureDetector(
          onTap: () {
            CustomSnackBar.showToast(message: 'Static preview mode');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(width: 1, color: MyColor.unselectedColor),
            ),
            child: MyAssetImageWidget(
              assetPath: MyIcons.adCard,
              isSvg: true,
              color: MyColor.primary,
              width: 25,
              height: 25,
            ),
          ),
        ),
      ],
      body: Stack(
        children: [
          RefreshIndicator(
            color: MyColor.getPrimaryColor(),
            onRefresh: () async {},
            child: SingleChildScrollView(
              child: Column(
                children: [
                  spaceDown(context.height * .03),
                  Text(
                    MyStrings.cardScreenTitle.tr,
                    style: MyTextStyle.sectionTitle2.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: context.height * .2),
                  GestureDetector(
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity == null) return;
                      if (details.primaryVelocity! < 0) {
                        _onSwipe(true);
                      } else {
                        _onSwipe(false);
                      }
                    },
                    child: SizedBox(
                      height: _cardHeight + _overlap * 2,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: List.generate(cardList.length, (i) {
                          final bool isFront = i == 0;
                          double top = -i * _overlap;
                          double scale = i == 0 ? 1 : (i == 1 ? 0.97 : 0.94);

                          if (isAnimating && isFront) {
                            top = swipeDown ? 80 : -80;
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
                              child: _StaticCardUi(
                                cardModel: cardList[i],
                                currency: currency,
                                cardHeight: _cardHeight,
                                onViewTap: () => _toggleCardView(i),
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
                  Text(
                    MyStrings.cardScreenTitle.tr,
                    style: MyTextStyle.sectionTitle2.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  spaceDown(Dimensions.space10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaticCardUi extends StatelessWidget {
  final double cardHeight;
  final CardModel cardModel;
  final String currency;
  final VoidCallback? onViewTap;

  const _StaticCardUi({
    required this.cardModel,
    required this.currency,
    this.cardHeight = 344,
    this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      width: context.width,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: DecorationImage(
          image: AssetImage(
            cardModel.bgImage != null
                ? "assets/images/card_image/${cardModel.bgImage}"
                : MyImages.imageOne,
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyAssetImageWidget(
                  assetPath: MyIcons.network,
                  isSvg: true,
                  width: 18,
                  height: 24,
                ),
                MyAssetImageWidget(
                  assetPath: MyIcons.visa,
                  width: 76,
                  height: 24,
                  isSvg: true,
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(MyStrings.balance.tr, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 2),
          spaceSide(Dimensions.space10),
          Row(
            children: [
              Text(
                "$currency${cardModel.isShowCardView ? cardModel.balance ?? "" : "•••••••••"}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              spaceSide(Dimensions.space8),
              CustomAppCard(
                onPressed: onViewTap,
                height: Dimensions.space40,
                width: Dimensions.space40,
                showBorder: false,
                radius: Dimensions.radiusProMax,
                backgroundColor: MyColor.black.withValues(alpha: 0.5),
                padding: EdgeInsets.all(Dimensions.space8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Icon(
                    cardModel.isShowCardView
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: MyColor.getWhiteColor(),
                    size: Dimensions.space30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                cardModel.isShowCardView
                    ? MyUtils.addSpaceEvery4(cardModel.cardNumber ?? "")
                    : "••••• ${cardModel.lastFour ?? ""}",
                style: MyTextStyle.sectionTitle.copyWith(
                  color: MyColor.white,
                  fontSize: 18.sp,
                ),
              ),
              spaceSide(Dimensions.space8.w),
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
                  child: MyAssetImageWidget(
                    assetPath: MyIcons.copy,
                    isSvg: true,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MyStrings.cardName.tr,
                      style: MyTextStyle.bodyTextStyle1.copyWith(
                        color: MyColor.white,
                        fontSize: 9.sp,
                      ),
                    ),
                    Text(
                      cardModel.nameOnCard ?? "",
                      style: MyTextStyle.caption2Style.copyWith(
                        color: MyColor.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              spaceSide(Dimensions.space24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MyStrings.expirationDate.tr,
                      style: MyTextStyle.bodyTextStyle1.copyWith(
                        color: MyColor.white,
                        fontSize: 9.sp,
                      ),
                    ),
                    Text(
                      cardModel.isShowCardView ? cardModel.expiry ?? "" : "••/••",
                      style: MyTextStyle.caption2Style.copyWith(
                        color: MyColor.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              spaceSide(Dimensions.space24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MyStrings.cvv.tr,
                      style: MyTextStyle.bodyTextStyle1.copyWith(
                        color: MyColor.white,
                        fontSize: 9.sp,
                      ),
                    ),
                    Text(
                      cardModel.isShowCardView ? cardModel.cvv ?? "" : "•••",
                      style: MyTextStyle.caption2Style.copyWith(
                        color: MyColor.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              MyAssetImageWidget(
                assetPath: MyIcons.chip,
                width: 43,
                height: 33,
                isSvg: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
