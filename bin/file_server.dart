import 'dart:io';
import 'package:path/path.dart' as path;

// based on https://www.dartlang.org/articles/io/

_sendNotFound(HttpResponse response) {
  response.statusCode = HttpStatus.NOT_FOUND;
  response.close();
}

startServer(String directoryAbsolutePath) {
  print('directory absolute path: ${directoryAbsolutePath}');
  HttpServer.bind('127.0.0.1', 8081).then((server) {
    server.listen((HttpRequest request) {
      var fileRelativePath = request.uri.path;
      print('file relative path: ${fileRelativePath}');
      if (fileRelativePath.endsWith('/')) {
        fileRelativePath = path.join(fileRelativePath, 'index.html');
      }
      String fileAbsolutePath =
          //path.join(directoryAbsolutePath, fileRelativePath); // not working on Ubuntu!?
          directoryAbsolutePath + fileRelativePath;
      print('file absolute path: ${fileAbsolutePath}');
      final File file = new File(fileAbsolutePath);
      file.exists().then((bool found) {
        if (found) {
          print('file found');
          file.openRead()
              .pipe(request.response)
              .catchError((e) { });
        } else {
          print('file not found');
          _sendNotFound(request.response);
        }
      });
    });
  });
}

main() {
  // Windows
  // var directoryAbsolutePath = 'C:\\server_files'; // or
  var directoryAbsolutePath = 'C:/server_files';
  
  // Ubuntu
  // var directoryAbsolutePath = '/home/dr/server_files';
  
  // files in the directory: index.html, readme.txt, teams.pdf
  startServer(directoryAbsolutePath);
}
