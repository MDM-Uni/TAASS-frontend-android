import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taass_frontend_android/model/indirizzo.dart';

class IndirizziService {
  static const String baseUrl = 'http://10.0.2.2:8079/indirizzi';

  static Future<List<Indirizzo>> getIndirizzi(int id) {
    Uri url = Uri.parse('${IndirizziService.baseUrl}/$id');
    return http.get(url).then((resp) => List<Indirizzo>.from(
        jsonDecode(resp.body).map((ind) => Indirizzo.fromJson(ind))));
  }

  static Future<Indirizzo> aggiungiIndirizzo(int idUtente, String citta,
      String via, int numeroCivico, String? interno) async {
    Uri url = Uri.parse('${IndirizziService.baseUrl}/$idUtente/crea');
    Indirizzo indirizzo = Indirizzo(
        citta: citta, via: via, numeroCivico: numeroCivico, interno: interno);
    return http
        .post(url, body: jsonEncode(indirizzo))
        .then((resp) => jsonDecode(resp.body));
  }

  static Future<dynamic> rimuoviIndirizzo(int idUtente, int idIndirizzo) async {
    Uri url = Uri.parse('${IndirizziService.baseUrl}/$idUtente/rimuovi');
    return http.post(url, body: {"idIndirizzo": idIndirizzo}).then((_) => 0);
  }
}
