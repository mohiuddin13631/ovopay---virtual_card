import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/screens/card_details/view/contorller/card_details_controller.dart';
import 'package:ovopay/core/data/services/service_exporter.dart';
import '../../../../../core/utils/util_exporter.dart';
import '../../../../components/drop_down/my_drop_down_widget.dart';
import '../../../../components/text-field/rounded_text_field.dart';

class FreezeCardBottomSheet {
  static void freezeCardBottomSheet(BuildContext context) {
    CustomBottomSheetPlus(
      isNeedAnimatedPadding: false,
      isNeedPadding: false,
      child: SafeArea(
        child: Builder(
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return GetBuilder<CardDetailsController>(
                  builder: (controller) => Container(
                    height: MediaQuery.of(context).size.height * .87,
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
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.space16, vertical: Dimensions.space12),
                          decoration: BoxDecoration(
                            color: MyColor.naturalLight.withValues(alpha: .2),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(MyStrings.freezeCard.tr, style: MyTextStyle.sectionTitle3,),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Icons.cancel_outlined, size: 26, color: MyColor.naturalLight)
                              ),

                            ],
                          ),
                        ),

                        spaceDown(Dimensions.space16.h),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsetsGeometry.all(11),
                                  decoration: BoxDecoration(
                                    color: MyColor.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: MyAssetImageWidget(assetPath: MyIcons.lock, isSvg: true, color: MyColor.white, width: 17, height: 17,),
                                ),

                                spaceDown(Dimensions.space8.h),

                                Text(MyStrings.freezeCardConfirmation.tr, style: MyTextStyle.sectionSubTitle1.copyWith(color: MyColor.bodyText),textAlign: TextAlign.center),
                                spaceDown(Dimensions.space15.h),

                                CustomAppCard(
                                    padding: EdgeInsetsGeometry.all(Dimensions.space15),
                                    radius: 12,
                                    borderColor: MyColor.warning,
                                    borderWidth: 1,
                                    backgroundColor: MyColor.warning.withValues(alpha: .1),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(MyStrings.afterFreezing.tr, style: MyTextStyle.sectionTitle.copyWith(color: MyColor.black, fontSize: Dimensions.space14.sp)),
                                        spaceDown(Dimensions.space12.h),
                                        RowItem(
                                          title: MyStrings.allTransactionWillBeBlocked.tr,
                                          icon: MyIcons.warning,
                                        ),
                                        RowItem(
                                          title: MyStrings.pendingPaymentsMayFail.tr,
                                          icon: MyIcons.warning,
                                        ),
                                        RowItem(
                                          title: MyStrings.subscriptionsWillbePaused.tr,
                                          icon: MyIcons.warning,
                                        ),
                                        RowItem(
                                          title: "${MyStrings.aFeeOf.tr} ${SharedPreferenceService.getCurrencySymbol()}${0.05} ${MyStrings.willBeCharged.tr}",
                                          icon: MyIcons.warning,
                                        ),

                                        RowItem(
                                          title: MyStrings.yourBalanceRemainsSafe.tr,
                                          icon: MyIcons.checkOutline,
                                          isShowSpace: false,
                                          iconColor: MyColor.success,
                                        ),
                                      ],
                                    )
                                ),

                                spaceDown(Dimensions.space24.h),

                                Text(MyStrings.reasonForFreezing.tr, style: MyTextStyle.caption1Style.copyWith(fontSize: Dimensions.space16.sp)),

                                spaceDown(Dimensions.space18.h),


                                AppDropdownWidget(
                                  items: controller.freezingReasonList,
                                  onItemSelected: (String value) {
                                    controller.setFreezingReason(value);
                                  },
                                  selectedItem: controller.selectedFreezingReason,
                                  child: RoundedTextField(
                                    readOnly: true,
                                    showLabelText: false,
                                    labelText: MyStrings.priority.tr,
                                    hintText: "",
                                    controller: TextEditingController(
                                      text: controller.selectedFreezingReason,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.phone,
                                    onTap: () {},
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: MyColor.getDarkColor(),
                                    ),
                                  ),
                                ),

                                spaceDown(Dimensions.space16.h),

                                CustomAppCard(
                                  borderColor: MyColor.primary,
                                  borderWidth: 1,
                                  backgroundColor: MyColor.primary.withValues(alpha: .1),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.info_outline, color: MyColor.primary, size: 20,),

                                          spaceSide(Dimensions.space3.w),

                                          Text(MyStrings.importantInformation.tr, style: MyTextStyle.sectionTitle3.copyWith(color:MyColor.headingText),)
                                        ],
                                      ),

                                      spaceDown(Dimensions.space4),

                                      Row(
                                        children: [
                                          SizedBox(height: 20, width: 25,),
                                          Expanded(child: Text("You can unfreeze your card instantly at any time. Your balance and card details remain unchanged.", style: MyTextStyle.caption1Style.copyWith(color: MyColor.bodyText),))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                spaceDown(Dimensions.space24.h),

                                CustomElevatedBtn(
                                  isLoading: controller.isSubmitLoading,
                                  text: controller.cardModel.freezingReason == null ? MyStrings.freezeCard : MyStrings.unfreezeCard, onTap: () {
                                  controller.freezeUnfreezeCard();
                                },)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

class RowItem extends StatelessWidget {

  final String title;
  final String icon;
  final bool isShowSpace;
  final Color iconColor;

  const RowItem({
    super.key,
    required this.title,
    required this.icon,
    this.isShowSpace = true,
    this.iconColor = MyColor.warning
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            MyAssetImageWidget(assetPath: icon, isSvg: true, width: 20, height: 20, color: iconColor),
            spaceSide(Dimensions.space8.w),
            Text(title.tr, style: MyTextStyle.sectionTitle3.copyWith(color: MyColor.bodyText, fontWeight: FontWeight.w400)),
          ],
        ),
        Visibility(visible:isShowSpace, child: spaceDown(Dimensions.space12.h)),
      ],
    );
  }
}
