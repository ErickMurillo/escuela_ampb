
class Nota {
  int id;
  String titulo;
  String contenido;


  Nota( this.id,  this.titulo,  this.contenido );

  Map<String, dynamic> toMap() {
    return {
    'id': (id==0)?null:id,
    'titulo': titulo,
    'contenido': contenido,
    };
  }


}