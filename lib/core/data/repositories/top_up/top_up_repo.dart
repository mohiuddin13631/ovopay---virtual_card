import '../../../utils/util_exporter.dart';
import '../../models/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class TopUpRepo {
  Future<ResponseModel> getTopUpWallet(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getTopUpWalletEndPoint}/$id';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> getTopUpCrypto(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.getTopUpCryptoEndPoint}/$id';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> confirmTopUp({
    required String pin,
    required String amount,
    required String id,
  }) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.confirmTopUpEndPoint}/$id?pin=$pin&amount=$amount';
    final response = await ApiService.postRequest(url, {});
    return response;
  }

  Future<ResponseModel> generateCryptoAddress({
    required String amount,
    required String id,
  }) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.generateCryptoAddressEndPoint}/$id?amount=$amount';
    final response = await ApiService.postRequest(url, {});
    return response;
  }
}
