
import 'package:escuela_ampb/src/widgets/menu_custom.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotasPage extends StatelessWidget {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(height: 120, texto: "Notas",search: false,),
        body: Center(
          child: Container(
            child: Text("Notas pages"),
          ),
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
}