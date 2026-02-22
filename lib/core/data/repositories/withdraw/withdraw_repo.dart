import '../../../utils/util_exporter.dart';
import '../../models/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class WithdrawRepo {
  Future<ResponseModel> getWithdrawInfo(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.withdrawInfoEndPoint}/$id';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> confirmWithdraw({
    required String pin,
    required String amount,
    required String id,
  }) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.confirmWithdrawEndPoint}/$id?pin=$pin&amount=$amount';
    final response = await ApiService.postRequest(url, {});
    return response;
  }
}
