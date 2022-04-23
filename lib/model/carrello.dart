import 'package:taass_frontend_android/model/prodotto.dart';

class Carrello {
  int? id;
  List<ProdottoQuantita> prodotti;
  double totale;
  int numeroArticoli;

  Carrello(
      {this.id,
      required this.prodotti,
      required this.totale,
      required this.numeroArticoli});

  factory Carrello.fromJson(Map<String, dynamic> json) {
    return Carrello(
        id: json['id'],
        prodotti: List<ProdottoQuantita>.from(
            json['prodotti'].map((pq) => ProdottoQuantita.fromJson(pq))),
        totale: json['totale'],
        numeroArticoli: json['numeroArticoli']);
  }

  //<editor-fold defaultstate="collapsed" desc="== and hashCode">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Carrello &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          prodotti == other.prodotti &&
          totale == other.totale &&
          numeroArticoli == other.numeroArticoli;

  @override
  int get hashCode =>
      id.hashCode ^
      prodotti.hashCode ^
      totale.hashCode ^
      numeroArticoli.hashCode;
//</editor-fold>
}
