import 'package:flutter/material.dart';

class ListaCursoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lista de Cursos"),
        ),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (_, index) {
            return Card(
              child: ListTile(
                leading: FlutterLogo(size: 72.0),
                title: Text('Three-line ListTile'),
                subtitle: Text(
                  'A sufficiently long subtitle warrants three lines.'
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                isThreeLine: true,
              ),
            );
          }
        ),
      ),
    );
  }
}