
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:escuela_ampb/src/models/contenido_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';



class ContenidoProvider{

    String baseUrl = 'http://www.escuelamesoamericana.org';

    Future<List<Contenido>> getContenidos(int id) async {
        var url = baseUrl + "/aprende/api/contenidos/filtro/$id";
        
        Response response = await Dio(BaseOptions(
            connectTimeout: 5000,
            receiveTimeout: 100000,
            responseType: ResponseType.plain

        )).get(url);
        final data = response;
        final decode = json.decode(data.data);

        return (decode as List).map((contenido) {

            DBProvider.db.insertContenido(Contenido.fromJson(contenido));
        }).toList();
        
      

    }
}

