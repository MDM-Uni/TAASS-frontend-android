import 'animale.dart';

class Visita {
  double? id;
  Animale animale;
  DateTime data;
  int durataInMinuti;
  String? note;
  TipoVisita tipoVisita;

  Visita(
      {this.id,
      required this.animale,
      required this.data,
      required this.durataInMinuti,
      this.note,
      required this.tipoVisita});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idAnimale': animale.id,
      'data': data.toString(),
      'note': note,
      'tipoVisita': tipoVisita.toString(),
    };
  }

  Visita.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        animale = json['idAnimale'],
        //todo fare chiamata al service degli animali
        data = DateTime.parse(json['data']),
        durataInMinuti = json['durataInMinuti'],
        note = json['note'],
        tipoVisita = tipoVisitaFromString(json['tipoVisita']);

  @override
  String toString() {
    return 'Visita{id: $id, animale: $animale, data: $data, durataInMinuti: $durataInMinuti, note: $note, tipoVisita: $tipoVisita}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Visita && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  static TipoVisita tipoVisitaFromString(String tipo) {
    switch (tipo) {
      case "VACCINO":
        return TipoVisita.VACCINO;
      case "OPERAZIONE":
        return TipoVisita.OPERAZIONE;
      case "CONTROLLO":
        return TipoVisita.CONTROLLO;
      default:
        throw "Errore nella conversione da string ($tipo) a TipoVisita";
    }
  }
}

enum TipoVisita {
  VACCINO,
  OPERAZIONE,
  CONTROLLO,
}
