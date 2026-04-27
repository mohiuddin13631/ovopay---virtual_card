import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/util_exporter.dart';

Future<PermissionStatus> showCameraDisclosureAndRequestPermission(
  BuildContext context,
) async {
  final bool? shouldContinue = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(MyStrings.cameraAccessTitle.tr),
        content: Text(MyStrings.cameraAccessBody.tr),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
              Get.toNamed(RouteHelper.pageContentScreen);
            },
            child: Text(MyStrings.privacyPolicy.tr),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(MyStrings.notNow.tr),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(MyStrings.continueText.tr),
          ),
        ],
      );
    },
  );

  if (shouldContinue != true) {
    return PermissionStatus.denied;
  }

  return Permission.camera.request();
}
