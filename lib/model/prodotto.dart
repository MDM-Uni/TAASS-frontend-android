class Prodotto {
  int? id;
  String nome;
  double prezzo;
  String categoria;

  Prodotto(
      {this.id,
      required this.nome,
      required this.prezzo,
      required this.categoria});

  factory Prodotto.fromJson(Map<String, dynamic> json) {
    return Prodotto(
        id: json['id'],
        nome: json['nome'],
        prezzo: json['prezzo'],
        categoria: json['categoria']);
  }

  //<editor-fold defaultstate="collapsed" desc="== and hashCode">
  @override
  String toString() {
    return 'Prodotto{id: $id, nome: $nome, prezzo: $prezzo, categoria: $categoria}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Prodotto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nome == other.nome &&
          prezzo == other.prezzo &&
          categoria == other.categoria;

  @override
  int get hashCode =>
      id.hashCode ^ nome.hashCode ^ prezzo.hashCode ^ categoria.hashCode;
//</editor-fold>
}

class ProdottoQuantita {
  Prodotto prodotto;
  int quantita;

  ProdottoQuantita({required this.prodotto, required this.quantita});

  factory ProdottoQuantita.fromJson(Map<String, dynamic> json) {
    return ProdottoQuantita(
        prodotto: Prodotto.fromJson(json['prodotto']),
        quantita: json['quantita']);
  }

  //<editor-fold defaultstate="collapsed" desc="== and hashCode">
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdottoQuantita &&
          runtimeType == other.runtimeType &&
          prodotto == other.prodotto &&
          quantita == other.quantita;

  @override
  int get hashCode => prodotto.hashCode ^ quantita.hashCode;
//</editor-fold>
}
