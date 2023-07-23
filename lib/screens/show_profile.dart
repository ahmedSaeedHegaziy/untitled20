import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bcrypt/bcrypt.dart';

import '../models_localhost/api_response.dart';
import '../models_localhost/user.dart';
import '../services/hh.dart';
import '../services/user_service.dart';
import '../utils/constant.dart';
import '../widgets/myAppBar.dart';
import 'login.dart';


ImagePicker picker = ImagePicker();
class ImageStorage {
  static File? image;
}
class ShowProfile extends StatefulWidget {

  const ShowProfile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ShowProfile> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();
  // بيانات الصورة هنا

  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  TextEditingController txtRoleController = TextEditingController();

  final _controller = ScrollController();
  String message = 'Loading...';
  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    // final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        ImageStorage.image = File(pickedFile.path);
        _imageFile = File(pickedFile.path);
        print("image path : $_imageFile");
      });
    }
  }

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
        txtEmailController.text = user!.email ?? '';
        txtRoleController.text = user!.role!.name ?? '';

        print(user?.image);
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


  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          : Stack(children: [
        Padding(
          padding: EdgeInsets.only(top: kSize72, left: 40, right: 40),
          child: ListView(
            children: [
              Center(
                  child: GestureDetector(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: _imageFile == null
                              ? user!.image != ''
                              ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                  '$storageUrl/${user!.image}'),
                              fit: BoxFit.cover)
                              : const DecorationImage(
                              image: AssetImage(
                                  'assets/image/avatar@3x.png'),
                              fit: BoxFit.contain)
                              : DecorationImage(
                              image: FileImage(_imageFile ?? File('')),
                              fit: BoxFit.cover),
                          color: Colors.amber),
                    ),
                    onTap: () {
                      getImage();
                    },
                  )),
              SizedBox(
                height: 20,
              ),

              Form(

                key: formKey,
                child: Column(

                  children: [
                    TextFormField(
                      enabled: false,
                      decoration: kInputDecoration('Name'),
                      controller: txtNameController,
                      validator: (val) =>
                      val!.isEmpty ? 'Invalid Name' : null,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      enabled: false,
                      decoration: kInputDecoration('Email'),
                      controller: txtEmailController,
                      validator: (val) =>
                      val!.isEmpty ? 'Invalid email' : null,
                    ),
                    SizedBox(height: 15),

                    TextFormField(

                      enabled: false,
                      decoration: kInputDecoration('Role'),
                      controller: txtRoleController,
                      validator: (val) =>
                      val!.isEmpty ? 'Invalid Role' : null,
                    ),
                    SizedBox(height: 15  ),


                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

            ],
          ),
        ),
        MyAppBar(
          dynamicTitle: false,
          controller: _controller,
          title: 'Profile',
          leading: IconButton(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: kBlack,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ]),
    );
  }
}
