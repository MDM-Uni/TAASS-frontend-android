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
