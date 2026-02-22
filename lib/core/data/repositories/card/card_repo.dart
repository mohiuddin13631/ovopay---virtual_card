import 'package:ovopay/core/data/models/global/response_model/response_model.dart';

import '../../../utils/util_exporter.dart';
import '../../services/service_exporter.dart';

class CardRepo {
  Future<ResponseModel> getCardList({String index = "1"}) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.cardListEndPoint}?page=$index';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> getCardDetails(String id) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.cardDetailsEndPoint}/$id';
    ResponseModel responseModel = await ApiService.postRequest(url, {});
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

  Future<ResponseModel> freezeUnfreezeCard({
    String cardId = "-1",
    bool isFreeze = true,
  }) async {
    String url = '${UrlContainer.baseUrl}${isFreeze ? UrlContainer.freezeCardEndPoint : UrlContainer.unfreezeCardEndPoint}/$cardId';
    final response = await ApiService.postRequest(url, {});
    return response;
  }
}
