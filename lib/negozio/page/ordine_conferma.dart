import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/negozio/page/negozio.dart';

class OrdineConferma extends StatelessWidget {
  OrdineConferma({required this.utente, Key? key}) : super(key: key);

  Utente utente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Conferma'),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: MyBottomNavBar(utente: utente),
        body: Column(
          children: [
            const Center(
              heightFactor: 10,
              child: Text(
                  'Ordine confermato.\nPuoi visualizzare il tuo acquisto nella sezione ordini.'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => Negozio(utente)),
                      (route) => false),
                  child: const Text('Torna al negozio')),
            )
          ],
        ));
  }
}
