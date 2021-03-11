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
  Future _notas;

  @override
  void initState() {
    super.initState();
    setState(() {});
    _fetchNotas();
  }

  onGoBack(dynamic value) {
    _fetchNotas();
    setState(() {});
  }

  Future<List<Nota>> _fetchNotas() async => _notas = DBProvider.db.getNotas();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 120,
          texto: "Notas",
          search: false,
        ),
        body: _listNotas(),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF4f002b),
            onPressed: () {
              //     Navigator.pushNamed(context, 'guardar_nota',
              //             arguments: Nota.empty())
              //         .then((value) => setState(() {}));
              //   },
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GuardaPage()))
                  .then(onGoBack);
            },
            child: Icon(Icons.add)),
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
          onTap: (_selectedIndex) {
            switch (_selectedIndex) {
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
      future: _notas,
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          final List<Nota> cantidad = snapshot.data;
          return ListView.builder(
              itemCount:
                  cantidad.length, //(notaList != null) ? notaList.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(), //Key(cantidad[index].id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: EdgeInsets.only(right: 10),
                    color: Colors.red,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                  ),
                  //direction: Direc,
                  onDismissed: (direction) {
                    setState(() {
                      print("elimnado");
                      DBProvider.db.deleteNota(cantidad[index].id);
                      _fetchNotas();
                    });
                  },
                  child: Card(
                    child: ListTile(
                      onTap: () {
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
                        onPressed: () {
                          print("editar nota");
                          //   Navigator.pushNamed(context, 'guardar_nota',
                          //           arguments: cantidad[index])
                          //       .then((value) => setState(() {}));
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GuardaPage(nota: cantidad[index])))
                              .then(onGoBack);
                        },
                      ),
                    ),
                  ),
                );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class GuardaPage extends StatefulWidget {
  final Nota nota;
  const GuardaPage({Key key, this.nota}) : super(key: key);

  @override
  _GuardaPageState createState() => _GuardaPageState();
}

class _GuardaPageState extends State<GuardaPage> {
  final _formKey = GlobalKey<FormState>();
  final dbNotas = DBProvider.db;
  final txtTitulo = TextEditingController();
  final txtContenido = TextEditingController();
  Nota _nota = Nota();

  @override
  Widget build(BuildContext context) {
    // Nota nota = ModalRoute.of(context).settings.arguments;
    // _init(nota);
    return Scaffold(
      appBar: AppBar(title: Text("Guardar Notas")),
      body: _guardarNota(),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.nota != null) {
        _nota = widget.nota;
        txtTitulo.text = _nota.titulo;
        txtContenido.text = _nota.contenido;
      }
    });
  }

  Widget _guardarNota() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "Introduzca un titulo";
              }
              return null;
            },
            controller: txtTitulo,
            decoration: InputDecoration(
                labelText: "Titulo",
                hintText: 'Titulo de la nota',
                border: OutlineInputBorder()),
            onSaved: (val) => setState(() => _nota.titulo = val),
          ),
          SizedBox(height: 17),
          TextFormField(
            maxLines: 10,
            validator: (value) {
              if (value.isEmpty) {
                return "Introduzca un contenido";
              }
              return null;
            },
            controller: txtContenido,
            decoration: InputDecoration(
                labelText: "Contenido",
                hintText: 'Contenido de la nota',
                border: OutlineInputBorder()),
            onSaved: (val) => setState(() => _nota.contenido = val),
          ),
          RaisedButton(
              child: Text("Guardar nota"),
              onPressed: () {
                _onSubmit();
              })
        ]),
      ),
    );
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_nota.id == null)
        await dbNotas.insertNota(_nota);
      else
        await dbNotas.updateNota(_nota);
    }
    Navigator.of(context).pop();
  }
}
