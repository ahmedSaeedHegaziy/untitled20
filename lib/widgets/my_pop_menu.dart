import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/login_.dart';
import '../screens/show_profile.dart';
import '../services/user_service.dart';
import '../state/state_manager.dart';
import '../utils/constant.dart';

class MyPopMenu extends StatelessWidget {
  const MyPopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final futureUser = ref.watch(userStateFuture);
      return futureUser.when(
        data: (user) {
          return PopupMenuButton<String>(
            onSelected: (result) {
              if (result == 'profile') {
                Navigator.of(context).push(MaterialPageRoute(
                  settings: const RouteSettings(name: "/Profile"),
                  builder: (context) =>  ShowProfile(),
                )).then((value) => ref.refresh(userStateFuture));
              }
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            icon: user.image == ''
                ? CircleAvatar(
              radius: kSize48, // تغيير حجم الصورة في الـ PopupMenuButton
              backgroundImage: CachedNetworkImageProvider(
                '$storageUrl/${user.image!}',
              ),
            )
                : const CircleAvatar(
              radius: kSize48, // تغيير حجم الصورة في الـ PopupMenuButton
              backgroundImage: AssetImage('assets/image/avatar@3x.png'),
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                padding: EdgeInsets.all(0),
                value: 'profile'.tr(),
                enabled: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: kSize16,
                    horizontal: 16,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        user.image!= ''
                            ? CircleAvatar(
                          radius: 70, // تغيير حجم الصورة في PopupMenuItem
                          backgroundImage:
                          CachedNetworkImageProvider(
                              'assets/image/avatar@3x.png'),
                        )
                            : const CircleAvatar(
                          radius: kSize48, // تغيير حجم الصورة في PopupMenuItem
                          backgroundImage:
                          AssetImage('assets/image/avatar.png'),
                        ),
                        SizedBox(
                          height: kSize8,
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            user.name ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: kSize8,
                        ),
                        Text(
                          '${user.role?.name}'.tr(),
                          style: TextStyle(color: kGray70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                padding: EdgeInsets.all(0),
                value: 'Profile',
                child: ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.person_outline_rounded,
                    color: kGray70,
                  ),
                  title: Text(
                    'Profile'.tr(),
                    style: TextStyle(color: kGray70),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      settings: const RouteSettings(name: "/Profile"),
                      builder: (context) => const ShowProfile(),
                    )).then((value) => ref.refresh(userStateFuture));
                  },
                ),
              ),
              const PopupMenuItem<String>(
                enabled: false,
                padding: EdgeInsets.all(0),
                height: 0,
                value: 'divider',
                child: Divider(
                  indent: 16,
                ),
              ),
              PopupMenuItem<String>(
                padding: EdgeInsets.all(0),
                value: 'lang',
                child: ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.language,
                    color: kGray70,
                  ),
                  title: Text(
                    context.locale.languageCode == 'ar' ? 'en'.tr() : 'ar'.tr(),
                    style: TextStyle(color: kGray70),
                  ),
                  onTap: () {
                    context.locale.languageCode == 'en'
                        ? context.setLocale(const Locale('ar', 'SA'))
                        : context.setLocale(const Locale('en', 'US'));

                    logout().then((value) => Navigator.of(context)
                        .pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                            (route) => false));
                  },
                ),
              ),
              PopupMenuItem<String>(
                padding: EdgeInsets.all(0),
                value: 'Logout',
                child: ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.exit_to_app_outlined,
                    color: kGray70,
                  ),
                  title: Text(
                    'Logout'.tr(),
                    style: TextStyle(color: kGray70),
                  ),
                  onTap: () async {
                    logout().then((value) => Navigator.of(context)
                        .pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                            (route) => false));
                  },
                ),
              ),
            ],
          );
        },
        error: (e, stack) {
          return Center(
            child: Text(
              e.toString(),
            ),
          );
        },
        loading: () => Center(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            height: 24,
            width: 24,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    });
  }
}
