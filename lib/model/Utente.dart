import 'package:taass_frontend_android/model/Animale.dart';

class Utente {
  int? id;
  String? nome;
  String? password;
  String? email;
  List<Animale>? animali;

  Utente(this.nome, this.password, this.email, this.animali);
}