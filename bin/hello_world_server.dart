import 'dart:io';

// from https://www.dartlang.org/articles/io/

main() {
  print('hello world server');
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    print('server will start listening');
    server.listen((HttpRequest request) {
      print('server listened');
      request.response.write('Hello, world');
      request.response.close();
    });
  });
}
