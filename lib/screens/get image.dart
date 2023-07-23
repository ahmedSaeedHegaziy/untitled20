import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:file_picker/file_picker.dart';



class getImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Image & File Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Future<List<Asset>> pickImages() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
      );
    } on Exception catch (e) {
      // Handle any exceptions that occur during the image picking process
      print(e);
    }
    return resultList;
  }

  Future<List<FilePickerResult?>> pickFiles() async {
    List<FilePickerResult?> resultList = [];
    try {
      resultList = (await FilePicker.platform.pickFiles(allowMultiple: true)) as List<FilePickerResult?>;
    } catch (e) {
      // Handle any exceptions that occur during the file picking process
      print(e);
    }
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-Image & File Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                List<Asset> images = await pickImages();
                // Handle the selected images here
                for (var image in images) {
                  print(image.name);
                }
              },
              child: Text('Select Images'),
            ),
            ElevatedButton(
              onPressed: () async {
                List<FilePickerResult?> files = await pickFiles();
                // Handle the selected files here
                for (var file in files) {
                  if (file != null) {
                    print(file.files.single.name);
                  }
                }
              },
              child: Text('Select Files'),
            ),
          ],
        ),
      ),
    );
  }
}
