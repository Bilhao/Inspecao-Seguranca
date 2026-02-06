import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/data.dart';
import '../../models/firebase_server.dart';


class PredioProvider with ChangeNotifier {

  PredioProvider() {
    load();
  }

  Data db = Data();

  // Variáveis da página predio_page
  String _predio = "";
  String _data = ""
      "${DateTime.now().day.toString().padLeft(2, '0')}/"
      "${DateTime.now().month.toString().padLeft(2, '0')}/"
      "${DateTime.now().year}";
  String _inspetor1 = "";
  String _inspetor2 = "";
  String _inspetor3 = "";

  // Variáveis da página inspecao_page
  List<int> _itensId = [];
  List<String> _itens = [];
  Map<int, Map<int, String>> _perguntas = {};
  final Map<int, Map<int, String?>> _respostas = {};
  final Map<int, Map<int, String?>> _observacoes = {};
  final Map<int, Map<int, String?>> _fotos = {};
  final Map<int, Map<int, String?>> _downloadLinks = {};

  // Getters predio_page
  String get predio => _predio;
  String get data => _data;
  String get inspetor1 => _inspetor1;
  String get inspetor2 => _inspetor2;
  String get inspetor3 => _inspetor3;

  // Getters inspecao_page
  List<int> get itensId => _itensId;
  List<String> get itens => _itens;
  Map<int, Map<int, String>> get perguntas => _perguntas;
  Map<int, Map<int, String?>> get respostas => _respostas;
  Map<int, Map<int, String?>> get observacoes => _observacoes;
  Map<int, Map<int, String?>> get fotos => _fotos;
  Map<int, Map<int, String?>> get downloadLinks => _downloadLinks;

  // Setters predio_page
  set predio(String value) {
    _predio = value;
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
    _itensId = await db.getItensId(table: 'predio');
    _itens = await db.getItens(table: 'predio');
    _perguntas = await db.getPerguntas(table: 'predio');
    for (var itemId in _itensId) {
      for (var pergunta in _perguntas[itemId]!.entries) {
        _respostas[itemId] = {pergunta.key: null};
        _observacoes[itemId] = {pergunta.key: null};
        _fotos[itemId] = {pergunta.key: null};
        _downloadLinks[itemId] = {pergunta.key: null};
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
    _fotos[itemId]![perguntaId] = fotoPath;

    var compressed = await FlutterImageCompress.compressAndGetFile(
      fotoPath,
      fotoPath.replaceAll(".jpg", "_compressed.jpg"),
      quality: 30,
    );
    _downloadLinks[itemId]![perguntaId] = await uploadFile(compressed!.path, _data);
    notifyListeners();
  }

  Future<void> excluirFoto({required int itemId, required int perguntaId}) async {
    deleteFile(_fotos[itemId]![perguntaId]!.replaceAll(".jpg", "_compressed.jpg"), _data);
    _downloadLinks[itemId]![perguntaId] = null;
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
    _predio = "";
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
        _downloadLinks[itemId] = {pergunta.key: null};
      }
    }
    final tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
    notifyListeners();
  }
}