//import 'dart:io';
import 'package:flutter/material.dart';

import 'package:escuela_ampb/src/pages/guardar_notas.dart';
import 'package:escuela_ampb/src/pages/first_page.dart';
import 'package:escuela_ampb/src/pages/lista_curso_page.dart';
import 'package:escuela_ampb/src/pages/notas_page.dart';
import 'package:escuela_ampb/src/services/descarga_provider.dart';

import 'package:escuela_ampb/src/pages/contenido_page.dart';
import 'package:escuela_ampb/src/pages/modulo_page.dart';
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
              theme: ThemeData(
                primaryColor: Color(0xFF4f002b),
              ),
              initialRoute: '/',
              routes: {
                  '/' : ( _ ) => FirstPage(), //FirstPage,HomePage
                  'modulos' : ( _ ) => ModuloList(),
                  'contenido' : ( _ ) => ContenidoPage(),
                  'lista_cursos' : ( _ ) => ListaCursoPage(),
                  'buscador' : ( _ ) => ListaCursoPage(),
                  'notas' : ( _ ) => NotasPage(),
                  'guardar_nota' : ( _ ) => GuardaPage(),
              },
          ),
        );
    }
}