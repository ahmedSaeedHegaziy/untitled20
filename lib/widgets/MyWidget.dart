import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled20/services/mail_services.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    getMails().then((jsonData) {
      setState(() {
        data = jsonData as List;
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Use the fetched data in your Container widget
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(data[index]['title']),
          );
        },
      ),
    );
  }
}
