import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/constant.dart';
import '../models_localhost/api_response.dart';
import '../models_localhost/mail.dart';
import '../models_localhost/user.dart';
import '../services/user_service.dart';
import 'mailWidget.dart';
import 'myExpansionTile.dart';
int count = 0;
List<Mail> allInprogress = [];

class MyGroupListInprogress extends StatefulWidget {

  final List<dynamic> mails;
  final List<dynamic> categories;
  final bool showCompleted;
  const MyGroupListInprogress(
      {Key? key,
        required this.mails,
        required this.categories,
        this.showCompleted = false})
      : super(key: key);

  @override
  State<MyGroupListInprogress> createState() => _MyGroupListState();
}

class _MyGroupListState extends State<MyGroupListInprogress> {
  String userData = " ";

  @override
  void initState() {
    getUserData();
    super.initState();
  }
  Future<List<Mail>> getUserData() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      var user = response.data as User;
      userData = user.name!; // Update the userData
      print("######${userData}");
      var inbox = widget.mails as List<Mail>;
      allInprogress = inbox
          .where((element) => element.subject?.contains(userData) == true)
          .toList();
      count = allInprogress.length; // Update the count value
      print("all : ${allInprogress.length}");
      count = allInprogress.length;
      print("count $count");
    }
    return allInprogress;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Mail>>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error fetching data.'),
          );
        } else if (snapshot.hasData) {
          List<Mail> allInbox = snapshot.data!;
          List<Widget> temp = [];

          for (var element in allInbox) {
            temp.add(MailWidget(mail: element));
          }

          return count != 0
              ? MyExpansionTile(
            textColor: Colors.black,
            title: Text(
              'ِAll Mails'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            count: count == 0 ? null : Text('$count'),
            initiallyExpanded: true,
            children: temp,
          )
              : SizedBox();
        } else {
          return SizedBox();
        }
      },
    );
  }
}

