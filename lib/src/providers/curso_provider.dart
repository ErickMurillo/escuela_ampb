//Importacion de package externos
//import 'dart:convert';

import 'dart:convert';
import 'package:dio/dio.dart';
// import 'package:html/dom.dart';
// import 'package:html/dom_parsing.dart';
// import 'package:html/parser.dart';
// import 'package:html/dom.dart' as dom;
//import 'package:beautifulsoup/beautifulsoup.dart';
//importaciones Propias
import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';



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



        return (decode as List).map((curso) {

            // print('Inserting $curso');
            DBProvider.db.insertCurso(Curso.fromJson(curso));
        }).toList();
    }
}