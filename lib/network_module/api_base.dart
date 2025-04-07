import 'package:flutter/foundation.dart';

class APIBase {
  static String baseImageUrl = "https://d2hlypqiuqwyxh.cloudfront.net/";
  static String get baseURL {
  //  return "http://nplflix-api-v1-dev.eba-asmg9uqm.us-east-1.elasticbeanstalk.com/api/";
    return "https://nplflix-api-v1-3.bizalpha.ca/api/";
  }

  static String get clientSecret {
    if (kReleaseMode) {
      return "Production Client Secret";
    } else {
      return "Dev Client Secret";
    }
  }

  static int get clientId {
    return 2;
  }
}
