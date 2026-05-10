import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/screens/choose_card/controller/create_new_card_controller.dart';
import 'package:ovopay/core/data/services/service_exporter.dart';
import 'package:ovopay/core/helper/date_converter.dart';
import 'package:ovopay/core/utils/my_strings.dart';

import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../../core/utils/url_container.dart';
import '../../../../../environment.dart';
import '../../../../components/drop_down/my_drop_down_widget.dart';
import '../../../../components/image/my_network_image_widget.dart';
import '../../../../components/text-field/rounded_text_field.dart';
import '../../../global/views/widgets/country_bottom_sheet.dart';

class NewUserSection extends StatelessWidget {
  const NewUserSection({
    super.key,
  });

  List<Widget> _buildAddressRows(CreateNewCardController controller) {
    final fields = <Widget>[
      if (controller.user?.city == null)
        _buildAddressField(
          controller: controller,
          label: MyStrings.city.tr,
          textController: controller.cityController,
          validatorMessage: MyStrings.city.tr,
        ),
      if (controller.user?.state == null)
        _buildAddressField(
          controller: controller,
          label: MyStrings.state.tr,
          textController: controller.stateController,
          validatorMessage: MyStrings.state.tr,
        ),
      if (controller.user?.zip == null)
        _buildAddressField(
          controller: controller,
          label: MyStrings.postalCode.tr,
          textController: controller.zipCodeController,
          validatorMessage: MyStrings.enterYourZipCode.tr,
        ),
      if (controller.user?.address == null)
        _buildAddressField(
          controller: controller,
          label: MyStrings.roadNumber.tr,
          textController: controller.roadNumberController,
          validatorMessage: MyStrings.roadNumber.tr,
        ),
    ];

    final rows = <Widget>[];

    for (var i = 0; i < fields.length; i += 2) {
      final hasSecondField = i + 1 < fields.length;

      rows.add(
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: hasSecondField ? Dimensions.space10.w : 0),
                child: fields[i],
              ),
            ),
            if (hasSecondField)
              Expanded(
                child: fields[i + 1],
              ),
          ],
        ),
      );

      if (hasSecondField || i + 2 < fields.length) {
        rows.add(spaceDown(Dimensions.space25.h));
      }
    }

    return rows;
  }

  Widget _buildAddressField({
    required CreateNewCardController controller,
    required String label,
    required TextEditingController textController,
    required String validatorMessage,
  }) {
    return RoundedTextField(
      readOnly: controller.isExistingUser,
      labelText: label,
      hintText: label,
      controller: textController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.toString().isEmpty) {
          return validatorMessage;
        } else {
          return null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateNewCardController>(
      builder: (controller) => Column(
        children: [

          CustomAppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(MyStrings.cardInformation.tr, style: MyTextStyle.sectionTitle2.copyWith(color: MyColor.headingText)),
                CustomDivider(space: 16,),

                RoundedTextField(
                  labelText: MyStrings.cardName.tr,
                  hintText: MyStrings.enterNameOnCard.tr,
                  controller: controller.carNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.enterNameOnCard.tr;
                    } else {
                      return null;
                    }
                  },
                ),

                spaceDown(Dimensions.space25),
                RoundedTextField(
                  labelText: MyStrings.initialDepositAmount.tr,
                  hintText: "${SharedPreferenceService.getCurrencySymbol()}0.00",
                  controller: controller.initialDepositController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  suffixIcon: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(SharedPreferenceService.getCurrencySymbol(isFullText: true))
                  ),
                  onChanged: (value) {
                    controller.getTotal();
                    controller.update();
                  },
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return MyStrings.initialDepositAmount.tr;
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            )
          ),

          spaceDown(Dimensions.space12.h),

          CustomAppCard(
              onPressed: () {
                controller.updateUserInformation(false);
              },
              padding: EdgeInsetsGeometry.all(Dimensions.space16),
              child: Form(
                key: controller.newCardFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(MyStrings.cardDetails.tr, style: MyTextStyle.sectionTitle2.copyWith(color: MyColor.headingText)),


                    spaceDown(Dimensions.space25),

                    RoundedTextField(
                      readOnly: controller.isExistingUser,
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
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly, // Allow only digits
                        LengthLimitingTextInputFormatter(
                          SharedPreferenceService.getMaxMobileNumberDigit(),
                        ), // Limit to 5 characters
                      ],
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

                    spaceDown(Dimensions.space25),

                    RoundedTextField(
                      readOnly: controller.isExistingUser,
                      labelText: MyStrings.idNumber.tr,
                      hintText: MyStrings.idNumber.tr,
                      controller: controller.idNumberController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return MyStrings.idNumber.tr;
                        } else {
                          return null;
                        }
                      },
                    ),

                    Visibility(visible: !controller.isExistingUser,child: spaceDown(Dimensions.space25)),
                    Visibility(
                      visible: !controller.isExistingUser,
                      child: AppDropdownWidget(
                        items: controller.idTypeList,
                        onItemSelected: (String value) {
                          controller.setIdType(value);
                        },
                        selectedItem: controller.selectedIdType ?? "",
                        child: RoundedTextField(
                          readOnly: true,
                          labelText: MyStrings.idType.tr,
                          hintText: MyStrings.idType.tr,
                          controller: TextEditingController(
                            text: controller.selectedIdType ?? "",
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
                    ),

                    spaceDown(Dimensions.space25.h),

                    RoundedTextField(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((value) {

                          if(value != null){
                            controller.setDob(value);
                            // controller.dobController.text = DateConverter.formatDate(value.toString());

                            controller.update();
                          }

                        },);
                      },
                      readOnly: true,
                      labelText: MyStrings.dateOfBirth.tr,
                      hintText: MyStrings.dateOfBirth.tr,
                      controller: controller.dobController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return MyStrings.dateOfBirth.tr;
                        } else {
                          return null;
                        }
                      },
                    ),

                    spaceDown(Dimensions.space25.h),

                    ..._buildAddressRows(controller),

                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }
}

void _showCupertinoPickerOptions(BuildContext context, String imageType) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: Text(
        MyStrings.selectFiles.tr,
        style: MyTextStyle.sectionTitle.copyWith(
          color: MyColor.getHeaderTextColor(),
        ),
      ),
      message: Text(MyStrings.chooseAnOptionForSelectImageOrFiles.tr),
      actions: [
        CupertinoActionSheetAction(
          child: Text(
            MyStrings.pickImagesFormGallery.tr,
            style: MyTextStyle.sectionTitle3.copyWith(
              color: MyColor.getBodyTextColor(),
            ),
          ),
          onPressed: () async {
            Navigator.of(context).pop();

            if(imageType == "id_card"){
              Get.find<CreateNewCardController>().pickIdCardImage();
            }else{
              Get.find<CreateNewCardController>().pickUserImage();
            }
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          MyStrings.cancel.tr,
          style: MyTextStyle.sectionTitle3.copyWith(
            color: MyColor.getBodyTextColor(),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
  );
}
