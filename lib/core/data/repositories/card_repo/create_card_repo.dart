import '../../../utils/util_exporter.dart';
import '../../models/global/response_model/response_model.dart';
import '../../services/api_service.dart';

class CreateCardRepo {
  Future<ResponseModel> createNewCard() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.createNewCardEndPoint}';
    ResponseModel responseModel = await ApiService.getRequest(url);
    return responseModel;
  }
}
