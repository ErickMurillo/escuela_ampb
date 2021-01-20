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
          var imageUrl = baseUrl+item['imagen'];
          print(baseUrl+item['imagen']);
          // await ImageDownloader.downloadImage('${imageUrl}',
          //       destination: AndroidDestinationType.directoryPictures
          //       ..inExternalFilesDir()
          //       ..subDirectory("custom/curso_${item['id']}.jpg"),
          // );

        }

        return (decode as List).map((curso) {

            // print('Inserting $curso');
            DBProvider.db.insertCurso(Curso.fromJson(curso));
        }).toList();
    }
}

// Future<String> _saveLocalPath(int id, url) async {
//   Directory documentsDirectory = await getApplicationDocumentsDirectory();
//   File file = new File(
//       join(documentsDirectory.path, 'imagen_${id}.png')
//     );
//   //final path = join(documentsDirectory.path, 'imagen_${id}');
//   //file.writeAsBytesSync(url);
//   //print(file);
//   return '';
// }

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // Write the file.
  return file.writeAsString('$counter');
}

Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file.
    String contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0.
    return 0;
  }
}