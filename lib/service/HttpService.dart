import 'dart:convert';
import 'package:taass_frontend_android/model/Animale.dart';
import 'package:taass_frontend_android/model/Utente.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String URL = "http://10.0.2.2:8080";

  Future<Utente> getUtente(Utente utente) async {
    final response = await http.get(Uri.parse(URL + '/user/' + utente.email + '/' + utente.nome));
    if(response.statusCode == 200) {
      return Utente.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load user information');
  }

  Future<bool> removeAnimal(Utente utente, Animale animale) async {
    final response = await http.delete(Uri.parse(URL + '/removeAnimal/' + utente.id.toString() + '/' + animale.id.toString()));
    if(response.statusCode == 200){
      return true;
    }
    return false;
  }

  Future<Animale> updateAnimal(Utente utente, Animale animale, Animale animaleAggiornato) async{
    final response = await http.put(Uri.parse(URL + '/updateAnimal/' + utente.id.toString() + '/' + animale.id.toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(animaleAggiornato));

    if(response.statusCode == 200){

      return Animale.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to remove animal');
  }

  Future<Utente> addAnimal(Utente utente,Animale animale) async {
    print(jsonEncode(animale));
    final response = await http.post(Uri.parse(URL + '/addAnimal/' + utente.id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(animale));
    if(response.statusCode == 200) {
      return Utente.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to add animal');
  }

}