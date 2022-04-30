import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taass_frontend_android/model/carrello.dart';
import 'package:taass_frontend_android/model/ordine.dart';

class OrdiniService {
  static const String baseUrl = 'http://10.0.2.2:8082/api/v1/ordini';

  static Future<List<Ordine>> getOrdini(int id) {
    Uri url = Uri.parse('${OrdiniService.baseUrl}/$id');
    return http
        .get(url)
        .then((resp) => jsonDecode(resp.body).map((o) => Ordine.fromJson(o)));
  }

  static Future<Carrello> getOrdiniAnimale(int idUtente, int idAnimale) {
    Uri url = Uri.parse('${OrdiniService.baseUrl}/$idUtente/$idAnimale');
    return http
        .get(url)
        .then((resp) => jsonDecode(resp.body).map((o) => Ordine.fromJson(o)));
  }

  static Future<Ordine> creaOrdine(
      int idCarrello, int idIndirizzo, int idAnimale) async {
    Uri url = Uri.parse('${OrdiniService.baseUrl}/crea');
    return http.post(url, body: {
      "idCarrello": idCarrello.toString(),
      "idIndirizzo": idIndirizzo.toString(),
      "idAnimale": idAnimale.toString()
    }).then((resp) => Ordine.fromJson(jsonDecode(resp.body)));
  }

  static Future<dynamic> annullaOrdine(int idOrdine) async {
    Uri url = Uri.parse('${OrdiniService.baseUrl}/crea');
    return http.post(url, body: {"idOrdine": idOrdine}).then((_) => 0);
  }
}
