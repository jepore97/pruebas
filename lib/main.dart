import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io/socket_io.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:websockets/modelo.dart';
import 'package:websockets/second.dart';
import 'package:websockets/services_sedes.dart';
import 'package:websockets/socket.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('sedesa');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // Socket socket;
  String dato = '';
  Channel _channel;
  String URI = "http://192.168.100.181:5000";
  SocketIOManager manager;
  SocketIO socket;
  IO.Socket socketnuevo;
  Empresa list;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  initHive() async {
    Hive.initFlutter();
    Hive.openBox('sedes');
  }

  @override
  void initState() {
    // met();
    super.initState();
    initSocketIo();

    // connectToServer();
  }

  void initSocketIo() async {
    socketnuevo = await socketRes().conexion();
    socketnuevo.on('connect', (_) {
      print('Conectado');
    });
    socketnuevo.on('sedesres', (_) {
      print('sedes cambio');
      ServicioSede().cargarSedes(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              dato,
              style: Theme.of(context).textTheme.headline4,
            ),
            IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => secondPage(),
                    ),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
