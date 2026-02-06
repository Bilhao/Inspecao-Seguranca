import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;

// Aqui precisa adicionar uma autenticação de usuário para poder fazer upload para o firebase
// e também mudar a regra no app no firebase console. Por enquanto está como "public" (não seguro).

Future<String> uploadFile(String filePath, String data) async {
  try {
    File file = File(filePath);
    String fileName = filePath.split("/").last;
    UploadTask uploadTask = storage.ref('images/${data.split("/")[2]}/${data.split("/")[1]}/${data.split("/")[0]}/$fileName').putFile(file);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    return '';
  }
}

Future<void> deleteFile(String filePath, String data) async {
  String fileName = filePath.split("/").last;
  await storage.ref('images/${data.split("/")[2]}/${data.split("/")[1]}/${data.split("/")[0]}/$fileName').delete();
}
