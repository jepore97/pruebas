import 'package:adhara_socket_io/adhara_socket_io.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class socketRes {
  Future<IO.Socket> conexion() async {
    IO.Socket socket = await IO.io('http://192.168.100.181:5000', {
      'transports': ['websocket'],
      'autoConnect': false,
    });

// Dart client
    socket.on('connect', (_) {
      print('connect...');
    });
    socket.on('event', (data) => print(data));
    socket.on('news', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));

// add this line
    socket.connect();
    return socket;
  }
}
