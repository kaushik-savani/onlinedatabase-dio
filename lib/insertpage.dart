import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlinedatabase/viewpage.dart';

class insertpage extends StatefulWidget {
  const insertpage({Key? key}) : super(key: key);

  @override
  State<insertpage> createState() => _insertpageState();
}

class _insertpageState extends State<insertpage> {
  final ImagePicker _picker = ImagePicker();
  String path = "";

  TextEditingController tname = TextEditingController();
  TextEditingController tcontact = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ContactBook"),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Select Picture"),
                      children: [
                        ListTile(
                          onTap: () async {
                            final XFile? photo = await _picker.pickImage(
                                source: ImageSource.camera);
                            if (photo != null) {
                              path = photo.path;
                              setState(() {});
                            }
                          },
                          title: Text("Camera"),
                          leading: Icon(Icons.camera_alt),
                        ),
                        ListTile(
                          onTap: () async {
                            final XFile? photo = await _picker.pickImage(
                                source: ImageSource.gallery);

                            if (photo != null) {
                              path = photo.path;
                              setState(() {});
                            }
                          },
                          title: Text("Gallery"),
                          leading: Icon(Icons.camera_alt),
                        )
                      ],
                    );
                  },
                  context: context);
            },
            child: path.isEmpty
                ? Image.asset(
                    "myimage/user.png",
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  )
                : Image.file(
                    File(path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
          ),
          TextField(
            controller: tname,
          ),
          TextField(
            controller: tcontact,
          ),
          ElevatedButton(
              onPressed: () async {
                String name = tname.text;
                String contact = tcontact.text;

                // stoarge/emulated/0/Download/Image2022123647.jpg

                List<String> l = path.split(
                    "/"); // [stoarge,emulated,0,Download,Image2022123647.jpg]

                String imagename = l.last;

                // GET / POST
                var formData = path.isEmpty
                    ? FormData.fromMap({
                        'name': name,
                        'contact': contact,
                        'imageview' :"0"
                      })
                    : FormData.fromMap({
                        'name': name,
                        'contact': contact,
                        'imageview' :"1",
                        'file': await MultipartFile.fromFile(path,
                            filename: imagename),
                      });
                var response = await Dio().post(
                    'https://learnwithproject.000webhostapp.com/insert/data.php',
                    data: formData);

                print(response.data);
                print("done");
                Map m = jsonDecode(response.data);

                int connection = m['connection'];

                if (connection == 1) {
                  int result = m['result'];

                  if (result == 1) {
                    print("Data Inserted...");
                  } else {
                    print("Data Not Inserted");
                  }
                }
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return viewpage();
                  },
                ));
              },
              child: Text("Save"))
        ],
      ),
    );
  }
}
