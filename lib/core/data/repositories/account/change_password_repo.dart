import 'package:ovopay/core/data/models/global/response_model/response_model.dart';

import '../../../utils/util_exporter.dart';
import '../../services/service_exporter.dart';

class ChangePasswordRepo {
  String token = '', tokenType = '';

  Future<ResponseModel> changePin(
    String currentPin,
    String pin,
  ) async {
    final params = modelToMap(currentPin, pin);
    String url = '${UrlContainer.baseUrl}${UrlContainer.changePinEndPoint}';

    ResponseModel responseModel = await ApiService.postRequest(url, params);
    return responseModel;
  }

  Future<ResponseModel> changePassword(
      String currentPass,
      String password,
      ) async {

    Map<String, dynamic> map = {
      'current_password': currentPass,
      'password': password,
      'password_confirmation': password,
    };

    String url = '${UrlContainer.baseUrl}${UrlContainer.changePasswordEndPoint}';

    ResponseModel responseModel = await ApiService.postRequest(url, map);
    return responseModel;
  }

  Map<String, dynamic> modelToMap(String currentPassword, String newPass) {
    Map<String, dynamic> map2 = {
      'current_pin': currentPassword,
      'pin': newPass,
      'pin_confirmation': newPass,
    };
    return map2;
  }


  Future<ResponseModel> loadUserInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getProfileEndPoint}';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }
}
