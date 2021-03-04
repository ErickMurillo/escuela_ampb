import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String texto;

  const MyCustomAppBar({
    Key key,
    @required this.height,
    @required this.texto
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
                  ) ,
          ),
        ),
      ],
    );
  }
  
 @override
  Size get preferredSize => Size.fromHeight(height);
}