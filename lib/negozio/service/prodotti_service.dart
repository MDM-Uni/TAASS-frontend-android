import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taass_frontend_android/model/prodotto.dart';

class ProdottiService {
  static const String baseUrl = 'http://10.0.2.2:8082/api/v1/prodotti';

  static Future<List<Prodotto>> getProdotti() {
    Uri url = Uri.parse(ProdottiService.baseUrl);
    return http.get(url).then((resp) => List<Prodotto>.from(
        jsonDecode(resp.body).map((prod) => Prodotto.fromJson(prod))));
  }

  static String getUrlImmagineProdotto(int? id) {
    return '$baseUrl/$id/immagine';
  }
}
