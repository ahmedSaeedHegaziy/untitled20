import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/constant.dart';
import 'mailWidget.dart';
import 'myExpansionTile.dart';

class MyGroupListMails extends StatefulWidget {
  final List<dynamic> mails;
  final bool showCompleted;

  const MyGroupListMails(
      {Key? key,
      required this.mails,
      // required this.categories,
      this.showCompleted = false})
      : super(key: key);

  @override
  State<MyGroupListMails> createState() => _MyGroupListState();
}

class _MyGroupListState extends State<MyGroupListMails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.mails.isNotEmpty
        ? ListView.builder(
            reverse: true,
            primary: false,
            shrinkWrap: true,
            itemCount: widget.mails.length,
            itemBuilder: (context, index) {
              List<Widget> temp = [];
              int count = 0;

              for (var element in widget.mails) {
                if (element.sender?.categoryId == widget.mails[index].id) {
                  if (!widget.showCompleted) {
                    if (element.status?.id! == 4) {
                      continue;
                    }
                  }
                  print(element.subject);
                  temp.add(
                    MailWidget(mail: element),
                  );

                  count++;
                }
              }

              if (count != 0) {
                return MyExpansionTile(
                  textColor: kBlack,
                  title: Text(
                    '${widget.mails[index].name}'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  count: count == 0 ? null : Text('$count'),
                  initiallyExpanded: true,
                  children: temp,
                );
              } else {
                return const SizedBox();
              }
            },
          )
        : const Center(child: Text('There are no mails'));
  }
}
