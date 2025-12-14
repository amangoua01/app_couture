import 'dart:io';

import 'package:ateliya/data/models/abstract/fichier.dart';
import 'package:ateliya/tools/extensions/types/map.dart';

class FichierLocal extends Fichier {
  String path;

  FichierLocal({required this.path});

  bool get isUrl => false;

  FichierLocal.fromFile(File file) : path = file.path;

  File get file => File(path);

  @override
  Json toJson() => {
        'path': path,
      };
}
