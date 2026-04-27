import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/text/header_text_smaller.dart';
import 'package:ovopay/app/screens/my_qr_code_screen/controller/my_qr_code_controller.dart';
import 'package:ovopay/core/data/models/global/qr_code/scan_qr_code_response_model.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/camera_permission_disclosure.dart';

import '../../../../core/utils/util_exporter.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key, this.scanSubTitle});
  final String? scanSubTitle;

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  final MobileScannerController codeController = MobileScannerController();
  Barcode? _barcode;
  bool isLoadingPage = false;
  bool _isCameraReady = false;
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    Get.put(MyQrCodeController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareCameraPermission();
    });
  }

  Future<void> _prepareCameraPermission() async {
    final PermissionStatus currentStatus = await Permission.camera.status;

    if (currentStatus.isGranted) {
      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
        _isCheckingPermission = false;
      });
      return;
    }

    final PermissionStatus newStatus = await showCameraDisclosureAndRequestPermission(context);
    if (!mounted) return;

    setState(() {
      _isCameraReady = newStatus.isGranted;
      _isCheckingPermission = false;
    });
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      try {
        setState(() async {
          isLoadingPage = true;
          _barcode = barcodes.barcodes.firstOrNull;
          printE(_barcode?.rawValue);
          printW('Barcode found! $_barcode');
          // Stop scanning after a successful scan
          // Navigate or handle the scanned code
          if (_barcode?.rawValue != null) {
            codeController.stop();
            MyQrCodeController controller = Get.find();
            WidgetsBinding.instance.addPostFrameCallback((v) async {
              ScanQrCodeResponseModel data = await controller.scanQrCodeDataFromServer(
                inputText: "${_barcode?.rawValue?.toString()}",
              );
              Get.back(result: data);
            });
            //  isLoadingPage= false;
          }
        });
      } catch (e) {
        printE(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      pageTitle: MyStrings.scanQrCode,
      padding: EdgeInsets.zero,
      body: GetBuilder<MyQrCodeController>(
        builder: (controller) {
          if (_isCheckingPermission) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_isCameraReady) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.space16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      size: Dimensions.space60,
                      color: MyColor.getPrimaryColor(),
                    ),
                    spaceDown(Dimensions.space20),
                    HeaderTextSmaller(
                      text: MyStrings.permissionRequired,
                      textAlign: TextAlign.center,
                      textStyle: MyTextStyle.sectionTitle2.copyWith(
                        color: MyColor.getHeaderTextColor(),
                      ),
                    ),
                    spaceDown(Dimensions.space10),
                    Text(
                      MyStrings.cameraPermissionHelp.tr,
                      textAlign: TextAlign.center,
                      style: MyTextStyle.bodyTextStyle1.copyWith(
                        color: MyColor.getBodyTextColor(),
                      ),
                    ),
                    spaceDown(Dimensions.space20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _prepareCameraPermission,
                        child: Text(MyStrings.retry.tr),
                      ),
                    ),
                    spaceDown(Dimensions.space10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Get.toNamed(RouteHelper.pageContentScreen),
                        child: Text(MyStrings.privacyPolicy.tr),
                      ),
                    ),
                    spaceDown(Dimensions.space10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: openAppSettings,
                        child: Text(MyStrings.openSettings.tr),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return MobileScanner(
            controller: codeController,
            onDetect: _handleBarcode,
            overlayBuilder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  spaceDown(Dimensions.space10),
                  Stack(
                    children: [
                      MyAssetImageWidget(
                        isSvg: true,
                        assetPath: MyIcons.qrCodeBgImage,
                        color: MyColor.getPrimaryColor(),
                        width: (context.width / 1.5).w,
                        height: (context.width / 1.5).w,
                        boxFit: BoxFit.contain,
                      ),
                      if (isLoadingPage)
                        Positioned.fill(
                          child: SpinKitFadingCube(
                            color: MyColor.getPrimaryColor(),
                            size: Dimensions.space50,
                          ),
                        ),
                    ],
                  ),
                  CustomAppCard(
                    margin: EdgeInsetsDirectional.symmetric(
                      horizontal: Dimensions.space16,
                      vertical: Dimensions.space50,
                    ),
                    radius: 0,
                    child: Row(
                      children: [
                        MyAssetImageWidget(
                          isSvg: true,
                          assetPath: MyIcons.scanQrCodeIconIcon,
                          color: MyColor.getPrimaryColor(),
                          width: Dimensions.space24.w,
                          height: Dimensions.space24.h,
                          boxFit: BoxFit.contain,
                        ),
                        spaceSide(Dimensions.space10),
                        Expanded(
                          child: HeaderTextSmaller(
                            text: widget.scanSubTitle ?? MyStrings.scanUserAgentAndMerchantQrQrCode,
                            textStyle: MyTextStyle.sectionTitle3.copyWith(
                              color: MyColor.getPrimaryColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
