import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled20/screens/status_mails.dart';

import '../../utils/constant.dart';
import '../models_localhost/api_response.dart';
import '../models_localhost/mail.dart';
import '../models_localhost/user.dart';
import '../services/user_service.dart';
import 'myGroupList.dart';




class MyGridViw extends StatefulWidget {
  final List<dynamic> statuses;
  final List<Mail> mails; // تعريف المتغير mails هنا




  MyGridViw({Key? key, required this.statuses, required this.mails}) : super(key: key);

  @override
  _MyGridViwState createState() => _MyGridViwState();
}

class _MyGridViwState extends State<MyGridViw> {
  String userData = " ";
  List<Mail> allInbox = []; // قم بإنشاء متغير لتخزين نتيجة getUserData()
  int count = 0; // قم بإضافة متغير لتخزين عدد العناصر في allInbox

  Future<List<Mail>> getUserData() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      var user = response.data as User;
      userData = user.name!; // Update the userData
      print("######${userData}");

      var inbox = widget.mails as List<Mail>;

      allInbox = inbox
          .where((element) => element.subject?.contains(userData) == true)
          .toList();
      print(allInbox);
      count = allInbox.length; // تحديث count لعدد العناصر في allInbox
      print("all : ${allInbox.length}");
      print("count $count");
    }
    return allInbox;
  }

  @override
  Widget build(BuildContext context) {


   return FutureBuilder<List<Mail>>(
      future: getUserData(), // Fetch the data here
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

          return SizedBox(
            height: 450,
            child: GridView.builder(
              itemCount: widget.statuses.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(kSize16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 3 / 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  elevation: 5,
                  color: kWhite,
                  borderRadius: BorderRadius.circular(30),
                  shadowColor: kShadow,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StatusMails(
                          status: widget.statuses[index],
                        ),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.circle,
                                color: Color(int.parse('${widget.statuses[index].color}')),
                              ),
                              Text(
                               "${allInbox.length}",
                                style: TextStyle(
                                  color: kBlack,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          Text(
                            '${widget.statuses[index].name}'.tr(),
                            style: TextStyle(
                              color: kGray50,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return SizedBox(); // Return an empty widget as a fallback
        }
      },
    );

  }
}
