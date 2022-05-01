import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/animale.dart';
import 'package:taass_frontend_android/model/carrello.dart';
import 'package:taass_frontend_android/model/indirizzo.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/negozio/page/ordine_conferma.dart';
import 'package:taass_frontend_android/negozio/service/ordini_service.dart';

import 'carrello.dart';

class OrdinePagamento extends StatelessWidget {
  OrdinePagamento(
      {required this.utente,
      required this.carrello,
      required this.animale,
      required this.indirizzo,
      Key? key})
      : super(key: key);

  Utente utente;
  Carrello carrello;
  Animale animale;
  Indirizzo indirizzo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pagamento'),
        ),
        bottomNavigationBar: MyBottomNavBar(utente: utente),
        body: Column(
          children: [
            const Center(
              heightFactor: 10,
              child: Text('Pagina di pagamento (seconda release)'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () {
                    OrdiniService.creaOrdine(
                            carrello.id!, indirizzo.id!, animale.id)
                        .then((_) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => OrdineConferma(utente: utente)));
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '$error\nC\'è stato un problema. L\'ordine non è stato effettuato')));
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (c) => CarrelloWidget(utente)),
                          (route) => false);
                    });
                  },
                  child: const Text('Paga')),
            )
          ],
        ));
  }
}
