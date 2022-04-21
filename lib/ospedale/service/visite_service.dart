import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:taass_frontend_android/model/animale.dart';
import 'package:taass_frontend_android/model/visita.dart';
import 'package:http/http.dart' as http;

class VisiteService {
  static const String basicUrl = '10.0.2.2:8081';

  static Future<List<Visita>> getVisite(
      List<Animale> animaliDiUtente, int? idAnimale, TipoVisita? tipoVisita) {
    final Map<String, String> parametri = {};
    if (idAnimale != null) {
      parametri["idAnimale"] = idAnimale.toString();
    }
    if (tipoVisita != null) {
      parametri['tipoVisita'] = Visita.tipoVisitaToString(tipoVisita);
    }
    Uri url =
        Uri.http(VisiteService.basicUrl, '/ospedale/getVisite', parametri);
    final response = http.get(url);
    return gestisciRispostaGetVisite(response, animaliDiUtente);
  }

  static Future<List<Visita>> gestisciRispostaGetVisite(
      Future<Response> response, List<Animale> animaliDiUtente) {
    return response.then((response_) {
      List lista_json = jsonDecode(response_.body);
      List<Visita> lista_visite = [];
      for (var element in lista_json) {
        try {
          lista_visite.add(Visita.fromJson(element, animaliDiUtente));
        } on StateError catch (e) {
          developer.log("Errore nella conversione di $element in Animale");
        }
      }
      developer.log("Visite restituite dal backend");
      lista_visite.sort((v1, v2) => v2.data.compareTo(v1.data));
      developer.log("Visite ordinate per data decrescente");
      return lista_visite;
    }, onError: (error) {
      developer.log("Errore durante la getVisite.\n${error}");
      return Future.value([]);
    });
  }

  static Future<bool> deleteVisita(Visita visita) async {
    Uri url = Uri.http(VisiteService.basicUrl, '/ospedale/deleteVisita');
    final responseVoid = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(visita.toJson()));
    if (responseVoid.statusCode == 200) {
      developer.log("Eliminata visita nel backend $visita");
      return true;
    } else {
      developer.log("Errore nella deleteVisita");
      return false;
    }
  }

  static Future<int?> postVisita(Visita visita) async {
    Uri url = Uri.http(VisiteService.basicUrl, '/ospedale/pushVisita');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(visita.toJson()));
    if (response.statusCode == 200) {
      developer.log("Aggiunta visita nel backend $visita");
      int idVisita = jsonDecode(response.body);
      return idVisita; //restituisce l'id della visita
    } else {
      developer.log("Errore nella postVisita");
      return null;
    }
  }
}
