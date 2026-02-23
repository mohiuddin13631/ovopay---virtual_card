import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/util_exporter.dart';
import '../../../../components/divider/custom_divider.dart';
class ChargesCard extends StatelessWidget {

  final String title;
  final String value;
  final bool isShowDivider;

  const ChargesCard({super.key, required this.title, required this.value, this.isShowDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.tr, style: MyTextStyle.sectionTitle.copyWith(fontSize: Dimensions.space15.sp)),
                ],
              ),
            ),
            Text(value, style: MyTextStyle.sectionTitle,)
          ],
        ),

        Visibility(visible: isShowDivider,child: CustomDivider(space: 12,)),
      ],
    );
  }
}
