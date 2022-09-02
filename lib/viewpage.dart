import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onlinedatabase/updatepage.dart';

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  List l = [];
  bool status = false;
  int result = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getalldata();
  }

  getalldata() async {
    Response response = await Dio()
        .get('https://learnwithproject.000webhostapp.com/insert/viewdata.php');
    print(response.data.toString());
    Map m = jsonDecode(response.data);

    int connection = m['connection'];
    if (connection == 1) {
      result = m['result'];
      if (result == 1) {
        l = m['data'];
      }
    }
    status = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: status
          ? (result == 1
              ? ListView.builder(
                  itemCount: l.length,
                  itemBuilder: (context, index) {
                    Map map = l[index];

                    String imageurl = map['imagename'] == null
                        ? ""
                        : "https://learnwithproject.000webhostapp.com/insert/${map['imagename']}";
                    return ListTile(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return updatepage(map);
                          },
                        ));
                      },
                      leading: imageurl.isEmpty
                          ? Container(
                              height: 100,
                              width: 100,
                              child: Image.asset("myimage/user.png"),
                            )
                          : Image.network(
                              imageurl,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Text(
                                    ((loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!) *
                                                100)
                                            .toInt()
                                            .toString() +
                                        "%");
                              },
                            ),
                      title: Text("${map['name']}"),
                      subtitle: Text("${map['contact']}"),
                    );
                  },
                )
              : Text("Data not Found"))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
