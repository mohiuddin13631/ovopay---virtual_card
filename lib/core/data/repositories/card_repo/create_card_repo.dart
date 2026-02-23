import '../../../utils/util_exporter.dart';
import '../../models/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class CreateCardRepo {
  Future<ResponseModel> createNewCardInfo() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.createNewCardEndPoint}';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }

  Future<ResponseModel> createNewCard({required Map<String, dynamic> map}) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.createCardEndPoint}';
    ResponseModel responseModel = await ApiService.postRequest(url, map);
    return responseModel;
  }
}
