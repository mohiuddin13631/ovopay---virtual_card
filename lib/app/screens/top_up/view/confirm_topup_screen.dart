import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopay/app/components/card/amount_details_card.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/custom_contact_list_tile_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/column_widget/card_column.dart';
import 'package:ovopay/app/components/dialog/app_dialog.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/image/my_network_image_widget.dart';
import 'package:ovopay/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/screens/top_up/controller/topup_controller.dart';
import 'package:ovopay/core/data/repositories/modules/gift_card/gift_card_repo.dart';
import 'package:ovopay/core/route/route.dart';

import '../../../../../core/data/services/service_exporter.dart';
import '../../../../../core/utils/util_exporter.dart';

class ConfirmTopUpScreen extends StatefulWidget {
  const ConfirmTopUpScreen({super.key});

  @override
  State<ConfirmTopUpScreen> createState() => _ConfirmTopUpScreenState();
}

class _ConfirmTopUpScreenState extends State<ConfirmTopUpScreen> {


  // Reusable Contact List Tile
  Widget _buildContactTile(
      TopUpController controller, {
        bool showBorder = true,
        EdgeInsetsGeometry? padding,
      }) {
    return CustomContactListTileCard(
      leading: MyNetworkImageWidget(
        imageUrl: "https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?semt=ais_hybrid&w=740&q=80",
        width: Dimensions.space50.w,
        height: Dimensions.space50.w,
        boxFit: BoxFit.cover,
        radius: 100,
      ),
      title: "Jacob Jones",
      subtitle: "1234 5678 9123 4567",
      showBorder: showBorder,
      padding: padding ?? EdgeInsets.zero,
    );
  }

  // Reusable Amount Details Card
  Widget _buildAmountDetailsCard(TopUpController controller) {
    return AmountDetailsCard(
      amount: "${controller.currencySymbol}452",
      total: "${controller.currencySymbol}4512",
      firstTitle: MyStrings.amount,
      endTitle: MyStrings.newBalance,
    );
  }

  // Reusable Confirm Dialog
  Future<void> _showConfirmDialog(TopUpController controller) async {
    MyUtils.clearAllTypeFocusNodes();
    if (controller.pinController.text.toString().length < SharedPreferenceService.getMaxPinNumberDigit()) {
      CustomSnackBar.error(
        errorList: [
          MyStrings.kPinMaxNumberError.tr.rKv({
            "digit": "${SharedPreferenceService.getMaxPinNumberDigit()}",
          }).tr,
        ],
      );
      return;
    }
    await AppDialogs.confirmDialog(
      context,
      title: MyStrings.topUp.replaceAll("-", " "),
      userDetailsWidget: CustomAppCard(
        radius: Dimensions.largeRadius.r,
        child: _buildContactTile(controller, showBorder: false),
      ),
      cashDetailsWidget: CustomAppCard(
        radius: Dimensions.largeRadius.r,
        child: _buildAmountDetailsCard(controller),
      ),
      onFinish: () async {
        await controller.pinVerificationProcess(
          onSuccessCallback: (value) async {
            // Handle the completed progress here
            Navigator.pop(context);
            Get.toNamed(RouteHelper.successScreen);
            return;
          },
        );
      },
    );
  }

  @override
  void initState() {
    Get.put(GiftCardRepo());
    Get.put(TopUpController(giftCardRepo: Get.find()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopUpController>(
      builder: (controller) {
        return MyCustomScaffold(
          padding: EdgeInsets.zero,
          pageTitle: MyStrings.confirmTopUp,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.space14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceDown(Dimensions.space16),
                CustomAppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactTile(
                        controller,
                        padding: EdgeInsetsDirectional.only(
                          bottom: Dimensions.space10,
                        ),
                      ),
                      spaceDown(Dimensions.space16),
                      _buildAmountDetailsCard(controller),
                    ],
                  ),
                ),
                spaceDown(Dimensions.space16),
                RoundedTextField(
                  showLabelText: false,
                  controller: controller.pinController,
                  labelText: MyStrings.pin,
                  hintText: MyStrings.enterYourPinCode,
                  isPassword: true,
                  forceShowSuffixDesign: true,
                  fillColor: MyColor.getWhiteColor(),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                      SharedPreferenceService.getMaxPinNumberDigit(),
                    ),
                  ],
                  prefixIcon: Container(
                    margin: const EdgeInsetsDirectional.only(
                      start: Dimensions.space15,
                      end: Dimensions.space8,
                    ),
                    child: MyAssetImageWidget(
                      color: MyColor.getPrimaryColor(),
                      width: 22.sp,
                      height: 16.sp,
                      boxFit: BoxFit.contain,
                      assetPath: MyIcons.lock,
                      isSvg: true,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => _showConfirmDialog(controller),
                    icon: MyAssetImageWidget(
                      color: MyColor.getPrimaryColor(),
                      width: 20.sp,
                      height: 20.sp,
                      boxFit: BoxFit.contain,
                      assetPath: MyIcons.arrowForward,
                      isSvg: true,
                    ),
                  ),
                ),
                spaceDown(Dimensions.space15),
                AppMainSubmitButton(
                  text: MyStrings.confirm,
                  onTap: () {
                    _showConfirmDialog(controller);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
