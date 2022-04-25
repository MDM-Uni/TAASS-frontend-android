import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/animale.dart';
import 'package:taass_frontend_android/model/carrello.dart';
import 'package:taass_frontend_android/model/indirizzo.dart';
import 'package:taass_frontend_android/model/prodotto.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/negozio/page/ordine_pagamento.dart';
import 'package:taass_frontend_android/negozio/service/prodotti_service.dart';

class OrdineRiepilogo extends StatelessWidget {
  OrdineRiepilogo(
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
          title: const Text('Riepilogo'),
        ),
        bottomNavigationBar: MyBottomNavBar(utente: utente),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Row(
                children: [
                  const Text('Totale',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('€ ${carrello.totale.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 64, 64, 64))),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                        '${carrello.numeroArticoli} articol${carrello.numeroArticoli > 1 ? "i" : "o"}',
                        style: const TextStyle(fontSize: 17)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Stai acquistando per:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(animale.nome),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                'Prodotti',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Flexible(
              child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  children: carrello.prodotti.map(prodottoCard).toList()),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Text(
                'Spedizione',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Indirizzo di consegna:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(indirizzo.toString()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Tempo di consegna:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('3-5 giorni lavorativi'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OrdinePagamento(
                              utente: utente,
                              carrello: carrello,
                              animale: animale,
                              indirizzo: indirizzo))),
                  child: const Text('Acquista')),
            ),
          ],
        ));
  }

  Widget prodottoCard(ProdottoQuantita prodottoQuantita) {
    return Card(
      key: UniqueKey(), // NB: fondamentale per evitare problemi UI
      child: Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Image.network(
                ProdottiService.getUrlImmagineProdotto(
                    prodottoQuantita.prodotto.id),
                height: 100,
                width: 100,
              )),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                prodottoQuantita.prodotto.nome,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(prodottoQuantita.prodotto.categoria),
            ),
            Text(
              '€ ${prodottoQuantita.prodotto.prezzo.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const Text('Quantita:'),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      prodottoQuantita.quantita.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}
