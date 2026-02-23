import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/screens/choose_card/controller/create_new_card_controller.dart';
import '../../../../../../core/utils/util_exporter.dart';
import '../../../../core/data/services/shared_pref_service.dart';
import '../../../../environment.dart';
import '../../../components/image/my_network_image_widget.dart';
import '../../../components/text-field/rounded_text_field.dart';
import '../../global/views/widgets/country_bottom_sheet.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateNewCardController>(
      builder: (controller) => MyCustomScaffold(
        pageTitle: MyStrings.shippingAddress,
        body: CustomAppCard(
          child: SingleChildScrollView(
            child: Column(
              children: [
                RoundedTextField(
                  labelText: MyStrings.fullName.tr,
                  hintText: MyStrings.enterYourName.tr,
                  controller: controller.fullNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.kNameNullError.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                spaceDown(Dimensions.space16.h),
            
                RoundedTextField(
                  labelText: MyStrings.phoneNumber.tr,
                  hintText: MyStrings.phoneNumber.tr,
                  controller: controller.mobileNumberController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  prefixIcon: IntrinsicWidth(
                    child: InkWell(
                      onTap: () {
                        CountryBottomSheet.countryBottomSheet(
                          context,
                          selectedCountry: controller.countryData,
                          onSelectedData: (v) {
                            controller.selectedCountryData(v);
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsetsDirectional.only(
                          start: Dimensions.space15,
                          end: Dimensions.space8,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyNetworkImageWidget(
                                width: Dimensions.space22.sp,
                                height: Dimensions.space16.sp,
                                boxFit: BoxFit.contain,
                                imageUrl: UrlContainer.countryFlagImageLink.replaceAll(
                                  "{countryCode}",
                                  (controller.countryData?.code ?? Environment.defaultCountryCode).toLowerCase(),
                                ),
                              ),
                              spaceSide(Dimensions.space5),
                              Text(
                                "+${controller.countryData?.dialCode ?? Environment.defaultPhoneDialCode}",
                                style: MyTextStyle.bodyTextStyle2.copyWith(
                                  color: MyColor.getBodyTextColor(),
                                ),
                              ),
                              spaceSide(Dimensions.space8),
                              Container(
                                color: MyColor.getBodyTextColor().withValues(alpha: 0.5),
                                width: 1.2.w,
                                height: Dimensions.space25.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.kPhoneNumberIsRequired.tr;
                    } else if (value.toString().length < SharedPreferenceService.getMaxMobileNumberDigit()) {
                      return '${MyStrings.kPhoneNumberDigitIsRequired.tr} ${SharedPreferenceService.getMaxMobileNumberDigit().toString()}';
                    } else {
                      return null;
                    }
                  },
                ),
            
                spaceDown(Dimensions.space16.h),
            
                RoundedTextField(
                  labelText: MyStrings.address.tr,
                  hintText: MyStrings.enterYourAddress.tr,
                  controller: controller.fullNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.enterYourAddress.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                spaceDown(Dimensions.space16.h),
            
                RoundedTextField(
                  labelText: MyStrings.addressLine2.tr,
                  hintText: MyStrings.enterYourAddress.tr,
                  controller: controller.addressLine2Controller,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.addressLine2.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                spaceDown(Dimensions.space16.h),

                RoundedTextField(
                  onTap: () {
                    CountryBottomSheet.countryBottomSheet(
                      context,
                      selectedCountry: controller.countryData,
                      onSelectedData: (v) {
                        controller.selectedCountryData(v);
                      },
                    );
                  },
                  readOnly: true,
                  labelText: MyStrings.province.tr,
                  hintText: "New york",
                  controller: controller.postalCodeController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.kNameNullError.tr;
                    } else {
                      return null;
                    }
                  },
                ),

                spaceDown(Dimensions.space16.h),

                RoundedTextField(
                  labelText: MyStrings.city.tr,
                  hintText: MyStrings.enterYourCity.tr,
                  controller: controller.cityController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.kNameNullError.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                spaceDown(Dimensions.space16.h),
            
                RoundedTextField(
                  labelText: MyStrings.postalCode.tr,
                  hintText: MyStrings.postalCode.tr,
                  controller: controller.postalCodeController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.kNameNullError.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                spaceDown(Dimensions.space16.h),

                CustomElevatedBtn(text: MyStrings.save, onTap: () {
                  Get.back();
                },)
              ],
            ),
          )
        )
      ),
    );
  }
}
