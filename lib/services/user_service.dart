import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:untitled20/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models_localhost/api_response.dart';
import '../models_localhost/user.dart';


//all users
Future<List<User>> getAllUsers() async {
  List<User> userList = [];
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/users'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['users'];
      userList = data.map<User>((m) => User.fromJson2(m)).toList();
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('user services: ${e.toString()}');
  }
  return userList;
}

//login
Future<ApiResponse> login(String name, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {
        'Accept': 'application/json',
      },
      body: {'name': name, 'password': password},
    );
    print(response.body);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        {
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
        }
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print('user services: ${e.toString()}');
    apiResponse.error = serverError;
  }

  return apiResponse;
}
var x = "";
//register
Future<ApiResponse> register(String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'name': name,
        'email': email,
        'password': password,
        // 'role_id': '3',
        'password_confirmation': password,
      },
    );
    print(response.statusCode);
    print(response.body);
    x = password;
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        var errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//get user details
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));

        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 500:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// // Update user
Future<ApiResponse> updateUser(String name, File? image) async {
  ApiResponse apiResponse = ApiResponse();
  print('in update');
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'name': name,
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (image != null) {
        print('in upload profile');
        await uploadProfileImage(File(image.path));
      }
    }

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }
  return apiResponse;
}

uploadProfileImage(File file) {

}

//get password:



//get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}
//get password
Future<String> getPassword() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('password') ?? '';
}

//get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

//get user role
Future<String> getUserRole() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('userRole') ?? '';
}

//logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

File? getImageFromString(String? base64String, String filePath) {
  if (base64String == null) return null;

  // فك تشفير النص المشفر باستخدام Base64 والحصول على مصفوفة البايتات الأصلية
  List<int> bytes = base64.decode(base64String);

  // إنشاء ملف جديد لحفظ الصورة باستخدام محتوى البايتات
  File imageFile = File(filePath);

  // كتابة المحتوى إلى الملف
  imageFile.writeAsBytesSync(bytes);

  return imageFile;
}
// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}

Future<ApiResponse> updateWithImage(String name, File? file, String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    var request = http.MultipartRequest("POST", Uri.parse('$userURL/update'));
    request.fields.addAll({'name': name});
    request.fields.addAll({'email': email});

    print(request.fields['name']);
    if (file != null) {
      var pic = await http.MultipartFile.fromPath('image', file.path);
      request.files.add(pic);
    } else {
      request.fields['image'] = '';
    }

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var response = await request.send();

//Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(responseString)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//change password
Future<ApiResponse> changePassword(int userId, String newPassword) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final url = Uri.parse('http://127.0.0.1:8000/api/users/$userId/password');
    final response = await http.put(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'new_password': newPassword,
      'password_confirmation': newPassword,
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        print("200");
        break;
      case 401:
        apiResponse.error = unauthorized;
        print("401");
        break;
      case 422:
        final errorResponse = jsonDecode(response.body);
        apiResponse.error = errorResponse['errors'].toString();
        print("Validation errors: ${apiResponse.error}");
        break;
      default:
        apiResponse.error = 'Something went wrong with status code: ${response.statusCode}';
        print(apiResponse.error);

        break;
    }
  } catch (e) {
    print('change password error: ${e.toString()}');
    apiResponse.error = serverError;
  }
  return apiResponse;
}


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
// get all Users
Future<ApiResponse> getUsers() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(usersURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['users']
            .map((m) => User.fromJson2(m))
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
    print('user services: ${e.toString()}');
    apiResponse.error = serverError;
  }
  return apiResponse;
}
