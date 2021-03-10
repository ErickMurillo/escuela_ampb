
import 'package:escuela_ampb/src/models/notas_model.dart';
import 'package:escuela_ampb/src/pages/addlist_notas.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:escuela_ampb/src/widgets/menu_custom.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotasPage extends StatefulWidget {
  @override
  _NotasPageState createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  int _selectedIndex = 2;
  
  //List<Nota> notaList;
  NotasListDialog dialog;
  NotasListDialog dialog1;

  // Future showData () async {
  //   notaList = await DBProvider.db.getNotas();
  // }

  @override
  void initState() {
    dialog = NotasListDialog();
    dialog1 = NotasListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(height: 120, texto: "Notas",search: false,),
        body: _listNotas(),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            print("agregar nota");
            showDialog(
              context: context,
              builder: (BuildContext context) => dialog.buildDialog(context, Nota(0,'',''), true)
            );
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
    final  notaList = DBProvider.db.getNotas();
    print("********************");
    var cantidad = notaList;
    print(cantidad);
    return ListView.builder(
      itemCount: (notaList != null) ? notaList.length : 0,
      itemBuilder:(BuildContext context, int index) {
        return Card(
          child: ListTile(
              title: Text(notaList[index].titulo),
              leading: CircleAvatar(
                child: Text(notaList[index].id.toString()),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                  print("editar hp");
                  showDialog(
                    context: context,
                    builder: (context) => dialog1.buildDialog(context, notaList[index], false)
                  );
                },
              ),
            ),
        );
      }
    );
     
  }




}