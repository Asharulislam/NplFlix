import '../enums/index.dart';
import '../models/login_model.dart';
import '../network_module/api_path.dart';
import '../network_module/http_client.dart';
import '../sources/shared_preferences.dart';

class LoginRepository {
  Future<LoginModel> postLogin(payload) async {
    final response = await HttpClient.instance
        .postData(APIPathHelper.getValue(APIPath.login), payload);

    SharedPreferenceManager.sharedInstance.storeToken(response['token']);
    return LoginModel.fromJson(response);
  }
}
