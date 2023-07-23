import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/state_manager.dart';
import '../widgets/myGroupList.dart';

class MyGroupListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<dynamic>? mails;
    final futureCategories = ref.watch(categoriesStateFuture);
    return futureCategories.when(
      data: (categories) => MyGroupList(
        mails: mails ?? [],
        categories: categories,
        showCompleted: true,
      ),
      loading: () {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      },
      error: (Object error, StackTrace? stackTrace) {
        return Text(error.toString());
      },
    );
  }
}
