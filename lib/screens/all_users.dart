import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';


import '../../utils/constant.dart';
import '../models_localhost/api_response.dart';
import '../models_localhost/sender.dart';
import '../models_localhost/user.dart';
import '../services/user_service.dart';
import '../utils/debouncer.dart';
import '../widgets/buttons.dart';
import '../widgets/myAppBarEmpty.dart';
import 'login.dart';

 Map<dynamic , dynamic> addusers = {};

class AllUsers extends StatefulWidget {
  const AllUsers({
    Key? key,
  }) : super(key: key);

  @override
  State<AllUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<AllUsers> {
  late final TextEditingController _searchCnt = TextEditingController();
  late FocusNode _focus = FocusNode();
  final _controller = ScrollController();
  final appBarHeight = 96.0;
  final offsetToRun = 0.0;

  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  final _deBouncer = DeBouncer(milliseconds: 500);

  _retrieveUsers() async {
    ApiResponse response = await getUsers();
    var userId=await getUserId();
    if (response.error == null) {
      setState(() {
        users = response.data as List<dynamic>;
        print("######user $getUserId()");
        users.forEach((element) {
          if(element.id !=  userId){
            filteredUsers.add(element);
          }
        });


      });
      return;
    }
    if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
                (route) => false)
      });
    }
    if (!mounted) return;
    showMessage(context, '${response.error}');
  }

  _onClickUser(User user) {
    setState(() {
      if (addusers.containsKey(user.id))  {
        addusers.remove(user.id);

      } else {
        addusers[user.id] = user;
      }
      print("add users: $addusers") ;
    });

    }



  @override
  void initState() {
    _focus.addListener(_onFocusChange);
    _focus.requestFocus();
    _retrieveUsers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _controller.dispose();
  }

  void _onFocusChange() {
    setState(() {});
    debugPrint("Focus1: ${_focus.hasFocus.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(children: [
        SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [

              SizedBox(
                height: appBarHeight + 56,
              ),
              GroupedListView<dynamic, String>(
                shrinkWrap: true,
                elements: filteredUsers,
                groupBy: (element) => (element?.roleId ?? 0).toString(),
                groupComparator: (value1, value2) => value2.compareTo(value1),
                itemComparator: (item1, item2) => (item1.name ?? '').compareTo(item2.name ?? ''),
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (String value) => Text(
                  " ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kGray70,
                  ),
                ),
                itemBuilder: (context, element) {



                  final String name = element?.name ?? 'N/A';
                  final String mobile = element?.mobile ?? 'N/A';

                  return Material(
                    color: kBackground,
                    child: ListTile(

                      enabled: true,
                      onTap: () {

                        _onClickUser(element);
                      },
                      leading: const Icon(Icons.person_outline_rounded),
                      title: Text(
                        name,
                        style: TextStyle(color: kBlack),
                      ),
                      subtitle:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            mobile,
                          ),
                          Icon(Icons.check_box
                          ,color: addusers[element.id] != null ? Colors.green : Colors.grey,
                          )
                        ],
                      )
                      // shape: Border(
                      //     bottom: BorderSide(
                      //         color: kGray70, width: 0.2)),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
        MyAppBarEmpty(
          controller: _controller,
          appBarHeight: appBarHeight + 48,
          runAfter: offsetToRun,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                          _searchCnt.clear();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: kSecondaryColor,
                        )),
                  ),
                  Text(
                    'Manage Users'.tr(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    width: 48,
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 48,
                      // width: MediaQuery.of(context).size.width * 0.75,
                      width: MediaQuery.of(context).size.width - 32,
                      child: TextField(
                        onChanged: (string) {
                          _deBouncer.run(() {
                            setState(() {
                              filteredUsers = users
                                  .where((opt) => (opt.name
                                  .toLowerCase()
                                  .contains(string.toLowerCase())))
                                  .toList();
                            });
                          });
                        },
                        controller: _searchCnt,
                        focusNode: _focus,
                        decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 8),
                          hintText: 'Search',
                          prefixIcon: Icon(
                            Icons.search,
                            color: kGray50,
                          ),
                          suffixIcon: _focus.hasFocus
                              ? IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: _searchCnt.text.isEmpty
                                  ? kGray50
                                  : kSecondaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchCnt.clear();
                                filteredUsers = users;
                              });
                            },
                          )
                              : null,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: kGray10, width: 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide(color: kGray10, width: 1),
                          ),
                          filled: true,
                          fillColor: !_focus.hasFocus ? kWhite : kGray10,
                          // focusColor: gray10,
                        ),
                      ),
                    ),
                    // TextBtn(
                    //   label: 'Cancel',
                    //   function: () {
                    //     Navigator.of(context)
                    //         .pop({'founded': false, 'sender': ''});
                    //     FocusScope.of(context).unfocus();
                    //     _searchCnt.clear();
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class SearchResult extends StatelessWidget {
  final double heightFirstW;
  final List<Sender> senders;
  const SearchResult(
      {Key? key,
        required this.heightFirstW,
        required this.senders,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: heightFirstW,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '21 Completed',
                    style:
                    TextStyle(color: kGray70, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.circle,
                      size: 5,
                      color: kGray50,
                    ),
                  ),
                  TextBtn(
                    label: 'Show',
                    function: () {
                      print('show');
                    },
                  )
                ],
              ),
              IconButton(
                onPressed: () {
                  print('ii');
                },
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: kSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        const Divider(),

      ],
    );
  }
}
