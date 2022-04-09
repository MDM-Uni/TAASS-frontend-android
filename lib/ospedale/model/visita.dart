import 'animale.dart';

class Visita {
  int? id;
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

  Map<String, String> toJson() {
    return {
      if(id!=null) 'id': id.toString(),
      'idAnimale': animale.id.toString(),
      'data': data.toIso8601String(),
      'durataInMinuti': durataInMinuti.toString(),
      if (note!= null) 'note': note!,
      'tipoVisita': tipoVisitaToString(tipoVisita).toUpperCase(),
    };
  }

  Visita.fromJson(Map<String, dynamic> json, List<Animale> animali)
      : id = json['id'],
        animale = animali.firstWhere((animale) => animale.id == json['idAnimale']),
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

  static String tipoVisitaToString(tipoVisita) {
    switch (tipoVisita) {
      case TipoVisita.OPERAZIONE:
        return "Operazione";
      case TipoVisita.CONTROLLO:
        return "Controllo";
      case TipoVisita.VACCINO:
        return "Vaccino";
      default:
        throw "Errore nella conversione in String del TipoVisita";
    }
  }
}

enum TipoVisita {
  VACCINO,
  OPERAZIONE,
  CONTROLLO,
}
