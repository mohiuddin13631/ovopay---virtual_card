import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/divider/custom_divider.dart';
import 'package:ovopay/core/utils/app_style.dart';
import 'package:ovopay/core/utils/dimensions.dart';
import 'package:ovopay/core/utils/my_strings.dart';
import 'package:ovopay/core/utils/text_style.dart';
class CardChargesAndFeesScreen extends StatefulWidget {
  const CardChargesAndFeesScreen({super.key});

  @override
  State<CardChargesAndFeesScreen> createState() => _CardChargesAndFeesScreenState();
}

class _CardChargesAndFeesScreenState extends State<CardChargesAndFeesScreen> {
  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      pageTitle: MyStrings.cardChargesAndFees,
      body: SingleChildScrollView(
        child: Column(
          children: [
            spaceDown(Dimensions.space12.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(3, (index) {
                return Container(
                  padding: EdgeInsets.only(bottom: Dimensions.space12.h),
                  child: CustomAppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Setup & Monthly Fees", style: MyTextStyle.caption1Style,),
                          spaceDown(Dimensions.space12.h),


                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Creation Fee", style: MyTextStyle.sectionTitle.copyWith(fontSize: Dimensions.space15.sp)),
                                    Text("One-time payment", style: MyTextStyle.caption1Style,),
                                  ],
                                ),
                              ),
                              Text("\$9.00", style: MyTextStyle.sectionTitle,)
                            ],
                          ),



                          CustomDivider(space: 12,),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Creation Fee", style: MyTextStyle.sectionTitle.copyWith(fontSize: Dimensions.space15.sp),),
                                    Text("One-time payment", style: MyTextStyle.caption1Style.copyWith()),
                                  ],
                                ),
                              ),
                              Text("\$9.00", style: MyTextStyle.sectionTitle,)
                            ],
                          ),
                        ],
                      )
                  ),
                );
              },),
            )


          ],
        ),
      ),
    );
  }
}
