import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled20/screens/profile.dart';
import 'package:untitled20/services/user_service.dart';

import '../models_localhost/api_response.dart';
import '../utils/constant.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String newPassword = '';
  String confirmPassword = '';
  String responseMessage = '';

  Future<void> changePassword() async {
    int userId = 6; // User ID you want to change password for
    String newPassword = this.newPassword;

    ApiResponse apiResponse = ApiResponse();
    try {
      String token = await getToken();
      final url = Uri.parse('http://127.0.0.1:8000/api/users/$userId/password');
      final response = await http.put(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      }, body: {
        'password': newPassword,
        'password_confirmation': newPassword,
      });

      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body);
          setState(() {
            responseMessage = 'Password changed successfully.';
          });
          break;
        case 401:
          apiResponse.error = unauthorized;
          setState(() {
            responseMessage = 'Unauthorized: Unable to change password.';
          });
          break;
        case 422:
          final errorResponse = jsonDecode(response.body);
          apiResponse.error = errorResponse['errors'].toString();
          setState(() {
            responseMessage = 'Validation errors: ${apiResponse.error}';
          });
          break;
        default:
          apiResponse.error = 'Something went wrong with status code: ${response.statusCode}';
          setState(() {
            responseMessage = 'Something went wrong while changing password.';
          });
          break;
      }
    } catch (e) {
      print('change password error: ${e.toString()}');
      setState(() {
        responseMessage = 'Server error: Unable to change password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Profile()),
            ) ;
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text('Change Password'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  newPassword = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (newPassword.isNotEmpty && newPassword == confirmPassword) {
                  await changePassword();
                } else {
                  setState(() {
                    responseMessage = 'Please enter matching passwords.';
                  });
                }
              },
              child: Text('Change Password'),
            ),
            SizedBox(height: 16.0),
            Text(responseMessage),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChangePasswordScreen(),
  ));
}