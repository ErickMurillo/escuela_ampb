//import 'dart:io';

import 'package:escuela_ampb/src/pages/first_page.dart';
import 'package:escuela_ampb/src/services/descarga_provider.dart';
import 'package:flutter/material.dart';

import 'package:escuela_ampb/src/pages/contenido_page.dart';
import 'package:escuela_ampb/src/pages/home_page.dart';
import 'package:escuela_ampb/src/pages/modulo_page.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//Directory _appDocsDir;
void main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  //_appDocsDir = await getApplicationDocumentsDirectory();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: ( _ ) => DescargaCurso() )
          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Material App',
              initialRoute: '/',
              routes: {
                  '/' : (BuildContext context) => FirstPage(),
                  'modulos' : (BuildContext context) => ModuloList(),
                  'contenido' : (BuildContext context) => ContenidoPage(),
                  //'firstpage' : (BuildContext context) => FirstPage(),
              },
          ),
        );
    }
}