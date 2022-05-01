import 'dart:ffi';

class Animale {
  int id;
  String nome;
  DateTime? dataDiNascita;
  List<String>? patologie;
  String? razza;
  num? peso;
  bool? peloLungo;


  Animale({required this.id,required this.nome, this.dataDiNascita, this.patologie, this.razza, this.peso,
      this.peloLungo});

  @override
  String toString() {
    return 'Animale{id: $id, nome: $nome, dataDiNascita: $dataDiNascita, patologie: $patologie, razza: $razza, peso: $peso, peloLungo: $peloLungo}';
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id.toString(),
      'nome': nome,
      'dataDiNascita': dataDiNascita!.toIso8601String(),
      'patologie' : patologie,
      'razza' : razza,
      'peso' : peso,
      'peloLungo' : peloLungo,
    };
  }

  Animale.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        dataDiNascita = DateTime.parse(json['dataDiNascita']),
        patologie = List.from(json['patologie']),
        razza = json['razza'],
        peso = json['peso'],
        peloLungo = json['peloLungo'];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Animale && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

}