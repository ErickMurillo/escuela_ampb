import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:escuela_ampb/src/models/curso_model.dart';


class DirectorioList extends StatelessWidget {
  final List<Curso> cursos;
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  DirectorioList({Key key, this.cursos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cursos.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
          leading: CircleAvatar(
                    child: CachedNetworkImage(
                    imageUrl: cursos[index].imagen,
                    placeholder: (context, url) => CircularProgressIndicator()
                    ),
                    backgroundColor: Colors.transparent,
                  ),
          title: Text("${cursos[index].titulo}",
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w400
                      ),
                  ),
          onTap: (){
            Navigator.pushNamed(context, 'modulos', arguments: [cursos[index].id, cursos[index].titulo]);
          },
          trailing: Icon(Icons.keyboard_arrow_right),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          //selected: true,
        ),
        );
      },
    );
  }
}