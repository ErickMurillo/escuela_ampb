
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';

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

    ContenidoProvider contenidoProvider =  ContenidoProvider();
    dynamic resContenido;
    List<int> idsModulos = List<int>();

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

            filterContenidos = await DBProvider.db.filterContenidoIdModulo(idsModulos);

            return [filterModulos, filterContenidos];
        }

        return FutureBuilder(
            future: getFilterModulos(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                    var listModulos = snapshot.data[0];
                    var listContenido = snapshot.data[1];
                    return Scaffold(
                        appBar: AppBar(
                            title: Text(cursoName),
                            actions: [
                                IconButton(
                                    icon: Icon(Icons.download_sharp ,color: Colors.white,),
                                    tooltip: 'Descargar Curso',
                                    onPressed: () async {
                                      resContenido = await contenidoProvider.getContenidos(cursoid);
                                      print("Descargar contenido");


                                      setState(() {

                                      });
                                    },
                                )
                            ],
                        ),

                        body: SingleChildScrollView(
                            child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                    children: <Widget>[
                                      introducionCurso(cursoid),
                                        _cardmodulo(listModulos, listContenido, context),

                                    ],
                                ),
                            ),
                        ),

                    );
                } else {
                    return Scaffold(
                        body: Center(
                            child: CircularProgressIndicator()
                        ),
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

    Widget introducionCurso(int curso){

        final filterCurso = DBProvider.db.getCursoId(curso);
        //print("curso desde la pagina");
        //print(filterCurso);
        return SingleChildScrollView(

            child: FutureBuilder(
              future: filterCurso,
              builder: (BuildContext context, AsyncSnapshot<Curso> snapshot) {
                if ( snapshot.hasData ) {
                  final Curso curso = snapshot.data;
                  //print("Detalle del curso");
                  //print(curso.titulo);
                  return Column(
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                              curso.titulo ,
                              style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30)
                          ),
                      ),
                      Html(
                          data: _getimg(curso.descripcion),
                          customRender: {
                              "img": (RenderContext context, Widget child, attributes, _)  {

                                  //File filetoimg = File(_.attributes['src']);
                                  String _imgBody = _.attributes['src'];

                                  return CachedNetworkImage(
                                      imageUrl: _imgBody,
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                  );

                              },
                          },
                      ),
                  ],
              );
                } else {
                  return CircularProgressIndicator();
                }

               },
            )
        );
    }

    String _getimg( String contenido) {
        var img = parse(contenido.replaceAll(
        'http://www.escuelamesoamericana.org/media/', 'http://www.escuelamesoamericana.org/media/'));
        return img.outerHtml;
    }


    Widget _cardmodulo(List modulo, List contenido, BuildContext context) {
        return ListView.builder(
            itemBuilder: (context, index) {
                final cardCurso = Card(
                    child: Column(
                        children: <Widget>[
                        Text('${modulo[index].titulo} -- ${modulo[index].id}'),
                        SizedBox(
                            height: 20.0,
                        ),
                        _prueba(modulo[index].id, contenido, context)

                        ],
                    ),
                );
                //print(modulo[index].id);
                return GestureDetector(
                child: cardCurso,
                onTap: () {
                  print("click modulo");
                },
                );
            },
            shrinkWrap: true,
            itemCount: modulo.length,
            padding: EdgeInsets.only(bottom: 20.0),
            controller: ScrollController(keepScrollOffset: false),
        );
    }

    Widget _prueba(int idModulo, contenido, BuildContext context) {
        List<Widget> lisItem = List<Widget>();
        //print(idModulo);
        for (var item in contenido) {

            if (item.modulo == idModulo) {
                //print(item.titulo);
                lisItem.add(
                    GestureDetector(
                        child:  ListTile(
                            title: Text(item.titulo),
                        ),
                        onTap: () => Navigator.pushNamed(context, 'contenido', arguments: item),
                    )
                );

            }



        }

        return Column(children:lisItem,);
    }

}