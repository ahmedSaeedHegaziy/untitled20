import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../utils/constant.dart';


// ListView.builder(
// primary: false,
// shrinkWrap: true,
// itemCount: 1,
// itemBuilder: (context, index) {
// List<Widget> temp = [];
// int count = 0;
// for (var activity in activities) {
// // if (activity.title != null) {
// temp.add(
// Container(
// margin: const EdgeInsets.symmetric(
// horizontal: 16, vertical: 6),
// padding: const EdgeInsets.all(16),
// decoration: BoxDecoration(
// color: kWhite,
// borderRadius:
// BorderRadius.circular(30)),
// child: Column(
// children: [
// Row(
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: [
// Row(
// children: [
// activity.user?.image != ''
// ? CircleAvatar(
// radius: 10,
// backgroundImage:
// CachedNetworkImageProvider(
// '$storageUrl/${activity.user?.image}'),
// )
//     : const CircleAvatar(
// radius: 10,
// // backgroundImage: AssetImage(),
// ),
// const SizedBox(
// width: 8,
// ),
// SizedBox(
// width: 200,
// child: Text(
// '${activity.user?.name}',
// style: const TextStyle(
// fontSize: 16,
// fontWeight:
// FontWeight.w500,
// ),
// ),
// ),
// ],
// ),
// activity.createdAt != null
// ? Text(
// DateFormat.yMMMd().format(
// activity.createdAt!),
// style: TextStyle(
// fontSize: 12,
// color: kGray70),
// )
//     : Text(
// 'Just Now'.tr(),
// style: TextStyle(
// fontSize: 12,
// color: kGray70),
// ),
// ],
// ),
// const SizedBox(
// height: 8,
// ),
// Row(
// children: [
// const SizedBox(
// width: 30,
// ),
// Flexible(
// child: Text(
// activity.body ?? '',
// style: const TextStyle(
// fontSize: 14,
// ),
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// );
// // }
// count++;
// }
// return MyExpansionTile(
// textColor: kBlack,
// title: Text(
// 'Activity'.tr(),
// style: TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.w500),
// ),
// count: count == 0 ? null : Text('$count'),
// initiallyExpanded: true,
// // trailing: Text('22'),
// children: temp,
// );
// },
// ),

// Height of your Container
const double appBarHeight = 80.0;

class MyAppBar extends StatefulWidget {
  final ScrollController controller;
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool dynamicTitle;

  const MyAppBar(
      {Key? key,
      required this.controller,
      required this.title,
      this.leading,
      this.actions,
      this.dynamicTitle = true})
      : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  // You don't need to change any of these variables
  var _fromTop = -appBarHeight;

  var _allowReverse = true, _allowForward = true;
  var _prevOffset = 0.0;
  var _prevForwardOffset = -appBarHeight;
  var _prevReverseOffset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // entire logic is inside this listener for ListView
  void _listener() async {
    double offset = widget.controller.offset;
    var direction = widget.controller.position.userScrollDirection;
    var max = 0.0;
    if (direction == ScrollDirection.reverse && offset > 0) {
      _allowForward = true;
      if (_allowReverse) {
        _allowReverse = false;
        _prevOffset = offset;
        _prevReverseOffset = _fromTop;
      }
      var difference = offset - _prevOffset;

      if (_fromTop < max) {
        max = _fromTop;
        _fromTop = _prevReverseOffset + difference;
      }

      if (_fromTop > 0) {
        _fromTop = 0.0;
      }
    } else if (direction == ScrollDirection.forward && offset < 160) {
      _allowReverse = true;
      max = _fromTop;
      if (_allowForward) {
        _allowForward = false;
        _prevOffset = offset;
        _prevForwardOffset = _fromTop;
      }
      var difference = offset - _prevOffset;
      _fromTop = _prevForwardOffset + difference;
      if (_fromTop < -appBarHeight) _fromTop = -appBarHeight;
    }
    if (mounted)
      setState(
          () {}); // for simplicity I'm calling setState here, you can put bool values to only call setState when there is a genuine change in _fromTop
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // top: _fromTop,
      top: 0,
      left: 0,
      right: 0,
      child: MyAppBarWidget(
        fromTop: _fromTop,
        title: widget.title,
        leading: widget.leading,
        actions: widget.actions,
        dynamicTitle: widget.dynamicTitle,
      ),
    );
  }
}

class MyAppBarWidget extends StatelessWidget {
  final double fromTop;
  final String title;
  final Widget? leading;
  final bool dynamicTitle;
  final List<Widget>? actions;
  const MyAppBarWidget(
      {Key? key,
      required this.fromTop,
      required this.title,
      this.leading,
      this.actions,
      this.dynamicTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      // opacity: 1 - (-fromTop / appBarHeight),
      opacity: 1,
      child: AppBar(
        // leadingWidth: 120,
        centerTitle: true,
        leading: leading,
        title: dynamicTitle
            ? Opacity(
                opacity: (1 - (-fromTop / appBarHeight)) > 1
                    ? 1
                    : (1 - (-fromTop / appBarHeight)) < 1
                        ? 0
                        : (1 - (-fromTop / appBarHeight)),
                child: Text(title),
              )
            : Text(title),
        titleTextStyle: Theme.of(context).textTheme.headline6,
        actions: actions,
        elevation: 0,
        backgroundColor: kBackground.withOpacity(
            (1 - (-fromTop / appBarHeight)) > 1
                ? 1
                : (1 - (-fromTop / appBarHeight))),
        shape: Border(
          bottom: BorderSide(
              color: kGray70.withOpacity((1 - (-fromTop / appBarHeight)) > 1
                  ? 1
                  : (1 - (-fromTop / appBarHeight))),
              width: 0.3),
        ),
      ),
      // Container(
      //   padding: const EdgeInsets.only(top: 24),
      //   height: appBarHeight,
      //   decoration: BoxDecoration(
      //     color: background,
      //     border: Border(
      //       bottom: BorderSide(color: gray70, width: 0.3),
      //     ),
      //   ),
      //   alignment: Alignment.center,
      //   child: Text('Test', style: Theme.of(context).textTheme.headline5),
      // ),
    );
  }
}
