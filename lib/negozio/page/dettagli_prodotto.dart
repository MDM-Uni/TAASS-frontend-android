import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/prodotto.dart';
import 'package:taass_frontend_android/model/utente.dart';
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

  @override
  void initState() {
    super.initState();
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.network(
                    ProdottiService.getUrlImmagineProdotto(widget.prodotto.id),
                    height: 300,
                    width: 300,
                  )),
            ],
          ),
          dettagliProdottoInfo(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Text('Quantità:'),
                ),
                Card(
                  child: IconButton(
                      iconSize: 30,
                      onPressed: quantita > 1
                          ? () => setState(() => quantita--)
                          : null,
                      icon: const Icon(Icons.remove)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    quantita.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Card(
                  child: IconButton(
                      iconSize: 30,
                      onPressed: () => setState(() => quantita++),
                      icon: const Icon(Icons.add)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40)),
              onPressed: () {},
              child: const Text('Acquista'),
            ),
          )
        ],
      ),
    );
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
}
