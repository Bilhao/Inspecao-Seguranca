import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Data {
  Future initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'data.db');

    final exist = await databaseExists(path);

    if (exist) {
      return await openDatabase(path);
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "data.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);

      return await openDatabase(path);
    }
  }

  Future<List<int>> getItensId({required String table}) async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT DISTINCT itens_id FROM $table');
    return List.generate(maps.length, (i) {
      return maps[i]['itens_id'];
    });
  }

  Future<List<String>> getItens({required String table}) async {
    final db = await initDb();
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT DISTINCT itens FROM $table');
    return List.generate(maps.length, (i) {
      return maps[i]['itens'];
    });
  }

  Future<Map<int, Map<int, String>>> getPerguntas({required String table}) async {
    final db = await initDb();
    final List<Map<String, dynamic>> result = await db.query(table);

    // Mapa final onde os dados serão armazenados
    Map<int, Map<int, String>> formattedData = {};

    for (var row in result) {
      int itemId = row['itens_id'];
      int perguntaId = row['perguntas_id'];
      String pergunta = row['perguntas'];

      // Verifica se o itemId já existe no mapa, se não, cria um novo mapa
      if (!formattedData.containsKey(itemId)) {
        formattedData[itemId] = {};
      }

      // Adiciona a pergunta ao mapa interno
      formattedData[itemId]![perguntaId] = pergunta;
    }

    return formattedData;
  }
}