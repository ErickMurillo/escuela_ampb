import 'package:flutter/material.dart';

import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:escuela_ampb/src/models/contenido_model.dart';

class ContenidoPage extends StatefulWidget {
  ContenidoPage({Key key}) : super(key: key);

  @override
  _ContenidoPageState createState() => _ContenidoPageState();
}

class _ContenidoPageState extends State<ContenidoPage> {
  @override
  Widget build(BuildContext context) {
    Contenido detalleContenido = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: introducionCurso(detalleContenido));
  }

  Widget introducionCurso(Contenido contenido) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            padding: EdgeInsets.all(15.0),
            child: Text(
              contenido.titulo,
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
            data: _getimg(contenido.contenido),
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

  String _getimg(String contenido) {
    var img = parse(contenido.replaceAll(
        'http://www.escuelamesoamericana.org/media/',
        'http://www.escuelamesoamericana.org/media/'));
    return img.outerHtml;
  }
}
