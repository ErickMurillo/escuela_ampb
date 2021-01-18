import 'dart:io';


import 'package:escuela_ampb/src/models/contenido_model.dart';
import 'package:escuela_ampb/src/models/curso_model.dart';
import 'package:escuela_ampb/src/models/modulo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';



class DBProvider{
    static Database _database;
    static final  DBProvider db = DBProvider._();//contructor privado es lo mismo que _private

    DBProvider._();

    Future<Database> get database async {
        if (_database != null) return _database;

        _database = await initDB();
        return _database;
    }

    initDB() async{
        Directory documentsDirectory = await getApplicationDocumentsDirectory();// obtener el path de donde se encuentra la bd
        final path = join(documentsDirectory.path, 'Cursos.db');

        return await openDatabase(
            path,
            version: 1,
            onOpen: (db){},
            onCreate: (Database db, int version) async{
                await db.execute(
                    'CREATE TABLE Curso('
                    'id INTEGER PRIMARY KEY,'
                    'titulo TEXT,'
                    'imagen TEXT,'
                    'descripcion TEXT,'
                    'fecha TEXT,'
                    'activo TEXT'
                    ')'
                );
                await db.execute(
                    'CREATE TABLE Modulo('
                    'id INTEGER PRIMARY KEY,'
                    'curso INTEGER,'
                    'titulo TEXT,'
                    'orden INTEGER'
                    ')'
                );

                await db.execute(
                    'CREATE TABLE Contenido('
                    'id INTEGER PRIMARY KEY,'
                    'modulo INTEGER,'
                    'titulo TEXT,'
                    'contenido TEXT,'
                    'orden INTEGER,'
                    'url_video TEXT,'
                    'nombre_video TEXT'
                    ')'
                );
            }
        );

    
    }

    insertCurso(Curso nuevoCurso) async{
        final db = await database;
        final pregunta = await db.query('Curso', where: 'id = ?', whereArgs: [nuevoCurso.id]);
        if (pregunta.isNotEmpty) {
            // final res = await db.update('Curso', nuevoCurso.toJson(), where: 'id = ?', whereArgs: [nuevoCurso.id]);
            // return res;
            final flag = await db.query('Curso', where: 'fecha = ? AND id = ?', whereArgs: [nuevoCurso.fecha, nuevoCurso.id]);
            
            if(!flag.isNotEmpty){
                final res = await db.update('Curso', nuevoCurso.toJson(), where: 'id = ?', whereArgs: [nuevoCurso.id]);
                //final prueba = nuevoCurso.id;
               // print('se actualizo el id: $prueba');
                return res;
            }else{
                //final prueba = nuevoCurso.id;
                //print('no se actualizo id: $prueba');
            }
            
            
        } else {
            
            final res = await db.insert('Curso', nuevoCurso.toJson());
            return res;
        }
    }

    insertModulo(Modulo nuevoModulo) async{
        final db = await database;
        final pregunta = await db.query('Modulo', where: 'id = ?', whereArgs: [nuevoModulo.id]);
        if (pregunta.isNotEmpty) {
        
            final res = await db.update('Modulo', nuevoModulo.toJson(), where: 'id = ?', whereArgs: [nuevoModulo.id]);
            final prueba = nuevoModulo.id;
            //print('No actualizo el id: $prueba');
            return res;
            
            
        } else {
            
            final res = await db.insert('Modulo', nuevoModulo.toJson());
            //final prueba = nuevoModulo.id;
           //print('se inserto el id: $prueba');
            return res;
        }
    }


    insertContenido(Contenido nuevoContenido) async{
        final db = await database;
        final pregunta = await db.query('Contenido', where: 'id = ?', whereArgs: [nuevoContenido.id]);
        if (pregunta.isNotEmpty) {
            final res = await db.update('Contenido', nuevoContenido.toJson(), where: 'id = ?', whereArgs: [nuevoContenido.id]);
            final prueba = nuevoContenido.id;
            //print('No actualizo el id: $prueba');
            return res;           
            
        } else {
            final res = await db.insert('Contenido', nuevoContenido.toJson());
            //final prueba = nuevoContenido.id;
           // print('se inserto el id: $prueba');
            return res;
        }
    }

    //SELECT - obtener informacion

    //obtenes registro por id
    Future<Curso> getCursoId(int id) async{
        final db = await database;
        final res = await db.query('Curso', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? Curso.fromJson(res.first) : null;
    }

    Future<Modulo> getModuloId(int id) async{
        final db = await database;
        final res = await db.query('Modulo', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? Modulo.fromJson(res.first) : null;
    }
    Future<Contenido> getContenidoId(int id) async{
        final db = await database;
        final res = await db.query('Contenido', where: 'id = ?', whereArgs: [id]);
        return res.isNotEmpty ? Contenido.fromJson(res.first) : null;
    }

    //Todos los resgistros
    Future<List<Curso>> getTodosCursos() async{
        final db = await database;
        final res = await db.query('Curso');

        List <Curso> list = res.isNotEmpty
                                    ? res.map((e) => Curso.fromJson(e)).toList()
                                    : [];
        
        return list;
    }

    Future<List<Modulo>> getTodosModulos() async{
        final db = await database;
        final res = await db.query('Modulo');

        List <Modulo> list = res.isNotEmpty
                                    ? res.map((e) => Modulo.fromJson(e)).toList()
                                    : [];
        
        return list;
    }

    Future<List<Contenido>> getTodosContenidos() async{
        final db = await database;
        final res = await db.query('Contenido');

        List <Contenido> list = res.isNotEmpty
                                    ? res.map((e) => Contenido.fromJson(e)).toList()
                                    : [];
        
        return list;
    }


    //Filtrar Modulo por id Curso
    Future<List<Modulo>> filterModuloIdCurso(int id) async{
        final db = await database;

        String myQuery= "SELECT * FROM Modulo WHERE curso = $id ORDER BY orden ASC";

        final res = await db.rawQuery(myQuery);
        
        //final res = await db.query('Modulo', where: 'curso = ?', whereArgs: [id]);
        List <Modulo> list = res.isNotEmpty
                                    ? res.map((e) => Modulo.fromJson(e)).toList()
                                    : [];
        return list;
    }

    Future filterContenidoIdModulo(List<int> idsModulos) async{
        final db = await database;
        // int id = 1;

        String myQuery= "SELECT * FROM Contenido WHERE modulo IN $idsModulos ORDER BY orden ASC";
        String limpiar= myQuery.replaceAll('[', '(');
        myQuery= limpiar.replaceAll(']', ')');

        //print(myQuery);

        final res = await db.rawQuery(myQuery);

        // List resprueba = res;

        // for (var item in resprueba) {
        //   print(item);
        // }

        


        //final res = await db.query('Contenido', where: 'modulo = ?', whereArgs: [id]);
        List <Contenido> list = res.isNotEmpty
                                    ? res.map((e) => Contenido.fromJson(e)).toList()
                                    : [];
        return list;
    }


    //ingresar registros
    nuevoCurso(Curso nuevoCurso) async{
        final db = await database;
        //print(nuevoCurso.id);
        final res = await db.insert('Curso', nuevoCurso.toJson());
        return res;
    }

    //Actualizar Registros
    Future<int> updateCurso(Curso nuevoCurso) async{
        final db = await database;
        //print(nuevoCurso.id);
        final res = await db.update('Curso', nuevoCurso.toJson(), where: 'id = ?', whereArgs: [nuevoCurso.id]);
        return res;
    }



}