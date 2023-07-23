import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled20/models_localhost/api_response.dart';
import 'package:untitled20/models_localhost/status.dart';
import 'package:untitled20/services/user_service.dart';
import 'package:untitled20/utils/constant.dart';

// get all Statuses
Future<ApiResponse> getStatuses(bool withMail) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$statusesURL'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    // print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['statuses']
            .map((m) => Status.fromJson(m))
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
    print('statuses services: ${e.toString()}');
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// get status
Future<ApiResponse> getStatus(bool withMail, int? id) async {
  ApiResponse apiResponse = ApiResponse();
  print('id:$id');
  try {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('$statusesURL/$id?mail=$withMail'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Status.fromJson(jsonDecode(response.body)['status']);
        print("wesam oukal success");
        // apiResponse.data as Status;
        break;
      case 401:
        apiResponse.error = unauthorized;
        print("401");

        break;
      default:
        apiResponse.error = somethingWentWrong;
        print('default');
        break;
    }
  } catch (e) {
    print('status services: ${e.toString()}');
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//get mails status inbox
Future<List<dynamic>> fetchMails() async {
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$mailsURL'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      List<dynamic> mails = jsonDecode(response.body)['mails'];
      List<dynamic> filteredMails =
      mails.where((mail) => mail['status_id'] == 1).toList();
      filteredMails.sort((a, b) => DateTime.parse(b['created_at'])
          .compareTo(DateTime.parse(a['created_at'])));
      return filteredMails;
    } else {
      print('Error fetching mails. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching mails: ${e.toString()}');
  }
  return [];
}
