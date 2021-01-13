

class Modulo {
    Modulo({
        this.id,
        this.curso,
        this.titulo,
        this.orden,
    });

    int id;
    int curso;
    String titulo;
    int orden;

    factory Modulo.fromJson(Map<String, dynamic> json) => Modulo(
        id: json["id"],
        curso: json["curso"],
        titulo: json["titulo"],
        orden: json["orden"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "curso": curso,
        "titulo": titulo,
        "orden": orden,
    };
}