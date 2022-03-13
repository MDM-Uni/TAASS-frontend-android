import 'package:taass_frontend_android/model/Animale.dart';

class Utente {
  int id;
  String nome;
  String email;
  List<Animale> animali;

  Utente(this.id, this.nome, this.email, this.animali);

  @override
  String toString() {
    return 'Utente{id: $id, nome: $nome, email: $email, animali: $animali}';
  }

  Utente.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nome = json['nome'],
        email = json['email'],
        animali = List.from(json['animali']).map((item)=>Animale.fromJson(item)).toList();

}