
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
                title: Text(detalleContenido.titulo),
            ),
            body: introducionCurso(detalleContenido)
        );
        //print(detalleContenido.titulo);

        // Future getContenidos() async {

        //     List<Contenido> contenidonull = List<Contenido> ();

        //     Contenido contenidoId = await DBProvider.db.getContenidoId(1);
            
        //     if (contenidoId == null) {

        //         //print('es null');
        //         return contenidonull;
        //     }

        //     //print(contenido[0].titulo);
        //     //print(contenidoId.titulo);

        //     //return contenido;
        //     return contenidoId;
        // }
        
        
        // return FutureBuilder(
        //     future: getContenidos(),
        //     builder: (BuildContext context, AsyncSnapshot snapshot) {
        //         if (snapshot.hasData) {
        //             return Scaffold(
        //                 appBar: AppBar(
        //                     title: Text(snapshot.data.titulo),
        //                 ),
        //                 body: introducionCurso(snapshot.data)
        //             );
        //         } else {

        //             return Scaffold(
        //                 body: Center(
        //                     child: CircularProgressIndicator(),
        //                 ),
        //             );

        //         }
                
        //     },
        // );
        
    }

    Widget introducionCurso(Contenido contenido){
        return SingleChildScrollView(
            
            child: Column(
                children: [
                    // Container(
                    //     padding: EdgeInsets.symmetric(vertical: 20.0),
                    //     child: Text(
                    //         contenido.titulo, 
                    //         style: TextStyle(
                    //         color: Colors.black,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 30)
                    //     ),
                    // ),
                    Html(
                        data: _getimg(contenido.contenido),
                        customRender: {
                            "img": (RenderContext context, Widget child, attributes, _)  {
                            
                                //File filetoimg = File(_.attributes['src']);
                                String _imgBody = _.attributes['src'];

                                return CachedNetworkImage(
                                    imageUrl: _imgBody,
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                );
                                
                            },
                        },
                    ),
                ],
            )
        );
    }

    String _getimg( String contenido) {
        var img = parse(contenido.replaceAll(
        '/media/', 'http://ampb.caps-nicaragua.org/media/'));
        return img.outerHtml;
    }
}