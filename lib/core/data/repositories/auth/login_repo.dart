import 'package:ovopay/core/data/models/global/response_model/response_model.dart';

import '../../../utils/util_exporter.dart';
import '../../services/service_exporter.dart';

class LoginRepo {
  Future<ResponseModel> loginUser(
    String countryCode,
    String mobile,
    String pin,
  ) async {
    Map<String, String> map = {
      // 'country': countryCode,
      'username': mobile,
      'password': pin,
    };
    String url = '${UrlContainer.baseUrl}${UrlContainer.loginEndPoint}';
    final response = await ApiService.postRequest(url, map);
    return response;
  }

  Future<ResponseModel> registerUser(String countryCode, String mobile) async {
    Map<String, String> map = {'country': countryCode, 'mobile_number': mobile};
    String url = '${UrlContainer.baseUrl}${UrlContainer.registrationEndPoint}';
    final response = await ApiService.postRequest(url, map);
    return response;
  }

  Future<ResponseModel> forgetPassword(String type, String value) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.forgetPasswordEndPoint}';
    final response = await ApiService.postRequest(url, {
      'type': type, 'value': value,
    });

    return response;
  }

  Future<ResponseModel> verifyForgetPassCode(
    String code,
    String email,
  ) async {
    Map<String, String> map = {'code': code, 'email': email};

    String url = '${UrlContainer.baseUrl}${UrlContainer.passwordVerifyEndPoint}';

    final response = await ApiService.postRequest(url, map);

    return response;
  }

  Future<ResponseModel> resetPassword(
    String email,
    String pin,
    String cPin,
    String code,
  ) async {
    Map<String, String> map = {
      'token': code,
      'email': email,
      'password': pin,
      'password_confirmation': cPin,
    };

    String url = '${UrlContainer.baseUrl}${UrlContainer.resetPasswordEndPoint}';

    ResponseModel responseModel = await ApiService.postRequest(url, map);

    return responseModel;
  }

  Future<ResponseModel> sendAuthorizationRequest() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.authorizationCodeEndPoint}';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }
}
