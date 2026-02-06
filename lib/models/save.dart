import 'dart:io';
import 'dart:typed_data';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;
import 'package:inspecaosegurancacipa/pages/usina/provider.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:inspecaosegurancacipa/pages/subestacao/provider.dart';
import 'package:inspecaosegurancacipa/pages/predio/provider.dart';
import 'package:inspecaosegurancacipa/pages/veiculo/provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// Adiciona uma imagem embutida na célula do Excel
void addEmbeddedImage(Worksheet sheet, int row, int col, String? fotoPath) {
  if (fotoPath == null || fotoPath.isEmpty) {
    sheet.getRangeByIndex(row, col).setText("---");
    return;
  }

  final file = File(fotoPath);
  if (!file.existsSync()) {
    sheet.getRangeByIndex(row, col).setText("---");
    return;
  }

  try {
    final bytes = file.readAsBytesSync();
    final picture = sheet.pictures.addStream(row, col, bytes);
    picture.height = 80;
    picture.width = 80;
    sheet.setRowHeightInPixels(row, 85);
  } catch (e) {
    sheet.getRangeByIndex(row, col).setText("Erro ao carregar foto");
  }
}

Future<bool> subestacaotoxlsx({required SubestacaoProvider provider, required bool sendEmail, destinatario}) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.name = "Inspeção";

  sheet.getRangeByIndex(1, 1)
    ..setText("Prefixo:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(1, 2).setText(provider.subestacao);

  sheet.getRangeByIndex(2, 1)
    ..setText("Data:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(2, 2).setText(provider.data);

  sheet.getRangeByIndex(3, 1)
    ..setText("Inspetor 1:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(3, 2).setText(provider.inspetor1);

  sheet.getRangeByIndex(4, 1)
    ..setText("Inspetor 2:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(4, 2).setText(provider.inspetor2 == "" ? "---" : provider.inspetor2);

  sheet.getRangeByIndex(5, 1)
    ..setText("Inspetor 2:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(5, 2).setText(provider.inspetor3 == "" ? "---" : provider.inspetor3);

  int currentRow = 7;

  for (int i = 0; i < provider.itens.length; i++) {
    var itemId = provider.itensId[i];
    var item = provider.itens[i];

    sheet.getRangeByIndex(currentRow, 1)
      ..setText("$itemId. $item")
      ..cellStyle.bold = true;
    currentRow++;

    final headers = ['Item', 'Perguntas', 'Situação', 'Observação', 'Fotografias'];
    for (int col = 0; col < headers.length; col++) {
      sheet.getRangeByIndex(currentRow, col + 1)
        ..setText(headers[col])
        ..cellStyle.bold = true;
    }
    currentRow++;

    for (var pergunta in provider.perguntas[itemId]!.entries) {
      sheet.getRangeByIndex(currentRow, 1).setText('$itemId.${pergunta.key}');
      sheet.getRangeByIndex(currentRow, 2).setText(pergunta.value);
      sheet.getRangeByIndex(currentRow, 3).setText(provider.respostas[itemId]![pergunta.key] ?? "---");
      sheet.getRangeByIndex(currentRow, 4).setText(provider.observacoes[itemId]![pergunta.key] ?? "---");
      addEmbeddedImage(sheet, currentRow, 5, provider.fotos[itemId]![pergunta.key]);
      currentRow++;
    }
    currentRow++;
  }

  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.setColumnWidthInPixels(5, 90);

  final List<int> fileBytes = workbook.saveSync();
  workbook.dispose();

  var fileName = "Inspecao_${provider.subestacao}_${provider.data.replaceAll("/", "-")}.xlsx";

  if (sendEmail) {
    return saveAndSendEmail(fileBytes: fileBytes, fileName: fileName, destinatario: destinatario, provider: provider);
  } else {
    return await saveLocally(fileBytes: fileBytes, fileName: fileName);
  }
}

Future<bool> usinatoxlsx({required UsinaProvider provider, required bool sendEmail, destinatario}) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.name = "Inspeção";

  sheet.getRangeByIndex(1, 1)
    ..setText("Prefixo:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(1, 2).setText(provider.usina);

  sheet.getRangeByIndex(2, 1)
    ..setText("Data:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(2, 2).setText(provider.data);

  sheet.getRangeByIndex(3, 1)
    ..setText("Inspetor 1:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(3, 2).setText(provider.inspetor1);

  sheet.getRangeByIndex(4, 1)
    ..setText("Inspetor 2:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(4, 2).setText(provider.inspetor2 == "" ? "---" : provider.inspetor2);

  sheet.getRangeByIndex(5, 1)
    ..setText("Inspetor 2:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(5, 2).setText(provider.inspetor3 == "" ? "---" : provider.inspetor3);

  int currentRow = 7;

  for (int i = 0; i < provider.itens.length; i++) {
    var itemId = provider.itensId[i];
    var item = provider.itens[i];

    sheet.getRangeByIndex(currentRow, 1)
      ..setText("$itemId. $item")
      ..cellStyle.bold = true;
    currentRow++;

    final headers = ['Item', 'Perguntas', 'Situação', 'Observação', 'Fotografias'];
    for (int col = 0; col < headers.length; col++) {
      sheet.getRangeByIndex(currentRow, col + 1)
        ..setText(headers[col])
        ..cellStyle.bold = true;
    }
    currentRow++;

    for (var pergunta in provider.perguntas[itemId]!.entries) {
      sheet.getRangeByIndex(currentRow, 1).setText('$itemId.${pergunta.key}');
      sheet.getRangeByIndex(currentRow, 2).setText(pergunta.value);
      sheet.getRangeByIndex(currentRow, 3).setText(provider.respostas[itemId]![pergunta.key] ?? "---");
      sheet.getRangeByIndex(currentRow, 4).setText(provider.observacoes[itemId]![pergunta.key] ?? "---");
      addEmbeddedImage(sheet, currentRow, 5, provider.fotos[itemId]![pergunta.key]);
      currentRow++;
    }
    currentRow++;
  }

  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.setColumnWidthInPixels(5, 90);

  final List<int> fileBytes = workbook.saveSync();
  workbook.dispose();

  var fileName = "Inspecao_Usina_${provider.usina}_${provider.data.replaceAll("/", "-")}.xlsx";

  if (sendEmail) {
    return saveAndSendEmail(fileBytes: fileBytes, fileName: fileName, destinatario: destinatario, provider: provider);
  } else {
    return await saveLocally(fileBytes: fileBytes, fileName: fileName);
  }
}

Future<bool> prediotoxlsx({required PredioProvider provider, required bool sendEmail, destinatario}) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.name = "Inspeção";

  sheet.getRangeByIndex(1, 1)
    ..setText("Prefixo:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(1, 2).setText(provider.predio);

  sheet.getRangeByIndex(2, 1)
    ..setText("Data:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(2, 2).setText(provider.data);

  sheet.getRangeByIndex(3, 1)
    ..setText("Inspetor 1:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(3, 2).setText(provider.inspetor1);

  sheet.getRangeByIndex(4, 1)
    ..setText("Inspetor 2:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(4, 2).setText(provider.inspetor2 == "" ? "---" : provider.inspetor2);

  sheet.getRangeByIndex(5, 1)
    ..setText("Inspetor 2:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(5, 2).setText(provider.inspetor3 == "" ? "---" : provider.inspetor3);

  int currentRow = 7;

  for (int i = 0; i < provider.itens.length; i++) {
    var itemId = provider.itensId[i];
    var item = provider.itens[i];

    sheet.getRangeByIndex(currentRow, 1)
      ..setText("$itemId. $item")
      ..cellStyle.bold = true;
    currentRow++;

    final headers = ['Item', 'Perguntas', 'Situação', 'Observação', 'Fotografias'];
    for (int col = 0; col < headers.length; col++) {
      sheet.getRangeByIndex(currentRow, col + 1)
        ..setText(headers[col])
        ..cellStyle.bold = true;
    }
    currentRow++;

    for (var pergunta in provider.perguntas[itemId]!.entries) {
      sheet.getRangeByIndex(currentRow, 1).setText('$itemId.${pergunta.key}');
      sheet.getRangeByIndex(currentRow, 2).setText(pergunta.value);
      sheet.getRangeByIndex(currentRow, 3).setText(provider.respostas[itemId]![pergunta.key] ?? "---");
      sheet.getRangeByIndex(currentRow, 4).setText(provider.observacoes[itemId]![pergunta.key] ?? "---");
      addEmbeddedImage(sheet, currentRow, 5, provider.fotos[itemId]![pergunta.key]);
      currentRow++;
    }
    currentRow++;
  }

  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.setColumnWidthInPixels(5, 90);

  final List<int> fileBytes = workbook.saveSync();
  workbook.dispose();

  var fileName = "Inspecao_Predio_${provider.predio}_${provider.data.replaceAll("/", "-")}.xlsx";

  if (sendEmail) {
    return saveAndSendEmail(fileBytes: fileBytes, fileName: fileName, destinatario: destinatario, provider: provider);
  } else {
    return await saveLocally(fileBytes: fileBytes, fileName: fileName);
  }
}

Future<bool> veiculotoxlsx({required VeiculoProvider provider, required bool sendEmail, destinatario}) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  sheet.name = "Inspeção";

  sheet.getRangeByIndex(1, 1)
    ..setText("Prefixo:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(1, 2).setText(provider.veiculo);

  sheet.getRangeByIndex(2, 1)
    ..setText("Data:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(2, 2).setText(provider.data);

  sheet.getRangeByIndex(3, 1)
    ..setText("Inspetor 1:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(3, 2).setText(provider.inspetor1);

  sheet.getRangeByIndex(4, 1)
    ..setText("Inspetor 2:")
    ..cellStyle.bold = true;
  sheet.getRangeByIndex(4, 2).setText(provider.inspetor2 == "" ? "---" : provider.inspetor2);

  int currentRow = 6;

  for (int i = 0; i < provider.itens.length; i++) {
    var itemId = provider.itensId[i];
    var item = provider.itens[i];

    sheet.getRangeByIndex(currentRow, 1)
      ..setText("$itemId. $item")
      ..cellStyle.bold = true;
    currentRow++;

    final headers = ['Item', 'Perguntas', 'Situação', 'Observação', 'Fotografias'];
    for (int col = 0; col < headers.length; col++) {
      sheet.getRangeByIndex(currentRow, col + 1)
        ..setText(headers[col])
        ..cellStyle.bold = true;
    }
    currentRow++;

    for (var pergunta in provider.perguntas[itemId]!.entries) {
      sheet.getRangeByIndex(currentRow, 1).setText('$itemId.${pergunta.key}');
      sheet.getRangeByIndex(currentRow, 2).setText(pergunta.value);
      sheet.getRangeByIndex(currentRow, 3).setText(provider.respostas[itemId]![pergunta.key] ?? "---");
      sheet.getRangeByIndex(currentRow, 4).setText(provider.observacoes[itemId]![pergunta.key] ?? "---");
      addEmbeddedImage(sheet, currentRow, 5, provider.fotos[itemId]![pergunta.key]);
      currentRow++;
    }
    currentRow++;
  }

  sheet.autoFitColumn(1);
  sheet.autoFitColumn(2);
  sheet.autoFitColumn(3);
  sheet.autoFitColumn(4);
  sheet.setColumnWidthInPixels(5, 90);

  final List<int> fileBytes = workbook.saveSync();
  workbook.dispose();

  var fileName = "Inspecao_Veiculo_${provider.veiculo}_${provider.data.replaceAll("/", "-")}.xlsx";

  if (sendEmail) {
    return saveAndSendEmail(fileBytes: fileBytes, fileName: fileName, destinatario: destinatario, provider: provider);
  } else {
    return await saveLocally(fileBytes: fileBytes, fileName: fileName);
  }
}

Future<bool> saveLocally({required List<int>? fileBytes, required String? fileName}) async {
  final result = await FilePicker.saveFile(
    dialogTitle: 'Save Excel File',
    fileName: fileName,
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
    bytes: Uint8List.fromList(fileBytes!),
  );
  if (result != null) {
    return true;
  } else {
    return false;
  }
}

Future<bool> saveAndSendEmail({required List<int>? fileBytes, required String? fileName, required String destinatario, provider}) async {
  String username = dotenv.get('EMAIL');
  String password = dotenv.get('PASSWORD');

  final tempDir = await getTemporaryDirectory();

  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'Inspeção de Segurança')
    ..recipients.add(destinatario)
    ..subject = 'Dados da inspeção do dia ${provider.data}'
    ..text = ''
    ..attachments = [
      FileAttachment(
        File(join(tempDir.path, fileName!))
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!),
        fileName: fileName,
      )
    ];

  try {
    await send(message, smtpServer);
    tempDir.deleteSync(recursive: true);
    tempDir.create();
    return true;
  } on Exception catch (_) {
    return false;
  }
}
