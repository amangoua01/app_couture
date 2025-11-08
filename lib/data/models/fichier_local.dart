import 'dart:io';

import 'package:app_couture/data/models/abstract/fichier.dart';

class FichierLocal extends Fichier {
  String path;

  FichierLocal({required this.path});

  bool get isUrl => false;

  FichierLocal.fromFile(File file) : path = file.path;

  File get file => File(path);
}
