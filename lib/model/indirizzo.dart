class Indirizzo {
  int? id;
  String citta;
  String via;
  int numeroCivico;
  String? interno;

  Indirizzo(
      {this.id,
      required this.citta,
      required this.via,
      required this.numeroCivico,
      this.interno});

  factory Indirizzo.fromJson(Map<String, dynamic> json) {
    return Indirizzo(
        id: json['id'],
        citta: json['citta'],
        via: json['via'],
        numeroCivico: json['numeroCivico'],
        interno: json['interno']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'citta': citta,
      'via': via,
      'numeroCivico': numeroCivico,
      'interno': interno
    };
  }

  @override
  String toString() {
    return citta +
        ', ' +
        via +
        ' ' +
        numeroCivico.toString() +
        (interno != null ? '/' + interno! : '');
  }

  //<editor-fold defaultstate="collapsed" desc="== and hashCode">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Indirizzo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          citta == other.citta &&
          via == other.via &&
          numeroCivico == other.numeroCivico &&
          interno == other.interno;

  @override
  int get hashCode =>
      id.hashCode ^
      citta.hashCode ^
      via.hashCode ^
      numeroCivico.hashCode ^
      interno.hashCode;
//</editor-fold>
}
