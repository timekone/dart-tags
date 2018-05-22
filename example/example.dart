import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

void main(List<String> args) {
  if (args.isNotEmpty) {
    args.forEach((s) => _proceedArg(s));
  } else {
    print('args please!');
  }
}

void _proceedArg(String path) {
  final fileType = FileStat.statSync(path).type;
  switch (fileType) {
    case FileSystemEntityType.directory:
      new Directory(path)
          .list(recursive: true, followLinks: false)
          .listen((FileSystemEntity entity) {
        if (entity.statSync().type == FileSystemEntityType.file &&
            entity.path.endsWith('.mp3')) {
          printFileInfo(entity.path);
        }
      });
      break;
    case FileSystemEntityType.file:
      if (path.endsWith('.mp3')) {
        printFileInfo(path);
      }
      break;
    case FileSystemEntityType.notFound:
      print('file not found');
      break;
    default:
      print('sorry dude I don`t know what I must to do with that...\n');
  }
}

void printFileInfo(String fileName) async {
  final file = new File(fileName);
  new TagProcessor().getTagsFromByteArray(file.readAsBytes()).then((l) {
    print('FILE: $fileName');
    l.forEach((f) => print(f));
    print('\n');
  });
}
