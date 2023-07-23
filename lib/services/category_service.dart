import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:untitled20/services/user_service.dart';
import 'package:untitled20/utils/constant.dart';

import '../models_localhost/api_response.dart';
import '../models_localhost/category.dart';

// get all categories
Future<ApiResponse> getCategories() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(categoriesURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['categories']
            .map((m) => MailCategory.fromJson(m))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print('category services: ${e.toString()}');
    apiResponse.error = serverError;
  }
  return apiResponse;
}
