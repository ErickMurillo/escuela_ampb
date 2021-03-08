import 'package:escuela_ampb/src/searching/buscador.dart';
import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String texto;
  final bool search;

  const MyCustomAppBar({
    Key key,
    @required this.height,
    @required this.texto,
    this.search
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                  bottomLeft:  const  Radius.circular(40.0),
                  bottomRight: const  Radius.circular(40.0)),
            color: Color(0xFF4f002b)
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: AppBar(
                    title: Text(this.texto),
                    shadowColor: Colors.transparent,
                    actions: (this.search) ? [
                      
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: (){
                            showSearch(context: context, delegate: BuscadorCurso('Buscar...') );
                          }
                        )
                    
                        
                    ]: [],
                  ) ,
          ),
        ),
      ],
    );
  }

 @override
  Size get preferredSize => Size.fromHeight(height);
}