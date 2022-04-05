import 'dart:convert';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:taass_frontend_android/ospedale/model/animale.dart';
import 'package:taass_frontend_android/ospedale/model/visita.dart';
import 'package:http/http.dart' as http;

class VisiteService {
  static const String basicUrl = '10.0.2.2:8081';

  static Future<List<Visita>> getVisite(List<Animale> animaliDiUtente, int? idAnimale, TipoVisita? tipoVisita) async {
    final Map<String, String> parametri = {};
    if (idAnimale!=null) {
      parametri["idAnimale"] = idAnimale.toString();
    }
    if(tipoVisita!=null) {
      parametri['tipoVisita'] = Visita.tipoVisitaToString(tipoVisita);
    }
    Uri url = Uri.http(VisiteService.basicUrl, '/ospedale/getVisite', parametri);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List lista_json = jsonDecode(response.body);
      List<Visita> lista_visite = [];
      for (var element in lista_json) {
        try {
          lista_visite.add(Visita.fromJson(element, animaliDiUtente));
        } on StateError catch (e){
          developer.log("Errore nella conversione di $element in Animale");
        }
      }
      developer.log("Visite restituite dal backend");
      return lista_visite;
    } else {
      developer.log("Errore durante la getVisite.\n${response.statusCode}");
      return Future.value([]);
    }
    // return Future.value([
    //   Visita(
    //     id: 1,
    //     animale: Animale(id: 1, nome: 'Leo'),
    //     data: DateTime.parse('2022-01-10T10:00'),
    //     durataInMinuti: 30,
    //     tipoVisita: TipoVisita.CONTROLLO,
    //   ),
    //   Visita(
    //     id: 2,
    //     animale: Animale(id: 2, nome: 'Pippo'),
    //     data: DateTime.parse('2022-02-20T11:00'),
    //     durataInMinuti: 40,
    //     tipoVisita: TipoVisita.OPERAZIONE
    //   ),
    // ]);
  }

  static Future<bool> deleteVisita(Visita visita) async {
    Uri url = Uri.http(VisiteService.basicUrl, '/ospedale/deleteVisita');
    final responseVoid = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(visita.toJson()));
    if (responseVoid.statusCode == 200) {
      developer.log("Eliminata visita nel backend $visita");
      return true;
    }
    else {
      developer.log("Errore nella deleteVisita");
      return false;
    }
  }
}
