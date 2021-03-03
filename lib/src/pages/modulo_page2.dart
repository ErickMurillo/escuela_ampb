import 'dart:io';
import 'package:flutter/material.dart';

// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/html_parser.dart';

// import 'package:html/parser.dart';
// import 'package:path/path.dart' as p;
// import 'package:cached_network_image/cached_network_image.dart';

// import 'package:escuela_ampb/src/providers/contenido_provider.dart';
// import 'package:escuela_ampb/src/models/contenido_model.dart';
// import 'package:escuela_ampb/src/models/curso_model.dart';
// import 'package:escuela_ampb/src/models/modulo_model.dart';
// import 'package:escuela_ampb/src/providers/DBProvider.dart';


class ModulePage2 extends StatefulWidget {
  @override
  _ModulePage2State createState() => _ModulePage2State();
}

class _ModulePage2State extends State<ModulePage2> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("algo"),
      ),
      body: Stack(
        children: [
          Image.asset("assets/curso.jpg"),
          Column(
            children: [
               SizedBox(
            height: size.height * 0.2),
          Expanded(
            child: Container(
             
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                          topLeft:  const  Radius.circular(40.0),
                          topRight: const  Radius.circular(40.0)),
              color: Colors.white
            ),
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text("texto $index"),
                  );
                },
              )

            ),
          )
            ],
          ),
         
        ],
      ),
      
    );
  }
}