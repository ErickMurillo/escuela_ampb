import 'package:cached_network_image/cached_network_image.dart';
import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ListaCursoPage extends StatelessWidget {
  Future<List<Curso>> cursos = DBProvider.db.getTodosCursos();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lista de Cursos"),
        ),
        body: FutureBuilder<List<Curso>>(
          future: DBProvider.db.getTodosCursos(),
          builder: (BuildContext context, AsyncSnapshot<List<Curso>> snapshot) {
            if (snapshot.data != null) {
              final curso = snapshot.data;
              return ListView.builder(
                itemCount: curso.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: CachedNetworkImage(
                        imageUrl: curso[index].imagen,
                        placeholder: (context, url) => CircularProgressIndicator()
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(curso[index].titulo),
                    subtitle: Html(
                      data:curso[index].fecha
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    isThreeLine: true,
                  );
                } 
              );
            } else {
              return Center( child: CircularProgressIndicator() );
            }
            
          }
        ),
      ),
    );
  }
}