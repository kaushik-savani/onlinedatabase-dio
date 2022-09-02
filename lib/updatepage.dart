import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlinedatabase/viewpage.dart';

class updatepage extends StatefulWidget {
  Map map;
  updatepage(this.map);



  @override
  State<updatepage> createState() => _updatepageState();
}

class _updatepageState extends State<updatepage> {

  final ImagePicker _picker = ImagePicker();
  String path = "";

  TextEditingController tname = TextEditingController();
  TextEditingController tcontact = TextEditingController();

  String imageurl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tname.text = widget.map['name'];
    tcontact.text = widget.map['contact'];
    imageurl =
    "https://learnwithproject.000webhostapp.com/insert/${widget.map['imagename']}";
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
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
                      ? Image.network(
                    imageurl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  )
                      : Image.file(
                    File(path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  )),
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

                    String id = widget.map['id'];
                    String serverlocation = widget.map['imagename'];

                    var formData = FormData.fromMap({});

                    if (path.isEmpty) {
                      formData = FormData.fromMap({
                        'id': id,
                        'name': name,
                        'contact': contact,
                        'imageupdate': "0"
                      });
                    } else {
                      DateTime dt = DateTime.now();

                      String imagename = "$name${dt.year}${dt.month}${dt
                          .day}${dt.hour}${dt.minute}${dt.second}.jpg";

                      // GET / POST
                      formData = FormData.fromMap({
                        'id': id,
                        'name': name,
                        'contact': contact,
                        'imageupdate': "1",
                        'serverlocation': serverlocation,
                        'file': await MultipartFile.fromFile(path,
                            filename: imagename),
                      });
                    }

                    var response = await Dio().post(
                        'https://learnwithproject.000webhostapp.com/insert/update.php',
                        data: formData);

                    print(response.data);
                    Map m = jsonDecode(response.data);

                    int connection = m['connection'];

                    if (connection == 1) {
                      int result = m['result'];

                      if (result == 1) {
                        print("Data Updated...");

                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return viewpage();
                          },
                        ));
                      }
                      else {
                        print("Data Not Update");
                      }
                    }
                  },
                  child: Text("Save"))
            ],
          ),
        ),
        onWillPop: goBack);
  }
  Future<bool> goBack() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return viewpage();
      },
    ));

    return Future.value();
  }
}
