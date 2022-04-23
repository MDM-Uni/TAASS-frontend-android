import 'package:flutter/material.dart';
import 'package:taass_frontend_android/generale/bottom_nav_bar.dart';
import 'package:taass_frontend_android/model/prodotto.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/negozio/page/dettagli_prodotto.dart';
import 'package:taass_frontend_android/negozio/service/prodotti_service.dart';

import 'carrello.dart';

class Negozio extends StatefulWidget {
  Negozio(this.utente, {Key? key}) : super(key: key);

  Utente utente;

  @override
  State<StatefulWidget> createState() => _NegozioState();
}

class _NegozioState extends State<Negozio> {
  late Future<List<Prodotto>> prodotti;

  _NegozioState();

  @override
  void initState() {
    super.initState();
    prodotti = ProdottiService.getProdotti();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Negozio'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
            ),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Ordini'), duration: Duration(seconds: 2))),
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (__) => CarrelloWidget(widget.utente))),
          )
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(utente: widget.utente),
      body: FutureBuilder<List<Prodotto>>(
        future: prodotti,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                padding: const EdgeInsets.all(8),
                children: snapshot.data!.map(prodottoCard).toList());
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget prodottoCard(Prodotto prodotto) {
    return Card(
      child: InkWell(
        splashColor: const Color.fromARGB(255, 217, 217, 217),
        highlightColor: const Color.fromARGB(255, 239, 239, 239),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DettagliProdotto(widget.utente, prodotto))),
        child: Row(
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Image.network(
                  ProdottiService.getUrlImmagineProdotto(prodotto.id),
                  height: 100,
                  width: 100,
                )),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text(
                  prodotto.nome,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(prodotto.categoria),
              ),
              Text(
                '€ ${prodotto.prezzo.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
