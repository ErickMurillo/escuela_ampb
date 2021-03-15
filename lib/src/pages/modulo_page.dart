import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
//import 'package:flutter_html/html_parser.dart';

import 'package:html/parser.dart';
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:escuela_ampb/src/providers/contenido_provider.dart';
import 'package:escuela_ampb/src/models/contenido_model.dart';
import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/models/modulo_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
//import 'package:network_to_file_image/network_to_file_image.dart';

class ModuloList extends StatefulWidget {
  ModuloList({Key key}) : super(key: key);

  @override
  _ModuloListState createState() => _ModuloListState();
}

class _ModuloListState extends State<ModuloList> {
  ContenidoProvider contenidoProvider = ContenidoProvider();
  dynamic resContenido;
  List<int> idsModulos = List<int>();
  final keyScaffold = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    List cursoDetalle = ModalRoute.of(context).settings.arguments;
    int cursoid = cursoDetalle[0];
    String cursoName = cursoDetalle[1];

    Future getFilterModulos() async {
      List<Modulo> filterModulos = List<Modulo>();
      List<Contenido> filterContenidos = List<Contenido>();

      filterModulos = await DBProvider.db.filterModuloIdCurso(cursoid);
      filterModulos.forEach((item) {
        idsModulos.add(item.id);
      });

      filterContenidos =
          await DBProvider.db.filterContenidoIdModulo(idsModulos);

      return [filterModulos, filterContenidos];
    }

    return FutureBuilder(
      future: getFilterModulos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var listModulos = snapshot.data[0];
          var listContenido = snapshot.data[1];
          return Scaffold(
            key: keyScaffold,
            appBar: AppBar(
              title: Text(''),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.download_sharp,
                    color: Colors.white,
                  ),
                  tooltip: 'Descargar Curso',
                  onPressed: () async {
                    resContenido =
                        await contenidoProvider.getContenidos(cursoid);
                    //print("Descargar contenido");
                    keyScaffold.currentState.showSnackBar(SnackBar(
                      content: Text("Contenido Descargado!"),
                    ));
                    setState(() {});
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    introducionCurso(cursoid),
                    _cardmodulo(listModulos, listContenido, context, cursoid),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.search),
                //   label: 'Buscar',
                // ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Lista',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Notas',
                ),
              ],
              currentIndex: _selectedIndex,
              unselectedItemColor: Colors.black26,
              selectedItemColor: Colors.amber[800],
              showUnselectedLabels: false,
              onTap: (_selectedIndex) {
                switch (_selectedIndex) {
                  case 0:
                    Navigator.pushNamed(context, "/");
                    break;
                  case 1:
                    Navigator.pushNamed(context, "lista_cursos");
                    break;
                  case 2:
                    Navigator.pushNamed(context, "notas");
                    break;
                }
              },
            ),
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Directory _appDocsDir;
  File fileFromDocsDir(String filename) {
    String pathName = p.join(_appDocsDir.path, filename);
    return File(pathName);
  }

  Widget introducionCurso(int curso) {
    var width = MediaQuery.of(context).size.width;
    final filterCurso = DBProvider.db.getCursoId(curso);
    return SingleChildScrollView(
        child: FutureBuilder(
      future: filterCurso,
      builder: (BuildContext context, AsyncSnapshot<Curso> snapshot) {
        if (snapshot.hasData) {
          final Curso curso = snapshot.data;
          return Column(
            children: [
              Stack(
                children: [
                  CachedNetworkImage(imageUrl: curso.imagen),
                  Container(
                    margin: EdgeInsets.all(50.0),
                    child: Text(curso.titulo,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ),
                  Positioned(
                    top: 340,
                    child: Container(
                        width: width * 1,
                        height: 380,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(40.0),
                                topRight: const Radius.circular(40.0)),
                            color: Colors.white)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  color: Color(0xfff7d0b0),
                  child: ListTile(
                    trailing: Icon(Icons.arrow_forward_ios_outlined),
                    title: Text("Introducción"),
                    onTap: () =>
                        Navigator.pushNamed(context, 'intro', arguments: curso),
                    // onExpansionChanged: () => Navigator.pushNamed(
                    //     context, 'contenido',
                    //     arguments: curso.descripcion),

                    // initiallyExpanded: true,
                    // children: [
                    //   Container(
                    //     color: Colors.white,
                    //     child: Html(
                    //       data: _getimg(curso.descripcion),
                    //     ),
                    //   )
                    //   InkWell(
                    //     onTap: () => Navigator.pushNamed(context, 'intro',
                    //         arguments: curso),
                    //   ),
                    // ],
                  ),
                ),
              )
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    ));
  }

  String _getimg(String contenido) {
    var img = parse(contenido.replaceAll(
        'http://www.escuelamesoamericana.org/media/',
        'http://www.escuelamesoamericana.org/media/'));
    return img.outerHtml;
  }

  _conteo(int id) async {
    int x = await DBProvider.db.conteoContenido(id);
    return x;
  }

  Widget _cardmodulo(
      List modulo, List contenido, BuildContext context, int idCurso) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final cardCurso = Card(
              color: Color(0xfff7d0b0),
              child: ExpansionTile(
                  title: Text('${modulo[index].titulo}'),
                  subtitle: FutureBuilder(
                    future: _conteo(modulo[index].id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.toString() + ' Sesiones');
                      } else {
                        return Text('');
                      }
                    },
                  ),
                  children: [
                    Column(
                      children: <Widget>[
                        _prueba(modulo[index].id, contenido, context, idCurso)
                      ],
                    ),
                  ]));
          return GestureDetector(
            child: cardCurso,
            onTap: () {},
          );
        },
        shrinkWrap: true,
        itemCount: modulo.length,
        // padding: EdgeInsets.only(bottom: 5.0),
        controller: ScrollController(keepScrollOffset: false),
      ),
    );
  }

  Widget _prueba(int idModulo, contenido, BuildContext context, int cursoid) {
    List<Widget> lisItem = List<Widget>();
    for (var item in contenido) {
      if (item.modulo == idModulo) {
        lisItem.add(GestureDetector(
          child: ListTile(
            trailing: Icon(Icons.arrow_forward),
            title: Text(item.titulo),
          ),
          onTap: () => Navigator.pushNamed(context, 'contenido',
              arguments: [item, cursoid]),
        ));
      }
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: lisItem,
      ),
    );
  }
}
