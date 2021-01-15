import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:escuela_ampb/src/providers/contenido_provider.dart';
import 'package:escuela_ampb/src/providers/curso_provider.dart';
import 'package:escuela_ampb/src/providers/modulo_provider.dart';


class HomePage extends StatefulWidget {
    HomePage({Key key}) : super(key: key);


    @override
    _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    CursoProvider cursoProvider = CursoProvider();
    ModuloProvider moduloProvider =  ModuloProvider();
    ContenidoProvider contenidoProvider =  ContenidoProvider();
    String baseUrl = 'http://ampb.caps-nicaragua.org';
    dynamic resCurso;
    dynamic resModulo;
    dynamic resContenido;

    @override
    Widget build(BuildContext context) {


        Future getData() async {
            resCurso = await cursoProvider.getCursos();
            resModulo = await moduloProvider.getModulos();
            //resContenido = await contenidoProvider.getContenidos();
            List<Curso> allCursos = await DBProvider.db.getTodosCursos();

            print("cuantos cursos regresa");
            print(allCursos.length);

            return allCursos;
            
        }
        return FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  print("Existe datos");
                  print(snapshot.data);
                  
                    return Scaffold(
                        appBar: AppBar(
                            title: Text("Lista de Cursos"),
                        ),
                        body: _listaDeCursos(snapshot.data, context),
                    );
                } else {
                    return Center(
                        child: CircularProgressIndicator(),
                    );
                }
            },
        );



    }

    Widget  _listaDeCursos(List cursos, BuildContext context){
        print(cursos);
        print("alla arriba salen los cursos");
        return ListView.builder(
            itemBuilder: (context, index) {
                return _cardCurso(cursos[index]);
            },
            shrinkWrap: true,
            itemCount: cursos.length,
            padding: EdgeInsets.only(bottom: 30.0),
            controller: ScrollController(keepScrollOffset: false),
        );

    }

    Widget  _cardCurso(Curso curso){

        String urlImg = baseUrl + curso.imagen;
        
        return GestureDetector(
            child: Card(
                child: Column(
                    children: <Widget>[
                        CachedNetworkImage(
                            imageUrl: urlImg,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        Text(curso.titulo),
                    ],
                ),
            ),
            onTap: () => Navigator.pushNamed(context, 'modulos', arguments: [curso.id, curso.titulo]),
        );
    }
}