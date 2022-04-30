import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:developer';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:taass_frontend_android/model/animale.dart';
import 'package:taass_frontend_android/model/visita.dart';
import 'package:http/http.dart' as http;

class VisiteService {
  static const String basicUrl = '10.0.2.2:8081';

  static Future<List<Visita>> getVisite(
      List<Animale> animaliDiUtente, int? idAnimale, TipoVisita? tipoVisita) async {
    final Map<String, String> parametri = {};
    if (idAnimale != null) {
      animaliDiUtente = animaliDiUtente
          .where((animale_) => animale_.id == idAnimale)
          .toList();
    }
    if (tipoVisita != null) {
      parametri['tipoVisita'] = Visita.tipoVisitaToString(tipoVisita);
    }
    Uri url = Uri.http(
        VisiteService.basicUrl, '/ospedale/getVisiteAnimali', parametri);
    log("Animali dell'utente in json:");
    log(jsonEncode(animaliDiUtente));
    final response = await http.post(
      url,
      body: jsonEncode(animaliDiUtente),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return gestisciRispostaGetVisite(response, animaliDiUtente);
  }

  static List<Visita> gestisciRispostaGetVisite(
      Response response, List<Animale> animaliDiUtente) {
    if (response.statusCode == 200) {
      List listaJson = jsonDecode(response.body);
      List<Visita> listaVisite = [];
      for (var element in listaJson) {
        try {
          listaVisite.add(Visita.fromJson(element, animaliDiUtente));
        } on StateError catch (e) {
          log("Errore nella conversione di $element in Visita");
        }
      }
      log("Visite restituite dal backend");
      listaVisite.sort((v1, v2) => v2.data.compareTo(v1.data));
      log("Visite ordinate per data decrescente");
      return listaVisite;
    } else {
      log("Errore durante la getVisite.\n${response.statusCode}");
      return List<Visita>.empty(growable: true);
    }
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
