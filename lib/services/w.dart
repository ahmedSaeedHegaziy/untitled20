import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class YourClassName {
  int userId =6;
  Future<String> getOldPassword(int userId) async {
    String url = 'http://127.0.0.1:8000/api/users/$userId/password';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      String oldPassword = responseData['old_password'];
      return oldPassword;
    } else {
      throw Exception('Failed to retrieve old password.');
    }
  }
}

class YourPageName extends StatefulWidget {
  @override
  _YourPageNameState createState() => _YourPageNameState();
}

class _YourPageNameState extends State<YourPageName> {
  TextEditingController _oldPasswordController = TextEditingController();
  YourClassName className = YourClassName();
  int userId = 1; // تعديلها لتطابق معرّف المستخدم الصحيح

  @override
  void initState() {
    super.initState();
    _fetchOldPassword();
  }

  Future<void> _fetchOldPassword() async {
    try {
      String oldPassword = await className.getOldPassword(userId);
      _oldPasswordController.text = oldPassword;
    } catch (e) {
      // معالجة الخطأ
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          controller: _oldPasswordController,
          enabled: false, // تعطيل إمكانية التحرير
          decoration: InputDecoration(
            labelText: 'Old Password',
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: YourPageName(),
  ));
}
