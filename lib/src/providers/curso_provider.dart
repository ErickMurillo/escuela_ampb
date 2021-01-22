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
import 'package:http/http.dart' show get;



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
         
          print(baseUrl+item['imagen']);
          var rutaImg = baseUrl+item['imagen'];
          var newImg = _saveImage(rutaImg, item['id']);
          print(newImg);
          
        }

        return (decode as List).map((curso) {

            // print('Inserting $curso');
            DBProvider.db.insertCurso(Curso.fromJson(curso));
        }).toList();
    }
}

Future _saveImage(String imgUrl, int id) async {
    var response = await get(imgUrl);
    var documentDirectory = await getApplicationDocumentsDirectory();
    File file = File(join(documentDirectory.path, 'cursos_$id.jpg'));
    file.writeAsBytesSync(response.bodyBytes);
    //print(response);
    //print(response.bodyBytes);
    print(documentDirectory);
    print(file);
    return file;
  }




