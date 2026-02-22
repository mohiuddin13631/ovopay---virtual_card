import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/screens/card_details/view/contorller/card_details_controller.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/my_strings.dart';
import 'package:ovopay/core/utils/text_style.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/my_color.dart';
import '../widget/physical_card_section.dart';
import '../widget/virtual_card_section.dart';

class ChooseCardScreen extends StatefulWidget {
  const ChooseCardScreen({super.key});

  @override
  State<ChooseCardScreen> createState() => _ChooseCardScreenState();
}

class _ChooseCardScreenState extends State<ChooseCardScreen> with SingleTickerProviderStateMixin {

  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardDetailsController>(
      builder: (controller) => MyCustomScaffold(
        pageTitle: MyStrings.chooseCard,
        body: Column(
          children: [

            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: MyColor.white,
                  borderRadius: BorderRadius.circular(Dimensions.space50),
              ),
              child: TabBar(
                  controller: _controller,
                  dividerColor: MyColor.getTransparentColor(),
                  indicatorColor: MyColor.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    return states.contains(WidgetState.focused) ? null : Colors.transparent;
                  }),
                  unselectedLabelStyle: MyTextStyle.sectionTitle3.copyWith(color: MyColor.bodyText),
                  labelStyle: MyTextStyle.sectionTitle3.copyWith(color: MyColor.bodyText),
                  indicator: BoxDecoration(
                    color: MyColor.primary,
                    borderRadius: BorderRadius.circular(100)
                  ),
                  labelColor: MyColor.white,
                  unselectedLabelColor: MyColor.dark,
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                  padding: EdgeInsets.all(0),
                  onFocusChange: (value, index) {},
                  tabs: [
                Tab(text: MyStrings.virtualCard.tr,),
                Tab(text: MyStrings.physicalCard.tr),
              ]),
            ),

            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  VirtualCardSection(),
                  PhysicalCardSection(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.all(Dimensions.space16),
            child: CustomElevatedBtn(
              text: "${MyStrings.applyForCard.tr} - ${_controller.index == 0 ? controller.chargeSetting?.creationFee ?? "" : ""}",
              onTap: () {
                Get.toNamed(RouteHelper.cardApplicationScreen, arguments: _controller.index == 1 ? true : false);
              },
            ),
          ),
        ),
      ),
    );
  }
}


