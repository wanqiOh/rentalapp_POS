import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfRepository {
  PdfRepository();

  static Future<File> saveDocument({
    @required String name,
    @required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future uploadInvoice(File file) async {
    final _firebaseStorage = FirebaseStorage.instance;
    String url;

    if (file != null) {
      //Upload to Firebase
      Reference storageReference =
          _firebaseStorage.ref().child('invoice/${Path.basename(file.path)}}');
      UploadTask uploadTask = storageReference.putFile(File(file.path));
      await uploadTask.whenComplete(() {
        print('File Uploaded');
      });

      url = await storageReference.getDownloadURL().then((fileURL) {
        return fileURL;
      });
    }
    return url;
  }

  static Future openFile(String file) async {
    await OpenFile.open(file);
  }
}
