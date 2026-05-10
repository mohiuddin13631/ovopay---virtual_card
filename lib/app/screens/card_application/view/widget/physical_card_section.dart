import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/app/screens/choose_card/controller/create_new_card_controller.dart';
import 'package:ovopay/core/utils/my_strings.dart';

import '../../../../../core/route/route.dart';
import '../../../../../core/utils/app_style.dart';
import '../../../../../core/utils/dimensions.dart';
import '../../../../../core/utils/my_color.dart';
import '../../../../../core/utils/text_style.dart';

class PhysicalCardSection extends StatelessWidget {
  const PhysicalCardSection({
    super.key,
    required this.isPhysicalCard,
  });

  final bool isPhysicalCard;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isPhysicalCard,
      child: GetBuilder<CreateNewCardController>(
        builder: (controller) => Column(
          children: [
            CustomAppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyStrings.shippingMethod.tr,
                    style: MyTextStyle.caption1Style.copyWith(
                      color: MyColor.headingText,
                    ),
                  ),
                  spaceDown(13.sp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(controller.shippingMethodList.length, (index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.changeShippingMethod(index);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: MyColor.transparentColor,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      width: controller.selectedShippingMethod == index ? 6 : 1.5,
                                      color: controller.selectedShippingMethod == index
                                          ? MyColor.primary
                                          : MyColor.unselectedColor,
                                    ),
                                  ),
                                ),
                                spaceSide(6.w),
                                Text(
                                  controller.shippingMethodList[index].tr,
                                  style: MyTextStyle.sectionTitle2.copyWith(
                                    color: MyColor.headingText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: index == 0,
                            child: CustomDivider(space: 16),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            spaceDown(Dimensions.space12.h),
            CustomAppCard(
              onPressed: () {
                Get.toNamed(RouteHelper.shippingAddressScreen);
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      MyStrings.shippingAddress.tr,
                      style: MyTextStyle.sectionTitle2.copyWith(
                        color: MyColor.headingText,
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.5, color: MyColor.dark),
                    ),
                    child: Icon(
                      Icons.add,
                      color: MyColor.dark,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
