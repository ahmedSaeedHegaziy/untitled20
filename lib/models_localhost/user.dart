
import 'package:untitled20/models_localhost/role.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? image;
  String? mobile;
  DateTime? emailVerifiedAt;
  String? password;
  int? roleId;
  String? token;
  DateTime? createdAt;
  DateTime? updatedAt;
  Role? role;

  User(
      {this.id,
      this.name,
      this.email,
        this.mobile,
        this.password,
      this.image,
      this.emailVerifiedAt,
      this.roleId,
      this.token,
      this.createdAt,
      this.updatedAt,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['user']['id'];
    name = json['user']['name'];
    mobile = json['user']['mobile'];
    email = json['user']['email'];
    password = json['user']['password'];
    image = json['user']['image'] ?? '';
    emailVerifiedAt =
        DateTime.tryParse(json['user']['email_verified_at'] ?? '');
    roleId = json['user']['role_id'];

    token = json['token'];
    createdAt = DateTime.tryParse(json['user']['created_at']);
    updatedAt = DateTime.tryParse(json['user']['updated_at']);
    role = json['user']['role'] != null
        ? Role.fromJson(json['user']['role'])
        : null;
  }

  User.fromJson2(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    image = json['image'] ?? '';
    emailVerifiedAt = DateTime.tryParse(json['email_verified_at'] ?? '');
    roleId = json['role_id'];

    createdAt = DateTime.tryParse(json['created_at']);
    updatedAt = DateTime.tryParse(json['updated_at']);
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['password'] = password;
    data['image'] = image;
    data['email_verified_at'] = emailVerifiedAt;
    data['role_id'] = roleId;
    data['token'] = token;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    return data;
  }
}
