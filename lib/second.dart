import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:websockets/services_sedes.dart';
import 'package:websockets/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class secondPage extends StatefulWidget {
  secondPage({Key key}) : super(key: key);

  @override
  _secondPageState createState() => _secondPageState();
}

class _secondPageState extends State<secondPage> {
  dynamic sedes1 = Hive.box('sedesa').get('data', defaultValue: []);

  IO.Socket socketnuevo;
  @override
  void initState() {
    cargar();
    // TODO: implement initState
    initSocketIo();
    super.initState();
  }

  cargar() async {
    if (!sedes1.isNotEmpty) {
      sedes1 = await ServicioSede().cargarSedes(true);
    }
  }

  void initSocketIo() async {
    socketnuevo = await socketRes().conexion();
    socketnuevo.on('sedesres', (_) async {
      print('sedes cambio second');
      sedes1 = await ServicioSede().cargarSedes(true);
      if (mounted) {
        setState(() {
          print('cambiando');
          sedes1 = sedes1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: FutureBuilder(
        future: ServicioSede().cargarSedes(false),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List lista = sedes1;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: lista.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(lista[index]['sd_desc']),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )),
    );
  }
}
