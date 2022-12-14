import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixabay/controller/db_controller.dart';

import '../model/images_model_data.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.images}) : super(key: key);

  final Images images;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  DBController dbController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async{
          await dbController.fetchRecords();
          return true;
        },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detail"),
          // backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: ()async{
              Get.back();
              await dbController.fetchRecords();
            },
            icon: Icon(Icons.keyboard_arrow_left),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.images.image!)),

              Row(
                children: [
                  Text(
                    "User: ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text("${widget.images.id}"),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Likes: ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text("${widget.images.likes}"),
                  Spacer(),
                  Text(
                    "Comments: ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text("${widget.images.comments}"),
                  SizedBox(width: 20,)
                ],
              ),

              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Views: ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text("${widget.images.views}"),
                ],
              ),

              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Tags: ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Expanded(child: Text("${widget.images.tags}")),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "User: ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text("${widget.images.user}"),
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
