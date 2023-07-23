import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled20/screens/status_mails.dart';
import 'package:untitled20/screens/status_mailsAdmin.dart';

import '../../utils/constant.dart';

class MyGridViwAdmin extends StatelessWidget {
  final List<dynamic> statuses;
  const MyGridViwAdmin({Key? key, required this.statuses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      // color: Colors.green,
      child: GridView.builder(
        itemCount: statuses.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(kSize16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          childAspectRatio: 3/ 1,
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
                    builder: (context) => StatusMailsAdmin(
                          status: statuses[index],
                        )));
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
                          color: Color(int.parse('${statuses[index].color}')),
                        ),
                        Text(
                          '${statuses[index].mailsCount}',
                          style: TextStyle(
                              color: kBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Text(
                      '${statuses[index].name}'.tr(),
                      style: TextStyle(
                          color: kGray50,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
