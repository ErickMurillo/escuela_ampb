import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:escuela_ampb/src/models/reflexion_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
//import 'package:escuela_ampb/src/models/modulo_model.dart';


class ReflexionProvider{

    String baseUrl = 'http://www.escuelamesoamericana.org';

    Future<List<Reflexion>> getReflexiones() async {
        var url = baseUrl + "/aprende/api/reflexion/";
        Response response = await Dio(BaseOptions(
            connectTimeout: 5000,
            receiveTimeout: 100000,
            responseType: ResponseType.plain

        )).get(url);
        final data = response;
        final decode = json.decode(data.data);

        return (decode as List).map((reflexion) {
            //print('Inserting $reflexion');
            DBProvider.db.insertReflexion(Reflexion.fromJson(reflexion));
        }).toList();
    }
}