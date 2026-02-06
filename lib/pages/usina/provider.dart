import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/data.dart';

class UsinaProvider with ChangeNotifier {
  UsinaProvider() {
    load();
  }

  Data db = Data();

  // Variáveis da página usina_page
  String _usina = "";
  String _data = ""
      "${DateTime.now().day.toString().padLeft(2, '0')}/"
      "${DateTime.now().month.toString().padLeft(2, '0')}/"
      "${DateTime.now().year}";
  String _inspetor1 = "";
  String _inspetor2 = "";
  String _inspetor3 = "";

  // Variáveis da página perguntas_page
  List<int> _itensId = [];
  List<String> _itens = [];
  Map<int, Map<int, String>> _perguntas = {};
  final Map<int, Map<int, String?>> _respostas = {};
  final Map<int, Map<int, String?>> _observacoes = {};
  final Map<int, Map<int, String?>> _fotos = {};

  // Getters usina_page
  String get usina => _usina;
  String get data => _data;
  String get inspetor1 => _inspetor1;
  String get inspetor2 => _inspetor2;
  String get inspetor3 => _inspetor3;

  // Getters perguntas_page
  List<int> get itensId => _itensId;
  List<String> get itens => _itens;
  Map<int, Map<int, String>> get perguntas => _perguntas;
  Map<int, Map<int, String?>> get respostas => _respostas;
  Map<int, Map<int, String?>> get observacoes => _observacoes;
  Map<int, Map<int, String?>> get fotos => _fotos;

  // Setters usina_page
  set usina(String value) {
    _usina = value;
    notifyListeners();
  }

  set data(String value) {
    _data = value;
    notifyListeners();
  }

  set inspetor1(String value) {
    _inspetor1 = value;
    notifyListeners();
  }

  set inspetor2(String value) {
    _inspetor2 = value;
    notifyListeners();
  }

  set inspetor3(String value) {
    _inspetor3 = value;
    notifyListeners();
  }

  // Metodos de inspecao_page
  Future<void> load() async {
    _itensId = await db.getItensId(table: 'usina');
    _itens = await db.getItens(table: 'usina');
    _perguntas = await db.getPerguntas(table: 'usina');
    for (var itemId in _itensId) {
      for (var pergunta in _perguntas[itemId]!.entries) {
        _respostas[itemId] = {pergunta.key: null};
        _observacoes[itemId] = {pergunta.key: null};
        _fotos[itemId] = {pergunta.key: null};
      }
    }
    notifyListeners();
  }

  void saveResposta({required int itemId, required int perguntaId, required String resposta}) async {
    _respostas[itemId]![perguntaId] = resposta;
    notifyListeners();
  }

  void saveObservacao({required int itemId, required int perguntaId, required String observacao}) async {
    _observacoes[itemId]![perguntaId] = observacao;
    notifyListeners();
  }

  Future<void> saveFoto({required int itemId, required int perguntaId, required String fotoPath}) async {
    var compressed = await FlutterImageCompress.compressAndGetFile(
      fotoPath,
      fotoPath.replaceAll(".jpg", "_compressed.jpg"),
      quality: 30,
      minWidth: 400,
      minHeight: 400,
    );
    // Salva o caminho da foto comprimida (não a original)
    _fotos[itemId]![perguntaId] = compressed!.path;
    notifyListeners();
  }

  Future<void> excluirFoto({required int itemId, required int perguntaId}) async {
    _fotos[itemId]![perguntaId] = null;
    notifyListeners();
  }

  bool fotoExists({required int itemId, required int perguntaId}) {
    return _fotos[itemId]![perguntaId] != null;
  }

  bool verifyAllFieldsSelected({required int itemId}) {
    for (var pergunta in _perguntas[itemId]!.entries) {
      if (_respostas[itemId]![pergunta.key] == null) {
        return false;
      }
    }
    return true;
  }

  Future<void> eraseSavedInfos() async {
    _usina = "";
    _data = ""
        "${DateTime.now().day.toString().padLeft(2, '0')}/"
        "${DateTime.now().month.toString().padLeft(2, '0')}/"
        "${DateTime.now().year}";
    _inspetor1 = "";
    _inspetor2 = "";
    _inspetor3 = "";

    for (var itemId in _itensId) {
      for (var pergunta in _perguntas[itemId]!.entries) {
        _respostas[itemId] = {pergunta.key: null};
        _observacoes[itemId] = {pergunta.key: null};
        _fotos[itemId] = {pergunta.key: null};
      }
    }
    final tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
    notifyListeners();
  }
}
