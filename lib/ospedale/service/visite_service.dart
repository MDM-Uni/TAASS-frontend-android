import 'package:taass_frontend_android/ospedale/model/animale.dart';
import 'package:taass_frontend_android/ospedale/model/visita.dart';

class VisiteService {
  static Future<List<Visita>> getVisite() {
    return Future.value([
      Visita(
        id: 1,
        animale: Animale(id: 1, nome: 'Leo'),
        data: DateTime.parse('2022-01-10T10:00'),
        durataInMinuti: 30,
        tipoVisita: TipoVisita.CONTROLLO,
      ),
      Visita(
        id: 2,
        animale: Animale(id: 2, nome: 'Pippo'),
        data: DateTime.parse('2022-02-20T11:00'),
        durataInMinuti: 40,
        tipoVisita: TipoVisita.OPERAZIONE
      ),
    ]);
  }
}
