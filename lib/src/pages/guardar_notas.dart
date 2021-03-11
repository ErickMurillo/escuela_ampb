import 'package:flutter/material.dart';

import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:escuela_ampb/src/models/notas_model.dart';

class GuardaPage extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final dbNotas = DBProvider.db;
  final txtTitulo = TextEditingController();
  final txtContenido = TextEditingController();


  @override
  Widget build(BuildContext context) {

    Nota nota = ModalRoute.of(context).settings.arguments;
    _init(nota);
    return Scaffold(
      appBar: AppBar(title: Text("Guardar Notas")),
      body: _guardarNota(nota),
    );
  }

  _init(Nota nota){
    txtTitulo.text = nota.titulo;
    txtContenido.text = nota.contenido;
  }

  Widget _guardarNota(Nota nota){
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                validator: (value){
                  if(value.isEmpty){
                    return "Introduzca un titulo";
                  }
                  return null;
                },
                controller: txtTitulo,
                decoration: InputDecoration(
                  labelText: "Titulo",
                  hintText: 'Titulo de la nota',
                  border: OutlineInputBorder()
                )
              ),
              SizedBox(height:17),
              TextFormField(
                maxLines: 10,
                validator: (value){
                  if(value.isEmpty){
                    return "Introduzca un contenido";
                  }
                  return null;
                },
                controller: txtContenido,
                decoration: InputDecoration(
                  labelText: "Contenido",
                  hintText: 'Contenido de la nota',
                  border: OutlineInputBorder()
                )
              ),
              RaisedButton(
                child: Text("Guardar nota"),
                onPressed: (){
                  if (_formKey.currentState.validate()) {
                    print("Guardando nota");
                    if (nota.id != null) {
                      nota.titulo = txtTitulo.text;
                      nota.contenido = txtContenido.text;
                      dbNotas.updateNota(nota);
                    } else {
                      dbNotas.insertNota(Nota(
                      titulo: txtTitulo.text,
                      contenido:txtContenido.text));
                    }

                  }
                }
              )
          ]
        ),
      ),
    );
  }

}