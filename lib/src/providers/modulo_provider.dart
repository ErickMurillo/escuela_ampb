//Importacion de package externos
//import 'dart:convert';

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:escuela_ampb/src/models/modulo_model.dart';



class ModuloProvider{

    String baseUrl = 'http://www.escuelamesoamericana.org';

    Future<List<Modulo>> getModulos() async {
        var url = baseUrl + "/aprende/api/modulos/";
        
        Response response = await Dio(BaseOptions(
            connectTimeout: 5000,
            receiveTimeout: 100000,
            responseType: ResponseType.plain

        )).get(url);
        final data = response;
        final decode = json.decode(data.data);

        return (decode as List).map((modulo) {
            //print('Inserting $modulo');
            DBProvider.db.insertModulo(Modulo.fromJson(modulo));
        }).toList();
        
      
    }
}