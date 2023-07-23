import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models_localhost/status.dart';
import '../services/user_service.dart';
import '../utils/constant.dart';
import '../widgets/myExpansionTile.dart';
import 'status_selector.dart';

final userRoleStateFuture = FutureProvider.autoDispose<String>((ref) async {
  String role = await getUserRole();
  return role;
});
Status status = Status(id: 1, name: 'Inbox', color: '0xfffa3a57');




class MyWidget extends ConsumerWidget  {
  ValueNotifier<Status> statusNotifier = ValueNotifier(Status(id: 1, name: 'Inbox', color: '0xfffa3a57'));
  void updateStatus(Status value) {
    statusNotifier.value = value;
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _onClickStatus(bool val) async {
      await showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (context) =>
            StatusSelector(
              status: status,
            ),
      ).then((value) =>
          updateStatus(value));
          // updateStatus());
    }

    final userRoleFuture = ref.watch(userRoleStateFuture);

    // استخدم userRoleFuture هنا كما تحتاج
    // Text(' ${userRoleFuture.value}');
    return
                       Builder(
                           builder:(context) {
                                 if (userRoleFuture.value == 'admin') {
                                      return  Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 6),
                                        decoration: BoxDecoration(
                                            color: kWhite,
                                            borderRadius: BorderRadius.circular(30)),
                                        child: Column(
                                          children: [
                                            Material(
                                              color: kWhite,
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                              child: MyExpansionTile(
                                                onExpansionChanged: _onClickStatus,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                ),
                                                tilePadding: const EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                count: const SizedBox(),
                                                title: Row(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.symmetric(
                                                          vertical: 8),
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 8, horizontal: 12),
                                                      decoration: BoxDecoration(
                                                        color: status.color != null
                                                            ? Color(
                                                            int.parse(status.color!))
                                                            : kRed,
                                                        borderRadius:
                                                        BorderRadius.circular(30),
                                                      ),
                                                      child: Text(
                                                        '${status.name}'.tr(),
                                                        style: TextStyle(
                                                            color: Color(int.parse(
                                                                status.color!)) ==
                                                                kYellow
                                                                ? kBlack
                                                                : kWhite,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                leading: Icon(
                                                  Icons.label_important_outline_rounded,
                                                  color: kGray70,
                                                ),
                                                trailing: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 14,
                                                      color: kGray70,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                    return Container(
                                      child: SizedBox()
                                 // Container for other users
    );
    }});

    }





}
