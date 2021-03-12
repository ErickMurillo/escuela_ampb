import 'package:flutter/material.dart';
import 'dart:async';

// import 'package:escuela_ampb/src/pages/guardar_notas.dart';
import 'package:escuela_ampb/src/pages/first_page.dart';
import 'package:escuela_ampb/src/pages/lista_curso_page.dart';
import 'package:escuela_ampb/src/pages/notas_page.dart';
import 'package:escuela_ampb/src/services/descarga_provider.dart';

import 'package:escuela_ampb/src/pages/contenido_page.dart';
import 'package:escuela_ampb/src/pages/modulo_page.dart';
import 'package:provider/provider.dart';

import 'package:escuela_ampb/src/providers/modulo_provider.dart';
import 'package:escuela_ampb/src/providers/reflexion_provider.dart';
import 'package:escuela_ampb/src/providers/curso_provider.dart';

import 'package:connectivity/connectivity.dart';
import 'package:google_fonts/google_fonts.dart';

//Directory _appDocsDir;
void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //_appDocsDir = await getApplicationDocumentsDirectory();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DescargaCurso())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(
          primaryColor: Color(0xFF4f002b),
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: SplashScreen(),
        initialRoute: '/',
        routes: {
          //   '/': (_) => FirstPage(), //FirstPage,HomePage
          'modulos': (_) => ModuloList(),
          'contenido': (_) => ContenidoPage(),
          'lista_cursos': (_) => ListaCursoPage(),
          'buscador': (_) => ListaCursoPage(),
          'notas': (_) => NotasPage(),
          //   'guardar_nota' : ( _ ) => GuardaPage(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var apiCursoProvider = CursoProvider();
  var apiModuloProvider = ModuloProvider();
  var apiReflexionProvider = ReflexionProvider();

  @override
  void initState() {
    super.initState();
    setState(() {
      apiCursoProvider.getCursos();
      apiModuloProvider.getModulos();
      apiReflexionProvider.getReflexiones();
    });
    checkInternet();
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      new Timer(new Duration(seconds: 3), () {
        // set your desired delay time here
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new FirstPage()));
      });
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new FirstPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          alignment: Alignment.center, child: CircularProgressIndicator()),
    );
  }
}
