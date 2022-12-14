import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixabay/controller/api_controller.dart';
import 'package:pixabay/controller/db_controller.dart';
import 'package:pixabay/model/images_model_data.dart';
import 'package:pixabay/views/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  APIController apiController = Get.find();
  DBController dbController = Get.find();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await apiController.getPixabayImage();
      if (apiController.responseImage.isNotEmpty) {
        await dbController.writeJsonData(
            response: imagesToJson(apiController.responseImage));
      }
      await dbController.insertBulkRecord(data: dbController.roughImagesData);
      await dbController.fetchRecords();
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    apiController.connectionStatus = result;
    print("connectionStatus ==> ${apiController.connectionStatus}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.home),
      ),
        appBar: AppBar(
          title: Text("Home Page"),
          // backgroundColor: Colors.deepPurple,
        ),
        body: (apiController.connectionStatus == ConnectivityResult.mobile ||
                apiController.connectionStatus == ConnectivityResult.wifi)
            ? Obx(() {
              if(dbController.imagesData.isNotEmpty) {
               return ListView.builder(
                        itemCount: dbController.imagesData.length,
                        itemBuilder: (context, index) {
                          Images image = dbController.imagesData[index];
                          return GestureDetector(
                            onTap: (){
                              Get.to(DetailScreen(images: dbController.imagesData[index],));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    spreadRadius: 1
                                  )
                                ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: NetworkImage(image.image!),fit: BoxFit.cover)
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text("Views: ",style: TextStyle(fontWeight: FontWeight.w700),),
                                      Text("${image.views}"),
                                      Spacer(),
                                      Text("Likes: ",style: TextStyle(fontWeight: FontWeight.w700),),
                                      Text("${image.likes}"),
                                      SizedBox(width: 10,),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Text("Comments: ",style: TextStyle(fontWeight: FontWeight.w700),),
                                      Text("${image.comments}"),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Text("Tags: ",style: TextStyle(fontWeight: FontWeight.w700),),
                                      Expanded(child: Text("${image.tags}")),
                                    ],
                                  ),
                                  SizedBox(height: 5,)
                                ],
                              ),
                            ),
                          );
                        });
              }

              return const Center(child: CircularProgressIndicator(),);
              })
            : const Center(
                child: Text("No internet!\nplease connect internet first"),
              ));
  }
}
