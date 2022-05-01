import 'package:flutter/material.dart';

class QuantitaPicker extends StatefulWidget {
  void Function() onDecrement;
  void Function() onIncrement;
  bool large;
  int quantita;
  int minimo;

  QuantitaPicker(
      {required this.onDecrement,
      required this.onIncrement,
      this.large = true,
      required this.quantita,
      this.minimo = 1,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuantitaPickerState();
}

class _QuantitaPickerState extends State<QuantitaPicker> {
  late int quantita;

  _QuantitaPickerState();

  @override
  void initState() {
    super.initState();
    quantita = widget.quantita;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: widget.large ? 10 : 5),
          child: const Text('Quantità:'),
        ),
        Transform.scale(
          scale: widget.large ? 0.85 : 0.6,
          child: Card(
            color: quantita == widget.minimo
                ? const Color.fromARGB(255, 255, 139, 139)
                : Colors.red,
            child: IconButton(
                iconSize: 30,
                disabledColor: Colors.white,
                color: Colors.white,
                onPressed: quantita > widget.minimo
                    ? () {
                        quantita--;
                        widget.onDecrement();
                      }
                    : null,
                icon: const Icon(Icons.remove)),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.large ? 15 : 5),
          child: Text(
            quantita.toString(),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Transform.scale(
          scale: widget.large ? 0.85 : 0.6,
          child: Card(
            color: Colors.lightBlue,
            child: IconButton(
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  quantita++;
                  widget.onIncrement();
                },
                icon: const Icon(Icons.add)),
          ),
        )
      ],
    );
  }
}
