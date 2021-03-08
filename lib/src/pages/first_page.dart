import 'package:cached_network_image/cached_network_image.dart';
import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/models/reflexion_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:escuela_ampb/src/providers/modulo_provider.dart';
import 'package:escuela_ampb/src/providers/reflexion_provider.dart';
import 'package:flutter/material.dart';
// import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/providers/curso_provider.dart';
import 'package:escuela_ampb/src/widgets/light_color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';


final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class FirstPage extends StatefulWidget {


  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;
  var apiCursoProvider = CursoProvider();
  var apiModuloProvider = ModuloProvider();
  var apiReflexionProvider = ReflexionProvider();
  var connectivityResult = (Connectivity().checkConnectivity());

  static const TextStyle titleOptionStyle =
      TextStyle(color: Colors.black45,fontSize: 18, fontWeight: FontWeight.bold);

  static const TextStyle subtitleOptionStyle =
      TextStyle(color: Colors.black45,fontSize: 14, fontWeight: FontWeight.bold);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Buscar',
      style: optionStyle,
    ),
    Text(
      'Index 2: Lista',
      style: optionStyle,
    ),
    Text(
      'Index 3: Libros',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // ignore: unrelated_type_equality_checks
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   apiCursoProvider.getCursos();
    //   apiModuloProvider.getModulos();
    //   apiReflexionProvider.getReflexiones();
    // // ignore: unrelated_type_equality_checks
    // } else if (connectivityResult == ConnectivityResult.wifi) {
      apiCursoProvider.getCursos();
      apiModuloProvider.getModulos();
      apiReflexionProvider.getReflexiones();
    // }

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _header(),
              SizedBox(height: 10.0),
              _frasesCelebres(),
              SizedBox(height: 10.0),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Cursos destacados",style: titleOptionStyle),
                    Text("ver todos",style: subtitleOptionStyle),
                  ],
                )),
              _cursosDestacados(),
              SizedBox(height: 10.0),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Cursos",style: titleOptionStyle),
                    Text("ver todos",style: subtitleOptionStyle),
                  ],
                )),
                _cursosTotales()



            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Lista',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Libros',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black26,
          selectedItemColor: Colors.amber[800],
          onTap:(_selectedIndex){
            switch(_selectedIndex){
              case 0:
                Navigator.pushNamed(context, "/");
                break;
              case 1:
                Navigator.pushNamed(context, "buscador");
                break;
              case 2:
                Navigator.pushNamed(context, "lista_cursos");
                break;
               case 3:
                Navigator.pushNamed(context, "notas");
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _header() {

    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 240.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                        bottomLeft:  const  Radius.circular(40.0),
                        bottomRight: const  Radius.circular(40.0)),
            color: Color(0xFF4f002b)
          )
        ),
        Positioned(
            top: 20,
            right: -50,
            child: _circularContainer(200, LightColor.lightpurple)),
        Positioned(
            top: -100,
            left: -45,
            child: _circularContainer(width * .5, LightColor.darkpurple)),
        Positioned(
            top: -180,
            right: -30,
            child: _circularContainer(width * .7, Colors.transparent,
                borderColor: Colors.white38)),
        Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bienvenidos a", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 18.0),
              Text("Formación", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 22.0),
              TextField(
                autofocus: false,
                style: TextStyle(fontSize: 14.0, color: Colors.black87, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '¡Busque nuevos conocimientos!',
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ]
          )
        )

      ]
    );
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  Widget _frasesCelebres() {
    final dbFrases = DBProvider.db.getTodosReflexiones();
    return FutureBuilder(
      future: dbFrases,
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<Reflexion>> snapshot) {
        if (snapshot.data != null) {
          final data = snapshot.data;
          return CarouselSlider(
            options: CarouselOptions(height: 180.0, autoPlay: false,),
            items: data.map((index) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xff8cc63f)
                    ),
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: Center(child: Text(index.texto,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),)),
                    )
                  );
                },
              );
            }).toList(),
          );

        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _cursosDestacados() {
    final dbCursosDestacados = DBProvider.db.getTodosCursos();
    return FutureBuilder(
      future: dbCursosDestacados,
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<Curso>>  snapshot) {
        if ( snapshot.data != null ) {
          final data = snapshot.data;
          return CarouselSlider(
                options: CarouselOptions(height: 200.0),
                items: data.map((index) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Card(
                          elevation: 0.5,
                          child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  width: double.infinity,
                                  fit: BoxFit.fitWidth,
                                  imageUrl: index.imagen,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                              Text(index.titulo, style: TextStyle(fontSize: 14.0),)
                            ],
                          )
                        ),
                      );
                    },
                  );
                }).toList(),
          );

        } else {
          return CircularProgressIndicator();
        }
      },
    );

  }

  Widget _cursosTotales() {
    final dbCursosTotales = DBProvider.db.getTodosCursos();

    return FutureBuilder(
      future: dbCursosTotales,
      //initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<Curso>>  snapshot) {
        if ( snapshot.data != null ) {
          final data = snapshot.data;
          return CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true),
                items: data.map((index) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            children: <Widget>[
                              CachedNetworkImage(imageUrl: index.imagen, fit: BoxFit.cover, width: 1000.0),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                  child: Text(
                                    index.titulo,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ),
                      );
                    },
                  );
                }).toList(),
          );

        } else {
          return CircularProgressIndicator();
        }
      },
    );





    // return  CarouselSlider(
    //         options: CarouselOptions(
    //           autoPlay: true,
    //           aspectRatio: 2.0,
    //           enlargeCenterPage: true,
    //         ),
    //         items: imageSliders,
    //       );
  }

  final List<Widget> imageSliders = imgList.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Stack(
        children: <Widget>[
          Image.network(item, fit: BoxFit.cover, width: 1000.0),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                'Curso. ${imgList.indexOf(item)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      )
    ),
  ),
)).toList();


}