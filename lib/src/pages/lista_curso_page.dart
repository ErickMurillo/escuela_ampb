import 'package:escuela_ampb/src/widgets/menu_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';

// ignore: must_be_immutable
class ListaCursoPage extends StatelessWidget {
  int _selectedIndex = 1;
  Future<List<Curso>> cursos = DBProvider.db.getTodosCursos();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(height: 120, texto: "Lista de cursos", search: true,),
        body: FutureBuilder<List<Curso>>(
          future: DBProvider.db.getTodosCursos(),
          builder: (BuildContext context, AsyncSnapshot<List<Curso>> snapshot) {
            if (snapshot.data != null) {
              final curso = snapshot.data;
              return ListView.builder(
                itemCount: curso.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => Navigator.pushNamed(context, 'modulos', arguments: [curso[index].id, curso[index].titulo]),
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
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
          onTap:(_selectedIndex){
            switch(_selectedIndex){
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
      ),
    );
  }
}