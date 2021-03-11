
import 'package:flutter/material.dart';

import 'package:escuela_ampb/src/models/notas_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:escuela_ampb/src/widgets/menu_custom.dart';

// ignore: must_be_immutable
class NotasPage extends StatefulWidget {
  @override
  _NotasPageState createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(height: 120, texto: "Notas",search: false,),
        body: _listNotas(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF4f002b),
          onPressed: (){
            print("agregar nota");
            Navigator.pushNamed(context, 'guardar_nota', arguments: Nota.empty()).then((value) => setState(() {}));
          },
          child: Icon(Icons.add),
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
            //backgroundColor: Colors.red,
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


  Widget _listNotas() {
    return FutureBuilder(
      future: DBProvider.db.getNotas(),
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          final List<Nota>cantidad = snapshot.data;
          return ListView.builder(
          itemCount: cantidad.length,//(notaList != null) ? notaList.length : 0,
          itemBuilder:(BuildContext context, int index) {

          return Dismissible(
            key: UniqueKey(),//Key(cantidad[index].id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              padding: EdgeInsets.only(right: 10),
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white,)),),
            //direction: Direc,
            onDismissed: (direction){
              setState(() {
                print("elimnado");
                DBProvider.db.deleteNota(cantidad[index].id);
              });
            },
            child: Card(
              child: ListTile(
                onTap: (){
                  print("ver el contenido");
                   showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                            title: new Text(cantidad[index].titulo),
                            content: new Text(cantidad[index].contenido),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cerrar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                },
                  title: Text(cantidad[index].titulo),
                  leading: CircleAvatar(
                    child: Text(cantidad[index].id.toString()),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (){
                      print("editar nota");
                      Navigator.pushNamed(
                        context,
                        'guardar_nota',
                        arguments: cantidad[index]).then((value) => setState(() {})  );
                    },
                  ),
                ),
            ),
          );
      }
    );

    } else {
      return Center(child: CircularProgressIndicator());
    }

      },
    );

  }




}