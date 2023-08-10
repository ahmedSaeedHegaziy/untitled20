import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled20/screens/home.dart';

import 'package:untitled20/widgets/buttons.dart';

import '../models_localhost/api_response.dart';
import '../models_localhost/user.dart';
import '../services/hh.dart';
import '../services/user_service.dart';
import '../utils/constant.dart';
import '../widgets/myAppBar.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

ImagePicker picker = ImagePicker();

class ImageStorage {
  static File? image;
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final _picker = ImagePicker();

  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  int userId = 1;
  final _controller = ScrollController();
  String message = 'Loading...';

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        ImageStorage.image = _selectedImage;
        print("image path : $_selectedImage");
      });
    }
  }

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
        txtEmailController.text = user!.email ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      if (!mounted) return;
      showMessage(context, '${response.error}');
    }
  }

  void updateProfile() async {
    ApiResponse response = await updateWithImage(
        txtNameController.text, _selectedImage, txtEmailController.text);
    setState(() {
      loading = false;
    });
    if (response.error == null) {
      if (!mounted) return;
      showMessage(context, '${response.data}');
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      if (!mounted) return;
      showMessage(context, '${response.error}');
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = "$storageUrl/${user?.image}"; // Replace with your image URL

    return Scaffold(
      body: loading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 2,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(message)
          ],
        ),
      )
          : Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: kSize72, left: 40, right: 40),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: getImage,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: _selectedImage != null
                            ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                            : user!.image != ''
                            ? DecorationImage(
                          image: CachedNetworkImageProvider(
                            imageUrl, // Use the imageUrl directly
                          ),
                          fit: BoxFit.cover,
                        )
                            : const DecorationImage(
                          image: AssetImage(
                            'assets/image/avatar@3x.png',
                          ),
                          fit: BoxFit.contain,
                        ),
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: kInputDecoration('Name'),
                        controller: txtNameController,
                        validator: (val) =>
                        val!.isEmpty ? 'Invalid Name' : null,
                      ),
                      TextFormField(
                        decoration: kInputDecoration('Email'),
                        controller: txtEmailController,
                        validator: (val) =>
                        val!.isEmpty ? 'Invalid Email' : null,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        child: Text(
                          "You can change the password: from here".tr(),
                        ),
                      ),
                    ],
                  ),
                ),
                TextBtn(
                  label: 'Update',
                  function: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        message = 'Updating User...';
                      });
                      updateProfile();
                      print('{$storageUrl/${user!.image}}');
                    }
                  },
                ),
              ],
            ),
          ),
          MyAppBar(
            dynamicTitle: false,
            controller: _controller,
            title: 'Update Profile',
            leading: IconButton(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,

              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: kBlack,
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                      (route) => false,
                );              },
            ),
          ),
        ],
      ),
    );
  }
}
