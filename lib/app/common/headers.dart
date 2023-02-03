const String OPEN_AI_KEY = 'sk-xxxx';

const String baseURL = "https://api.openai.com/v1";

String endPoint(String endPoint) => "$baseURL/$endPoint";

Map<String, String> headerBearerOption(String token) => {
      "Content-Type": "application/json; charset=utf-8",
      'Authorization': 'Bearer $token',
      "Accept-Charset": "application/json; charset=utf-8"
    };

enum ApiState { loading, success, error, notFound }
