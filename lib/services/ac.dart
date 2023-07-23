import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:untitled20/models_localhost/activity.dart';
import 'package:untitled20/models_localhost/mail.dart';
import 'package:untitled20/services/user_service.dart';
import 'package:untitled20/state/state_manager.dart';

import '../models_localhost/api_response.dart';
import '../utils/constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<ApiResponse> getac() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/activities/'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    print('ac: ${response.body} - token: $token');
    switch (response.statusCode) {
      case 200:
        var jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          apiResponse.data = jsonData.map((m) => Activity.fromJson(m)).toList();
        } else {
          // المصفوفة غير موجودة أو ليست من النوع الصحيح
          apiResponse.error = somethingWentWrong;
        }
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print('ac services: ${e.toString()}');
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future createActivity(Activity activity) async {
  try {
    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'body': activity.body,
      'user_id': activity.userId,
      'mail_id': activity.mailId,
      'send_number': activity.sendNumber,
      'send_date': activity.sendDate?.toString(),
      'send_destination': activity.sendDestination,
    };

    // Send the request to create the activity
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/mails/activities/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    // Handle the response
    if (response.statusCode == 200) {
      print('Activity created successfully');
    } else {
      print('Failed to create activity. Error: ${response.body}');
    }
  } catch (e) {
    print('Error creating activity: $e');
  }
}

Future cc(Activity activity) async {
  String token = await getToken();
  var headers = {
    'Authorization': token
  };
  var request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:8000/api/mails/7/activities/'));
  request.fields.addAll({
    'body': 'wesam',
    'user_id': '12',
    'mail_id': '7',
    'send_date': '2023-07-04 17:24:48',
    'send_number': 'send_destination',
    'send_destination': 'hdjncmxm'
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }

}
