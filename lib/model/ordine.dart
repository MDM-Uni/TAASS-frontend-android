import 'package:taass_frontend_android/model/indirizzo.dart';
import 'package:taass_frontend_android/model/prodotto.dart';

import 'animale.dart';

class Ordine {
  int? id;
  DateTime dataAcquisto;
  DateTime? dataConsegna;
  List<ProdottoQuantita> prodotti;
  Indirizzo indirizzoConsegna;
  int numeroArticoli;
  double totale;

  Ordine(
      {this.id,
      required this.dataAcquisto,
      required this.dataConsegna,
      required this.prodotti,
      required this.indirizzoConsegna,
      required this.numeroArticoli,
      required this.totale});

  Ordine.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dataAcquisto = DateTime.parse(json['dataAcquisto']),
        dataConsegna = json['dataConsegna'] != null
            ? DateTime.parse(json['dataConsegna'])
            : null,
        prodotti = List<ProdottoQuantita>.from(
            json['prodotti'].map((pq) => ProdottoQuantita.fromJson(pq))),
        indirizzoConsegna = Indirizzo.fromJson(json['indirizzoConsegna']),
        numeroArticoli = json['numeroArticoli'],
        totale = json['totale'];

  //<editor-fold defaultstate="collapsed" desc="== and hashCode">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Ordine &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dataAcquisto == other.dataAcquisto &&
          dataConsegna == other.dataConsegna &&
          prodotti == other.prodotti &&
          indirizzoConsegna == other.indirizzoConsegna;

  @override
  int get hashCode =>
      id.hashCode ^
      dataAcquisto.hashCode ^
      dataConsegna.hashCode ^
      prodotti.hashCode ^
      indirizzoConsegna.hashCode;
//</editor-fold>
}

class AnimaleOrdine {
  Animale animale;
  Ordine ordine;

  AnimaleOrdine({required this.animale, required this.ordine});

  AnimaleOrdine.fromJson(Map<String, dynamic> json)
      : animale = parseAnimale(json),
        ordine = Ordine.fromJson(json['ordine']);

  static Animale parseAnimale(Map<String, dynamic> json) {
    json['animale'].addAll({
      "nome": "nulla",
      "dataDiNascita": "1900-01-01 00:00:00Z",
      "patologie": [],
      "razza": null,
      "peso": null,
      "peloLungo": null
    });
    return Animale.fromJson(json['animale']);
  }
}
