
class Reflexion {
    Reflexion({
        this.id,
        this.texto,
        this.link,
        this.autor,
        this.fecha,
        this.activo,
    });

    int     id;
    String  texto;
    String  link;
    String  autor;
    String  fecha;
    String  activo;

    factory Reflexion.fromJson(Map<String, dynamic> json) => Reflexion(
        id          : json["id"],
        texto       : json["texto"],
        link        : json["link"],
        autor       : json["autor"],
        fecha      : json["fecha"].toString(),
        activo      : json["activo"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id"            : id,
        "texto"         : texto,
        "link"          : link,
        "autor"         : autor,
        "fecha"         : fecha,
        "activo"        : activo,
    };
}

class Reflexions {
  List<Reflexion> items = new List();

    Reflexions.fromJsonList(List<dynamic> jsonList) {
        for (var item in jsonList) {
            final reflexion = new Reflexion.fromJson(item);

            items.add(reflexion);
        }
    }
}