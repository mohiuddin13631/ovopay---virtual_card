import 'package:ovopay/core/data/models/auth/sign_up_model/sign_up_model.dart';
import 'package:ovopay/core/data/models/global/response_model/response_model.dart';
import 'package:ovopay/core/data/models/profile_complete/profile_complete_post_model.dart';

import '../../../utils/util_exporter.dart';
import '../../services/service_exporter.dart';

class RegistrationRepo {


  Future<ResponseModel> verifySmsOtp(String code) async {
    final map = {'code': code};
    String url = '${UrlContainer.baseUrl}${UrlContainer.verifySmsEndPoint}';

    ResponseModel responseModel = await ApiService.postRequest(url, map);
    return responseModel;
  }

  Future<ResponseModel> verifyEmailOtp(String code) async {
    final map = {'code': code};
    String url = '${UrlContainer.baseUrl}${UrlContainer.verifyEmailEndPoint}';

    ResponseModel responseModel = await ApiService.postRequest(url, map);
    return responseModel;
  }

  Future<ResponseModel> resendVerifyCode({required bool isEmail}) async {
    final url = '${UrlContainer.baseUrl}${UrlContainer.resendVerifyCodeEndPoint}${isEmail ? 'email' : 'mobile'}';
    ResponseModel response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> registerUser(ProfileCompletePostModel model) async {
    Map<String, dynamic> params = model.toMap();
    String url = '${UrlContainer.baseUrl}${UrlContainer.registrationEndPoint}';
    ResponseModel responseModel = await ApiService.postRequest(url, params);
    return responseModel;
  }

  Future<ResponseModel> sendAuthorizationRequest() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.authorizationCodeEndPoint}';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }
}
