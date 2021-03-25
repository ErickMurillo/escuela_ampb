class Curso {
  Curso(
      {this.id,
      this.titulo,
      this.imagen,
      this.descripcion,
      this.fecha,
      this.activo,
      this.destacado});

  int id;
  String titulo;
  String imagen;
  String descripcion;
  String fecha;
  String activo;
  String destacado;

  factory Curso.fromJson(Map<String, dynamic> json) => Curso(
        id: json["id"],
        titulo: json["titulo"],
        imagen: json["imagen"],
        descripcion: json["descripcion"],
        fecha: json["fecha"].toString(),
        activo: json["activo"].toString(),
        destacado: json["destacado"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "titulo": titulo,
        "imagen": imagen,
        "descripcion": descripcion,
        "fecha": fecha,
        "activo": activo,
        "destacado": destacado,
      };
}

class Cursos {
  List<Curso> items = new List();

  Cursos.fromJsonList(List<dynamic> jsonList) {
    for (var item in jsonList) {
      final curso = new Curso.fromJson(item);
      items.add(curso);
    }
  }
}
