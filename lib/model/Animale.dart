import 'dart:ffi';

class Animale {
  int? id;
  String? nome;
  DateTime? dataDiNascita;
  List<String>? patologie;
  String? razza;
  Float? peso;
  bool? peloLungo;

  Animale(this.nome, this.dataDiNascita, this.patologie, this.razza, this.peso,
      this.peloLungo);
  
}