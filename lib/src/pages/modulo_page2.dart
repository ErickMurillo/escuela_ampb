//import 'dart:io';
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
          Padding(
            padding: EdgeInsets.only(top: 100),
              child: Text("Titulo del curso", style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.0)),
          ),
          Column(
            children: [
                SizedBox(
                  height: size.height * 0.3
                ),
              Card(
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: Text("modulo 1"),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context,index){
                        return Card(
                          child: ListTile(
                            title: Text("texto $index"),
                          ),
                        );
                    },
                  ),
                  ]
                )
              ),
              Card(
                child: ExpansionTile(
                  title: Text("modulo 2"),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context,index){
                        return Card(
                          child: ListTile(
                            title: Text("texto $index"),
                          ),
                        );
                    },
                  ),
                  ]
                )
              )

            ],
          ),

        ],
      ),

    );
  }
}