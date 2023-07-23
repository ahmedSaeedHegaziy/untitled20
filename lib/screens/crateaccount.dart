import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models_localhost/api_response.dart';
import '../models_localhost/user.dart';
import '../services/user_service.dart';
import '../utils/constant.dart';
import 'guest.dart';
import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
  TextEditingController();
  bool loading = false;

  void _registerUser() async {
    ApiResponse response = await register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
      return;
    } else {
      if (!mounted) return;
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    await pref.setString('userRole', user.role?.name ?? '');

    if (!mounted) return;
    if (user.role?.name == 'guest') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              settings: const RouteSettings(name: "/Guest"),
              builder: (context) => const Guest()),
              (route) => false);
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            settings: const RouteSettings(name: "/Home"),
            builder: (context) => Home()),
            (route) => false);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            settings: const RouteSettings(name: "/Home"),
            builder: (context) => Home()),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    backgroundColor: kBackground, // Replace kBackground with your desired background color
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -200,
            child: Container(
              height: 500,
              width: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: kPrimaryGradient, // Replace kPrimaryGradient with your desired gradient
              ),
            ),
          ),
          Positioned(
            top: 70,
            child: Image(
              width: 100,
              image: AssetImage('assets/image/logo_app3.png'), // Replace 'assets/image/logo_app3.png' with your desired image
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  margin: EdgeInsets.all(kSize16), // Replace kSize16 with your desired margin
                  padding: EdgeInsets.symmetric(
                      vertical: kSize64, horizontal: kSize56), // Replace kSize64 and kSize56 with your desired padding
                  decoration: BoxDecoration(
                    color: kWhite, // Replace kWhite with your desired color
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Implement your UI widgets for the register screen here
                      // Use the provided TextEditingController for capturing user input
                      Text("Add User".tr(), style: TextStyle(fontSize: 28 , color: Colors.blueAccent),),
                      SizedBox(height:
                        kSize24),
                      // Example UI code:
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name'.tr(),
                        ),
                      ),
                      SizedBox(height: kSize24), // Replace kSize24 with your desired height
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email'.tr(),
                        ),
                      ),
                      SizedBox(height: kSize24), // Replace kSize24 with your desired height
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password'.tr(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: kSize24), // Replace kSize24 with your desired height
                      TextFormField(
                        controller: _passwordConfirmController,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password'.tr(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: kSize56), // Replace kSize56 with your desired height
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            loading = true;
                            _registerUser();

                          });
                        },
                          style: ElevatedButton.styleFrom(primary: Color(0xff003afc)),

                          child: Text('Add User'.tr()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
