import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;

  get serverStatus => _serverStatus;

  SocketService(){
    _initConfig();
  }

  void _initConfig() {
    IO.Socket socket = IO.io('http://192.168.1.4:3000', {
      'transports': ['websocket'],
      'autoConnect': true,

    });

    socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    socket.on('nuevo-mensaje', ( payload ) {
      print( 'nuevo-mensaje: ' );
      print( 'nombre: ' + payload['nombre'] );
      print( 'mensaje: ' + payload['mensaje'] );
    });

  }

}