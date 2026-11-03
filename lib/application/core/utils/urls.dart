
import 'package:solofy_vendor_app/domain/core/di/env.dart';

class Urls {
  static String baseURL = Env.instance.domainUrl;
  static String apiVersionUrl = '$baseURL/api/';

  // static var apiUrl = '${Env.instance.domainUrl}/api/';

  static const String tokenRefresh = 'token-refresh';
}
