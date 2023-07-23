import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled20/utils/constant.dart';

import '../services/status_service.dart';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late Future<List<dynamic>> _mailsFuture;

  @override
  void initState() {
    super.initState();
    _mailsFuture = fetchMails() as Future<List>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: FutureBuilder<List<dynamic>>(
          future: _mailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error fetching mails: ${snapshot.error}');
            } else {
              List<dynamic> mails = snapshot.data ?? [];

              return ListView.builder(
                itemCount: mails.length,
                itemBuilder: (context, index) {
                  var mail = mails[index];
                  String dateString = mail['archive_date'];
                  DateTime dateTime = DateTime.parse(dateString);
                  return ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: Container(

                            width: double.infinity,
                            height: 120,
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              color: kWhite,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Icon(Icons.circle, color: Colors.red),
                                        SizedBox(width: 15),
                                        Column(
                                          children: [
                                            Text(' ${mail['sender']['name']}'),
                                          ],
                                        ),

                                        SizedBox(width: 70),

                                        Text(
                                          DateFormat.yMMMd().format(dateTime),
                                          style: TextStyle(
                                            color: kGray70,
                                          ),
                                        ),
                                        SizedBox(width: 6),

                                        Icon(Icons.arrow_forward_ios ,size: 15),

                                      ],
                                    ),

                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 48),
                                      Text(" ${mail['subject']}"),

                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      SizedBox(width: 48),
                                      Text(" ${mail['description']}"),

                                    ],
                                  )
                                  // SizedBox(width: 15),
                                ],
                              ),

                            ),
                          ),
                        ),
                      ],
                    ),

                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
