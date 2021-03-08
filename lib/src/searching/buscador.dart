import 'package:flutter/material.dart';

import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:escuela_ampb/src/widgets/lista_cursos.dart';
import 'package:escuela_ampb/src/models/curso_model.dart';

class BuscadorCurso extends SearchDelegate<Curso> {

  @override
  final String searchFieldLabel;

  BuscadorCurso(this.searchFieldLabel);


  @override
  List<Widget> buildActions(BuildContext context) {
      return [
        IconButton(
          icon: Icon(Icons.clear_sharp),
          onPressed: (){
            //print("Presione el accion!");
            query = '';
          }
        )
      ];
    }

    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          close(context, null);
        }
      );
    }

    @override
    Widget buildResults(BuildContext context) {
      //por si alguien da enter
      if ( query.trim().length == 0 ) {
        return Center(child: Text("Por favor escriba algo para buscar!"));
      }
      return FutureBuilder<List<Curso>>(
      future: DBProvider.db.getCursosName(query),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if ( snapshot.hasError ) {
          return ListTile(
            title: Text("Busqueda no encontrada"),
          );
        }
        return snapshot.hasData
              ? DirectorioList(cursos: snapshot.data)
              : Center(child: CircularProgressIndicator());

      }
    );
    }

    @override
    Widget buildSuggestions(BuildContext context) {

      if (query.isEmpty || query.length == 0) {
        return Center(
          child: Text("Aun no busca nada!"),
        );
      }

      return FutureBuilder<List<Curso>>(
      future: DBProvider.db.getCursosName(query),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if ( snapshot.connectionState == ConnectionState.none && snapshot.hasData == null ) {
          return Center(child: CircularProgressIndicator());
        }
        return snapshot.hasData
              ? DirectorioList(cursos: snapshot.data)
              : Center(child: CircularProgressIndicator());

      }
    );

  }

}