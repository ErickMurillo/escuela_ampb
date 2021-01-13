
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:escuela_ampb/src/models/contenido_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';



class ContenidoProvider{

    String baseUrl = 'http://ampb.caps-nicaragua.org';

    Future<List<Contenido>> getContenidos() async {
        var url = baseUrl + "/aprende/api/contenidos/";
        Response response = await Dio(BaseOptions(
            connectTimeout: 5000,
            receiveTimeout: 100000,
            responseType: ResponseType.plain

        )).get(url);
        final data = response;
        final decode = json.decode(data.data);



        return (decode as List).map((contenido) {
            print('Inserting $contenido');
            DBProvider.db.insertContenido(Contenido.fromJson(contenido));
        }).toList();
        // final contenido = new Contenidos.fromJsonList(decode);
        // return contenido.items;
    }
}

