import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:path_provider/path_provider.dart';

import 'model_sede.dart';

class ServicioSede {
  Future<dynamic> cargarSedes(bool cambio) async {
    http.Response response;
    SedesList sedesList;
    var jsonResponse;

    try {
      final sedes = Hive.box('sedesa').get('data', defaultValue: []);
      if (!cambio) {
        if (sedes.isNotEmpty) {
          return sedes;
        }
      } else {
        response = await http
            .get(
              "http://192.168.100.181:5000/sede/",
            )
            .timeout(Duration(seconds: 10));
        jsonResponse = json.decode(response.body)['data'];
        // print(jsonResponse);
        // sedesList = SedesList.fromJson(jsonResponse);

        Hive.box('sedesa').put('data', jsonResponse);
        return jsonResponse;
      }
    } on Error catch (e) {
      // print(e);
      return null;
    }
  }
}
// ----------------------------------------------------------------------------------------
