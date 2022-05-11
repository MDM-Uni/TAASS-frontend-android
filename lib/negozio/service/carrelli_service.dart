import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taass_frontend_android/model/carrello.dart';

class CarrelliService {
  static const String baseUrl = 'http://10.0.2.2:8082/api/v1/carrelli';

  static Future<Carrello> getCarrello(int id) {
    Uri url = Uri.parse('${CarrelliService.baseUrl}/$id');
    return http
        .get(url)
        .then((resp) => Carrello.fromJson(jsonDecode(resp.body)));
  }

  static Future<Carrello> aggiungiProdotto(
      int idCarrello, int idProdotto, int quantita) async {
    Uri url = Uri.parse('${CarrelliService.baseUrl}/$idCarrello/aggiungi');
    return http.post(url, body: {
      "idProdotto": idProdotto.toString(),
      "quantita": quantita.toString()
    }).then((resp) => Carrello.fromJson(jsonDecode(resp.body)));
  }

  static Future<dynamic> rimuoviProdotto(
      int idCarrello, int idProdotto, int quantita) async {
    Uri url = Uri.parse('${CarrelliService.baseUrl}/$idCarrello/rimuovi');
    return http.post(url, body: {
      "idProdotto": idProdotto.toString(),
      "quantita": quantita.toString()
    }).then((_) => 0);
  }
}
