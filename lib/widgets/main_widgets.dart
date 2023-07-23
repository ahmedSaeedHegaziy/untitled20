import 'package:flutter/material.dart';
import 'package:untitled20/screens/all_senders.dart';

import 'package:provider/provider.dart';

import '../utils/constant.dart';

class MainBtn extends StatelessWidget {
  final String text;
  final bool showProgress;
  final Function() onPressed;
//
  const MainBtn(
      {Key? key,
      required this.text,
      required this.showProgress,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        !showProgress ? onPressed() : null;
      },
      child: Container(
        height: 50.0,
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   colors: [
          //     kMainColorLight,
          //     kMainColorDark,
          //   ],
          // ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Center(
          child: showProgress
              ? const CircularProgressIndicator(color: Colors.white,)
              : Text(
                  text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
        ),
      ),
    );
  }
}

////////////////

class SocialMedialRegistration extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const SocialMedialRegistration(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          // gradient: const LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   colors: [
          //     kMainColorLight,
          //     kMainColorDark,
          //   ],
          // ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

/////////////

class StatusContainer extends StatelessWidget {
  final Map status;

  const StatusContainer({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: (){
      //   if(status.isNotEmpty) {
      //     List allMails = Provider.of<PassAllData>(context, listen: false)
      //         .getAllMails();
      //     Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //         AllMailsOfStatus(statusName: status["name"], allMails: allMails)));
      //   }
      // },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: status.isNotEmpty
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: status["color"] != null
                                ? Color(int.parse(status["color"]))
                                : Colors.black,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        Text(
                          "${status["mails_count"]}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${status["name"]}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(strokeWidth: 1),
                )),
    );
  }
}

////////////

class ActiveList extends StatelessWidget {
  final String title;
  final bool isChecked;
  final IconData icon;
  final Color iconColor;
  final Function onPressed;

  const ActiveList({
    Key? key,
    required this.title,
    required this.isChecked,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  onPressed();
                },
                icon: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/////////////

class ShowMailsOfCategory extends StatelessWidget {
  final String? userImageUrl;
  final List data;
  final String categoryName;

  const ShowMailsOfCategory({
    Key? key,
    required this.userImageUrl,
    required this.data,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < data.length; i++) ...{
          if (data[i]["sender"]["category"]["name"] == categoryName) ...{
            InkWell(
              // onTap: () {
              //   String tags = "";
              //   for(int j = 0; j < (data[i]["tags"] as List).length; j++){
              //     tags += "#${(data[i]["tags"] as List)[j]["name"]} ";
              //   }
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           // builder: (context) => AllSenders(
              //           //     userImageUrl: userImageUrl,
              //           //     mailId: data[i]["id"],
              //           //     categoryName: categoryName,
              //           //     senderName: data[i]["sender"]["name"],
              //           //     dateSend: data[i]["updated_at"],
              //           //     archiveNumber: data[i]["archive_number"],
              //           //     titleMail: data[i]["subject"],
              //           //     descriptionMail: data[i]["description"],
              //           //     tags: tags,
              //           //     statusName: data[i]["status"]["name"],
              //           //     statusColor: data[i]["status"]["color"],
              //           //     decision: data[i]["decision"],
              //           //     imagesUrl: data[i]["attachments"],
              //           // ),
              //       ),
              //   );
              // },
              child: ShowMessageSends(
                containerColor: Color(int.parse(data[i]["status"]["color"])),
                organizationName: "${data[i]["sender"]["name"]}",
                dateSend: data[i]["updated_at"].toString().substring(0, 10),
                subject: "${data[i]["subject"]}",
                message: "${data[i]["description"]}",
                colorMessage: Colors.blue,
              ),
            ),
            if ((data[i]["tags"] as List).isNotEmpty) ...{
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                child: Wrap(
                  children: [
                    for (int j = 0;
                        j < (data[i]["tags"] as List).length;
                        j++) ...{
                      Text(
                        "#${data[i]["tags"][j]["name"]}  ",
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 16),
                      )
                    },
                  ],
                ),
              ),
            },
            if ((data[i]["attachments"] as List).isNotEmpty) ...{
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                child: Wrap(
                  children: [
                    for (int x = 0; x < (data[i]["attachments"] as List).length; x++) ...{
                      ShowImage(
                          onPressed: () {},
                          imageUrl: "${(data[i]["attachments"] as List)[x]["image"]}"),
                      const SizedBox(
                        width: 2,
                      ),
                    },
                  ],
                ),
              ),
            },
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   child: kDivider,
            // )
          }
        },
      ],
    );
  }
}

////////////////////////

class ShowMessageSends extends StatelessWidget {
  final Color containerColor;
  final String organizationName;
  final String dateSend;
  final String subject;
  final String message;
  final Color colorMessage;

  const ShowMessageSends({
    Key? key,
    required this.containerColor,
    required this.organizationName,
    required this.dateSend,
    required this.subject,
    required this.message,
    required this.colorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                  Text(
                    organizationName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    dateSend,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            subject,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 8),
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
        // kSizeBoxH8,
      ],
    );
  }
}

////////////

class ShowImage extends StatelessWidget {
  final Function onPressed;
  final String imageUrl;

  const ShowImage({
    Key? key,
    required this.onPressed,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed(),
      child: Container(
        height: 500,
        width: 500,
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Center(
          child: Image.network(
            "http://127.0.0.1:8000/api/storage/$imageUrl",
            width: 42,
            height: 42,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

//////////////



class TagContainer extends StatelessWidget {
  final String tagName;
  final bool isSelected;
  final Function onPressed;

  const TagContainer({
    Key? key,
    required this.tagName,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? kWhite : Colors.black26,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: InkWell(
        onTap: (){
          onPressed();
        },
        child: FittedBox(
            fit: BoxFit.fill,
            child: Text(
              "$tagName",
              style: TextStyle(
                  fontSize: 15, color: isSelected ? Colors.white : Colors.black),
            )),
      ),
    );
  }
}
//
// //////////////
//
class ActivityContainer extends StatelessWidget {
  final String? imageUrl;
  final String nameSender;
  final String dateSend;
  final String activityText;

  const ActivityContainer({
    Key? key,
    required this.imageUrl,
    required this.nameSender,
    required this.dateSend,
    required this.activityText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  imageUrl != null
                      ? Image.network(
                          "http://127.0.0.1:8000/api/storage/$imageUrl",
                          height: 16,
                          width: 16,
                        )
                      : const Icon(
                          Icons.circle,

                        ),

                  Text(
                    nameSender,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Text(
                dateSend,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 8),
            child: Text(
              activityText,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////

class ShowSenderList extends StatelessWidget {
  final Map sender;

  const ShowSenderList({Key? key, required this.sender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.person,
        size: 24,
        color: Colors.grey,
      ),
      title: Text(
        sender["name"],
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      subtitle: Row(
        children: [
          FittedBox(
              child: Row(
            children: [
              const Icon(
                Icons.phone,
                size: 16,
              ),
              Text(
                sender["mobile"],
                style: const TextStyle(fontSize: 16),
              ),
            ],
          )),
        ],
      ),
    );
  }
}

/////////////////////////

class ShowCategory extends StatelessWidget {
  final Map category;

  const ShowCategory({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category["name"],
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////

class ActionMail extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final Function onPressed;

  const ActionMail(
      {Key? key,
      required this.icon,
      required this.color,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: (){
          onPressed();
        },
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 32,
                ),

                Text(
                  text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
