
class Contenido {
    Contenido({
        this.id,
        this.modulo,
        this.titulo,
        this.contenido,
        this.orden,
        this.urlVideo,
        this.nombreVideo,
    });

    int id;
    int modulo;
    String titulo;
    String contenido;
    int orden;
    String urlVideo;
    String nombreVideo;

    factory Contenido.fromJson(Map<String, dynamic> json) => Contenido(
        id: json["id"],
        modulo: json["modulo"],
        titulo: json["titulo"],
        contenido: json["contenido"],
        orden: json["orden"],
        urlVideo: json["url_video"].toString(),
        nombreVideo: json["nombre_video"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "modulo": modulo,
        "titulo": titulo,
        "contenido": contenido,
        "orden": orden,
        "url_video": urlVideo,
        "nombre_video": nombreVideo,
    };
}