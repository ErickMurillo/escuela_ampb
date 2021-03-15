import 'package:escuela_ampb/src/models/contenido_model.dart';
import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/models/modulo_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    Curso intro = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
          title: Text(''),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: introducionCurso(intro),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Sesiones',
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF4f002b),
              ),
            ),
            ListTile(
              title: Text('Introducción'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                //   Navigator.pop(context);
                Navigator.pushNamed(context, 'intro', arguments: intro);
              },
            ),
            Divider(),
            FutureBuilder(
                future: DBProvider.db.filterModuloIdCurso(intro.id),
                builder: (context, snapshot) {
                  final List<Modulo> modulo = snapshot.data;
                  if (snapshot.hasData) {
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: modulo.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              ExpansionTile(
                                title: Text(modulo[index].titulo.toString()),
                                subtitle: FutureBuilder(
                                  future: _conteo(modulo[index].id),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(snapshot.data.toString() +
                                          ' Sesiones');
                                    } else {
                                      return Text('');
                                    }
                                  },
                                ),
                                children: <Widget>[
                                  _contenido(modulo[index].id, intro.id)
                                ],
                              ),
                              Divider(),
                            ],
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }

  _contenido(int id, int curso) => FutureBuilder(
        future: DBProvider.db.filterContendiIdModulo(id),
        builder: (context, content) {
          final List<Contenido> contenido = content.data;
          if (content.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: contenido.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        trailing: Icon(Icons.arrow_forward),
                        title: Text(contenido[index].titulo),
                        onTap: () => Navigator.pushNamed(context, 'contenido',
                            arguments: [contenido[index], curso]),
                      ),
                    ],
                  );
                });
          } else {
            return Column();
          }
        },
      );

  _conteo(int id) async {
    int x = await DBProvider.db.conteoContenido(id);
    return x;
  }

  Widget introducionCurso(Curso curso) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Introducción',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4f002b)),
            )),
        //SizedBox(height: 10.0),
        Divider(
          height: 5,
          thickness: 3,
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Html(
            data: _getimg(curso.descripcion),
            customRender: {
              "img": (RenderContext context, Widget child, attributes, _) {
                //File filetoimg = File(_.attributes['src']);
                String _imgBody = _.attributes['src'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    //   width: 1000,
                    imageUrl: _imgBody,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              },
            },
          ),
        ),
      ],
    ));
  }

  String _getimg(String curso) {
    var img = parse(curso.replaceAll(
        'http://www.escuelamesoamericana.org/media/',
        'http://www.escuelamesoamericana.org/media/'));
    return img.outerHtml;
  }
}
