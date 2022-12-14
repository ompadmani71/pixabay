import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pixabay/model/images_model_data.dart';

class APIController extends GetxController{

  ConnectivityResult connectionStatus = ConnectivityResult.none;
  RxList<Images> responseImage = <Images>[].obs;



  Future<void> getPixabayImage () async {
    
    http.Response response = await http.get(
      Uri.parse("https://pixabay.com/api/?key=30524199-d824fc37f9db06f93713dde76&q=yellow+flowers&image_type=photo&page=2"),
    );

    if(response.statusCode == 200){
      
      Map<String, dynamic> data = jsonDecode(response.body);
      responseImage.value = imagesFromJson(jsonEncode(data['hits']));

      print("dfghnobject ==> ${responseImage[0].image}");
    }
}
  
  
}