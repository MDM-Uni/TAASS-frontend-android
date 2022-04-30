import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/carrello.dart';
import 'package:taass_frontend_android/model/prodotto.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/negozio/page/quantita_picker.dart';
import 'package:taass_frontend_android/negozio/service/carrelli_service.dart';
import 'package:taass_frontend_android/negozio/service/prodotti_service.dart';

class DettagliProdotto extends StatefulWidget {
  DettagliProdotto(this.utente, this.prodotto, {Key? key}) : super(key: key);

  Utente utente;
  Prodotto prodotto;

  @override
  State<StatefulWidget> createState() => _DettagliProdottoState();
}

class _DettagliProdottoState extends State<DettagliProdotto> {
  _DettagliProdottoState();

  int quantita = 1;
  late Future<Carrello> carrello;

  @override
  void initState() {
    super.initState();
    carrello = CarrelliService.getCarrello(widget.utente.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Acquista'),
        ),
        bottomNavigationBar: MyBottomNavBar(utente: widget.utente),
        body: dettagliProdottoBody());
  }

  Widget dettagliProdottoBody() {
    return FutureBuilder(
        future: carrello,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.network(
                            ProdottiService.getUrlImmagineProdotto(
                                widget.prodotto.id),
                            height: 300,
                            width: 300,
                          )),
                    ],
                  ),
                  dettagliProdottoInfo(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: QuantitaPicker(
                        quantita: 1,
                        onDecrement: () => setState(() => quantita--),
                        onIncrement: () => setState(() => quantita++)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: aggiungiAlCarrello(
                          snapshot.data, widget.prodotto, quantita),
                      child: const Text('Aggiungi al carrello'),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget dettagliProdottoInfo() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                widget.prodotto.nome,
                style:
                    const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Text(widget.prodotto.categoria),
            ),
            Text(
              '€ ${widget.prodotto.prezzo.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ]),
        ],
      ),
    );
  }

  void Function() aggiungiAlCarrello(
      Carrello carrello, Prodotto prodotto, int quantita) {
    return () {
      CarrelliService.aggiungiProdotto(carrello.id!, prodotto.id!, quantita)
          .then((_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Prodotto aggiunto al carrello")));
      }).catchError((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "C'è stato un problema: il prodotto non è stato aggiunto al carrello")));
      });
    };
  }
}
