import 'package:taass_frontend_android/model/indirizzo.dart';
import 'package:taass_frontend_android/model/prodotto.dart';

class Ordine {
  int? id;
  DateTime dataAquisto;
  DateTime? dataConsegna;
  List<ProdottoQuantita> prodotti;
  Indirizzo indirizzoConsegna;

  Ordine(
      {this.id,
      required this.dataAquisto,
      required this.dataConsegna,
      required this.prodotti,
      required this.indirizzoConsegna});

  factory Ordine.fromJson(Map<String, dynamic> json) {
    return Ordine(
        id: json['id'],
        dataAquisto: DateTime.parse(json['dataAcquisto']),
        dataConsegna: json['dataConsegna'] != null
            ? DateTime.parse(json['dataConsegna'])
            : null,
        prodotti: List<ProdottoQuantita>.from(
            json['prodotti'].map((pq) => ProdottoQuantita.fromJson(pq))),
        indirizzoConsegna: Indirizzo.fromJson(json['indirizzoConsegna']));
  }

  //<editor-fold defaultstate="collapsed" desc="== and hashCode">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ordine &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dataAquisto == other.dataAquisto &&
          dataConsegna == other.dataConsegna &&
          prodotti == other.prodotti &&
          indirizzoConsegna == other.indirizzoConsegna;

  @override
  int get hashCode =>
      id.hashCode ^
      dataAquisto.hashCode ^
      dataConsegna.hashCode ^
      prodotti.hashCode ^
      indirizzoConsegna.hashCode;
//</editor-fold>
}
