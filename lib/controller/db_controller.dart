import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/images_model_data.dart';

class DBController extends GetxController{

  Directory? appDocumentsDirectory;
  File? jsonBankFile;

  RxList<Images> roughImagesData = <Images>[].obs;
  RxList<Images> imagesData = <Images>[].obs;


  Database? dbs;

  String db_table_name = "Pixabay";
  String pixabay_Column1_ID = "id";
  String pixabay_Column2_pageUrl = "pageURL";
  String pixabay_Column3_tags = "tags";
  String pixabay_Column4_image = "image";
  String pixabay_Column5_views = "views";
  String pixabay_Column6_likes = "likes";
  String pixabay_Column7_comments = "comments";
  String pixabay_Column8_user = "user";

  Future<void> writeJsonData({required String response}) async {

      appDocumentsDirectory = await getApplicationDocumentsDirectory();
      jsonBankFile = File("${appDocumentsDirectory!.path}/json_bank.json");
      jsonBankFile!.writeAsString(response);

      await readData();
  }

  Future<void> readData() async {
    String readData = await jsonBankFile!.readAsString();
    roughImagesData.value = imagesFromJsonDB(readData);
    print("sladkovhbj ==> ${roughImagesData[0].image}");

  }




  Future<Database?> init() async {

    String path = await getDatabasesPath();

    String dataBasePath = join(path, "subscription.db");

    dbs = await openDatabase(
      dataBasePath,
      version: 1,
      onCreate: (Database database, version) async {
        String query = "CREATE TABLE IF NOT EXISTS $db_table_name($pixabay_Column1_ID INTEGER PRIMARY KEY AUTOINCREMENT, $pixabay_Column2_pageUrl TEXT, $pixabay_Column3_tags TEXT, $pixabay_Column4_image TEXT, $pixabay_Column5_views INTEGER, $pixabay_Column6_likes INTEGER, $pixabay_Column7_comments INTEGER, $pixabay_Column8_user TEXT);";
        await database.execute(query);
      },
    );
    String query = "CREATE TABLE IF NOT EXISTS $db_table_name($pixabay_Column1_ID INTEGER PRIMARY KEY AUTOINCREMENT, $pixabay_Column2_pageUrl TEXT, $pixabay_Column3_tags TEXT, $pixabay_Column4_image TEXT, $pixabay_Column5_views INTEGER, $pixabay_Column6_likes INTEGER, $pixabay_Column7_comments INTEGER, $pixabay_Column8_user TEXT);";

    dbs!.execute(query);
    return dbs;
  }

  Future insertBulkRecord({required List<Images> data}) async {
    deleteTable();
    dbs = await init();
    for(var i=0; i< data.length; i++){

      String sql = "INSERT INTO $db_table_name VALUES(NULL, '${data[i].pageUrl}', '${data[i].tags}', '${data[i].image}', '${data[i].views}', '${data[i].likes}', '${data[i].comments}', '${data[i].user}');";
      int id = await dbs!.rawInsert(sql);
      print("object ID ==> $i = $id");
    }
  }

  Future<void> fetchRecords() async{
    dbs = await init();

    String sql = "SELECT *FROM $db_table_name";
    List<Map<String, dynamic>> data = await dbs!.rawQuery(sql);

    List<Images> img = imagesFromJsonDB(jsonEncode(data));

    Set<int> randomList = {};
    Random random = Random();

    while(randomList.length != 10){
      int rand = random.nextInt(20);
      randomList.add(rand);
    }

    imagesData.clear();
    randomList.forEach((element) {
    imagesData.add(img[element]);
    });


  }

  Future deleteTable() async {
    dbs = await init();
    String sql = "DROP TABLE $db_table_name";
    await dbs!.execute(sql);
  }



}