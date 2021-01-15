import 'package:escuela_ampb/src/services/descarga_provider.dart';
import 'package:flutter/material.dart';

import 'package:escuela_ampb/src/pages/contenido_page.dart';
import 'package:escuela_ampb/src/pages/home_page.dart';
import 'package:escuela_ampb/src/pages/modulo_page.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

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
                  '/' : (BuildContext context) => HomePage(),
                  'modulos' : (BuildContext context) => ModuloList(),
                  'contenido' : (BuildContext context) => ContenidoPage(),
              },
          ),
        );
    }
}