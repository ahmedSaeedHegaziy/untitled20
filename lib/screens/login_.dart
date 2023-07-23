import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:untitled20/models_localhost/api_response.dart';
import 'package:untitled20/models_localhost/user.dart';
import 'package:untitled20/screens/home.dart';
import 'package:untitled20/widgets/buttons.dart';
import 'package:untitled20/widgets/myAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user_service.dart';
import '../utils/constant.dart';
import 'guest.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = ScrollController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(
      _emailController.text,
      _passwordController.text,
    );
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
      return;
    }
    if (!mounted) return;
    setState(() {
      loading = false;
    });
    showMessage(context, '${response.error}');
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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -200,
            child: Container(
              height: 500,
              width: 500,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: kPrimaryGradient,
              ),
            ),
          ),
          Positioned(
            top: 70,
            child: Image(
              width: 100,
              image: AssetImage('assets/image/logo_app3.png'),
            ),
          ),
          SingleChildScrollView(
            controller: _controller,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  margin: const EdgeInsets.all(kSize16),
                  padding: const EdgeInsets.symmetric(
                      vertical: kSize64, horizontal: kSize56),
                  decoration: const BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.all(Radius.circular(60))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: kSize56),
                      LoginSignUpForm(
                        loading: loading,
                        function: () {
                          setState(() {
                            loading = true;
                            _loginUser();
                          });
                        },
                        emailController: _emailController,
                        passwordController: _passwordController,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          MyAppBar(controller: _controller, title: 'Login'.tr())
        ],
      ),
    );
  }
}

class LoginSignUpForm extends StatelessWidget {
  final Function()? function;
  final bool loading;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginSignUpForm({
    Key? key,
    required this.function,
    required this.loading,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text("Login".tr() , style: TextStyle(color: Colors.blueAccent , fontSize: 28)),

          SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: emailController,
            decoration: kInputDecoration('Enter UserName'.tr()),
          ),
          SizedBox(height: kSize24),
          TextFormField(
            controller: passwordController,
            decoration: kInputDecoration('Password'.tr()),
            obscureText: true,
            validator: (val) =>
            val!.length < 6 ? 'Required at least 6 chars'.tr() : null,
          ),
          SizedBox(height: kSize24),

          Row(
            children: [
              LoginBtn(
                loading: loading,
                label: 'Login'.tr(),
                colored: false,
                function: () {
                  function!();
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}
