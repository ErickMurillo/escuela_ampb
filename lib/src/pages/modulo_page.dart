
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';

import 'package:html/parser.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:escuela_ampb/src/models/contenido_model.dart';
import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/models/modulo_model.dart';
import 'package:escuela_ampb/src/providers/DBProvider.dart';



class ModuloList extends StatefulWidget {
    ModuloList({Key key}) : super(key: key);

    @override
    _ModuloListState createState() => _ModuloListState();
}

class _ModuloListState extends State<ModuloList> {

    
    List<int> idsModulos = List<int>();

    //bool _loadData;
    //int prueba;
    
    // @override
    // void initState() { 
    //     super.initState();
    //     _loadData = false;
    //     prueba = 0;
    // }

    // Future <Curso> getCurso() async {

    //     Curso cursoUno = await DBProvider.db.getCursoId(idCurso);
    //     if (cursoUno == null) {
    //         print("no existe");
    //     } else {
    //         return cursoUno;
    //     } 
    // }

    

    @override
    Widget build(BuildContext context) {
        //getFilterContenidos();
        List cursoDetalle = ModalRoute.of(context).settings.arguments;
        int cursoid = cursoDetalle[0];
        String cursoName = cursoDetalle[1];
        //print(cursoid);
        //print(cursoName);

        Future getFilterModulos() async {
            List<Modulo> filterModulos = List<Modulo>();
            List<Contenido> filterContenidos = List<Contenido>();   

            filterModulos = await DBProvider.db.filterModuloIdCurso(cursoid);
            filterModulos.forEach((item) { 
                //print(item.titulo);
                idsModulos.add(item.id);
            });

            filterContenidos = await DBProvider.db.filterContenidoIdModulo(idsModulos);

            
            //print(filterModulos.runtimeType);
            return [filterModulos, filterContenidos];
        }

        return FutureBuilder(
            future: getFilterModulos(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {

                    //Curso uncurso = snapshot.data[0];
                    var listModulos = snapshot.data[0];
                    var listContenido = snapshot.data[1];
                    //listModulos.forEach((item)=>print(item.titulo));
                    

                    return Scaffold(
                        appBar: AppBar(
                            title: Text(cursoName),
                            actions: [
                                IconButton(
                                    icon: Icon(Icons.autorenew ,color: Colors.white,),
                                    tooltip: 'Descargar Curso',
                                    onPressed: (){},
                                )
                            ],
                        ),
                        //body:  introducionCurso(uncurso),
                        body: SingleChildScrollView(
                            child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                    children: <Widget>[
                                        _cardmodulo(listModulos, listContenido, context),
                                    ],
                                ),
                            ),
                        ),
                                
                            
                    

                     
                    );
                } else {
                    return Scaffold(
                        body: Center(
                            child: CircularProgressIndicator()
                        ),   
                    );
                }
            },
        );

    }

    Widget introducionCurso(Curso curso){
        return SingleChildScrollView(
            
            child: Column(
                children: [
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                            curso.titulo, 
                            style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30)
                        ),
                    ),
                    Html(
                        data: _getimg(curso.descripcion),
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


    Widget _cardmodulo(List modulo, List contenido, BuildContext context) {
        return ListView.builder(
            itemBuilder: (context, index) {
                final cardCurso = Card(
                    child: Column(
                        children: <Widget>[
                        Text('Modulo ${modulo[index].titulo} -- ${modulo[index].id}'),
                        SizedBox(
                            height: 20.0,
                        ),
                        _prueba(modulo[index].id, contenido, context)
                        //Text(cursos[index].descripcion),
                        ],
                    ),
                );
                //print(modulo[index].id);
                return GestureDetector(
                child: cardCurso,
                onTap: () => {},
                );
            },
            shrinkWrap: true,
            itemCount: modulo.length,
            padding: EdgeInsets.only(bottom: 20.0),
            controller: ScrollController(keepScrollOffset: false),
        );
    }

    Widget _prueba(int idModulo, contenido, BuildContext context) {
        List<Widget> lisItem = List<Widget>();
        //print(idModulo);
        for (var item in contenido) {
           
            if (item.modulo == idModulo) {
                //print(item.titulo);
                lisItem.add(
                    GestureDetector(
                        child:  ListTile(
                            title: Text(item.titulo),
                        ),
                        onTap: () => Navigator.pushNamed(context, 'contenido', arguments: item),
                    )
                );
                
            }
            
            
            
        }
        //print(lisItem);
        
        //print(a);

        return Column(children:lisItem,);
    }

}