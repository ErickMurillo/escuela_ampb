import 'package:flutter/material.dart';

import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:escuela_ampb/src/models/notas_model.dart';

class NotasListDialog {

  final txtTitulo = TextEditingController();
  final txtContenido = TextEditingController();

  Widget buildDialog(BuildContext context, Nota list, bool isNew) {
    final dbNotas = DBProvider.db;

    if (!isNew) {
      txtTitulo.text = list.titulo;
      txtContenido.text = list.contenido;
    }

    return AlertDialog(
      title: Text((isNew) ? 'Nueva nota' : 'Editar Nota'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtTitulo,
              decoration: InputDecoration(
              hintText: 'Titulo de la nota'
              )
            ),
            TextField(
              controller: txtContenido,
              decoration: InputDecoration(
              hintText: 'Contenido de la nota'
              )
            ),
            RaisedButton(
              child: Text("Guardar nota"),
              onPressed: (){
                list.titulo = txtTitulo.text;
                list.contenido = txtContenido.text;
                dbNotas.insertNota(list);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
    );

  }

}