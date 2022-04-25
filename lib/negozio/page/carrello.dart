import 'package:flutter/material.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/carrello.dart';
import 'package:taass_frontend_android/model/prodotto.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/negozio/page/ordine_seleziona_animale.dart';
import 'package:taass_frontend_android/negozio/page/quantita_picker.dart';
import 'package:taass_frontend_android/negozio/service/carrelli_service.dart';
import 'package:taass_frontend_android/negozio/service/prodotti_service.dart';

class CarrelloWidget extends StatefulWidget {
  CarrelloWidget(this.utente, {Key? key}) : super(key: key);

  Utente utente;

  @override
  State<StatefulWidget> createState() => _CarrelloWidgetState();
}

class _CarrelloWidgetState extends State<CarrelloWidget> {
  late Future<Carrello> carrello;

  _CarrelloWidgetState();

  @override
  void initState() {
    super.initState();
    carrello = CarrelliService.getCarrello(widget.utente.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrello'),
      ),
      bottomNavigationBar: MyBottomNavBar(utente: widget.utente),
      body: FutureBuilder<Carrello>(
        future: carrello,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return carrelloWidget(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget carrelloWidget(Carrello carrello) {
    List<Widget> listItems = [
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
        child: Row(
          children: [
            const Text('Totale',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('€ ${carrello.totale.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 64, 64, 64))),
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
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => OrdineSelezionaAnimale(
                        utente: widget.utente, carrello: carrello))),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45)),
            child: const Text('Procedi all\'ordine')),
      )
    ];
    listItems.addAll(
        carrello.prodotti.map((pq) => prodottoCard(carrello, pq)).toList());
    return carrello.numeroArticoli > 0
        ? ListView(
            key: UniqueKey(),
            padding: const EdgeInsets.all(8),
            children: listItems)
        : Center(
            key: UniqueKey(),
            child: const Text(
              'Il tuo carrello è vuoto',
              style: TextStyle(fontSize: 17),
            ),
          );
  }

  Widget prodottoCard(Carrello carrello, ProdottoQuantita prodottoQuantita) {
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
            QuantitaPicker(
              quantita: prodottoQuantita.quantita,
              onDecrement: decrementaQuantita(carrello, prodottoQuantita),
              onIncrement: incrementaQuantita(carrello, prodottoQuantita),
              large: false,
              minimo: 0,
            )
          ]),
        ],
      ),
    );
  }

  void Function() decrementaQuantita(
      Carrello carrello, ProdottoQuantita prodottoQuantita) {
    return () {
      CarrelliService.rimuoviProdotto(
              carrello.id!, prodottoQuantita.prodotto.id!, 1)
          .then((_) {
        setState(() {
          prodottoQuantita.quantita--;
          carrello.numeroArticoli--;
          carrello.totale -= prodottoQuantita.prodotto.prezzo;
          if (prodottoQuantita.quantita == 0) {
            carrello.prodotti.remove(prodottoQuantita);
          }
        });
      }).catchError((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "C'è stato un problema: il prodotto non è stato rimosso dal carrello")));
      });
    };
  }

  void Function() incrementaQuantita(
      Carrello carrello, ProdottoQuantita prodottoQuantita) {
    return () {
      CarrelliService.aggiungiProdotto(
              carrello.id!, prodottoQuantita.prodotto.id!, 1)
          .then((_) {
        setState(() {
          prodottoQuantita.quantita++;
          carrello.numeroArticoli++;
          carrello.totale += prodottoQuantita.prodotto.prezzo;
        });
      }).catchError((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "C'è stato un problema: il prodotto non è stato aggiunto al carrello")));
      });
    };
  }
}
