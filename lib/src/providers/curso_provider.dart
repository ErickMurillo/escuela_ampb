//Importacion de package externos
//import 'dart:convert';

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:html/dom.dart';
// import 'package:html/dom_parsing.dart';
// import 'package:html/parser.dart';
// import 'package:html/dom.dart' as dom;
//import 'package:beautifulsoup/beautifulsoup.dart';
//importaciones Propias
import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';



class CursoProvider{

    String baseUrl = 'http://ampb.caps-nicaragua.org';

    List hyperlinks = [];




    Future<List<Curso>> getCursos() async {
        var url = baseUrl + "/aprende/api/cursos/";
        Response response = await Dio(BaseOptions(
            connectTimeout: 5000,
            receiveTimeout: 100000,
            responseType: ResponseType.plain

        )).get(url);
        final data = response;
        final decode = json.decode(data.data);

        print("printing the decode");
        for (var item in decode) {
          //var imageResponse = await Dio().get(baseUrl+item['imagen']);
          print(baseUrl+item['imagen']);
          var rutaImg = baseUrl+item['imagen'];
          //saveFile(item['id'], rutaImg);
          //readFile(item['id'], rutaImg);
          _saveLocalPath(item['id'], rutaImg);
        }

        return (decode as List).map((curso) {

            // print('Inserting $curso');
            DBProvider.db.insertCurso(Curso.fromJson(curso));
        }).toList();
    }
}

Future<String> _saveLocalPath(int id, String urlImg) async {
  // Directory documentsDirectory = await getApplicationDocumentsDirectory();
  // String appImagenPath = documentsDirectory.path;
  // String filePath = '$appImagenPath/demoTextFile.txt';
  try {
  // Saved with this method.
    var imageId = await ImageDownloader.downloadImage(urlImg);
    if (imageId == null) {
      return "Error no hubo imagen";
  }

  // Below is a method of obtaining saved image information.
  var fileName = await ImageDownloader.findName(imageId);
  var path = await ImageDownloader.findPath(imageId);
  var size = await ImageDownloader.findByteSize(imageId);
  var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }

return 'aqui la info';
}

void saveFile(int id, String urlImg) async {
    File file = File(await _saveLocalPath(id,urlImg)); // 1
    file.writeAsString("This is my demo text $id that will be saved to $urlImg: demoTextFile.txt"); // 2
  }

void readFile(int id, String urlImg) async {
    File file = File(await _saveLocalPath(id,urlImg)); // 1
    String fileContent = await file.readAsString(); // 2

    print('File Content: $fileContent');
}




