import 'package:flutter/material.dart';
import 'package:taass_frontend_android/model/utente.dart';
import 'package:taass_frontend_android/ospedale/page/lista_visite.dart';
import 'package:taass_frontend_android/utente/pagine/dashboard.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({
    Key? key,
    required this.utente,
  }) : super(key: key);

  final Utente utente;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.apartment), label: "Ospedale"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_rounded), label: "Negozio"),
      ],
      onTap: (index) {
        Navigator.of(context).pop();

        switch (index) {
          case 0:
            Navigator.push(
                context, MaterialPageRoute(builder: (__) => Dashboard(utente)));
            return;
          case 1:
            Navigator.push(context,
                MaterialPageRoute(builder: (__) => ListaVisite(utente)));
            return;
          default:
            throw "Non hai implementato il case per questo BottomNavigationBarItem";
        }
      },
    );
  }
}
