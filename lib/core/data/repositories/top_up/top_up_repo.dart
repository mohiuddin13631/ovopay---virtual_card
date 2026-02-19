import '../../../utils/util_exporter.dart';
import '../../models/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class TopUpRepo {
  Future<ResponseModel> getTopUpWallet(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getTopUpWalletEndPoint}/$id';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> pinVerificationRequest({
    String pin = "",
    String cardId = "-1",
  }) async {
    Map<String, String> params = {'pin': pin};
    String url = '${UrlContainer.baseUrl}${UrlContainer.pinVerifyEndPoint}/$cardId';
    final response = await ApiService.postRequest(url, params);
    return response;
  }
}
