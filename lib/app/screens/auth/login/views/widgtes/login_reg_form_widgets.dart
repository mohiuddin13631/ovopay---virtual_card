import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/text/default_text.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/screens/auth/login/controller/login_controller.dart';

import '../../../../../../core/utils/util_exporter.dart';

class LoginRegFormsWidgets extends StatelessWidget {
  const LoginRegFormsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Column(
          children: [
            RoundedTextField(
              controller: controller.usernameEmailController,
              labelText: MyStrings.emailOrUsername.tr,
              hintText: MyStrings.enterYourUsername.tr,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value.toString().trim().isEmpty) {
                  return MyStrings.kUsernameIsRequired.tr;
                } else {
                  return null;
                }
              },
            ),
            spaceDown(Dimensions.space24),
            RoundedTextField(
              controller: controller.pinController,
              labelText: MyStrings.password.tr,
              hintText: MyStrings.enterYourPassword.tr,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              isPassword: true,
              validator: (value) {
                if (value.toString().trim().isEmpty) {
                  return MyStrings.kPasswordIsRequired.tr;
                } else {
                  return null;
                }
              },
            ),
            spaceDown(Dimensions.space12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    MyUtils.clearAllTypeFocusNodes();
                    controller.forgetPassword();
                  },
                  child: DefaultText(
                    text: MyStrings.forgetPassword.tr,
                    textStyle: MyTextStyle.sectionSubTitle1.copyWith(
                      color: MyColor.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
