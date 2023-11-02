import 'package:drink_watter/number_extensions.dart';
import 'package:flutter/material.dart';

class WaterCalculatorPage extends StatefulWidget {
  final Function(double) onCalculate;

  const WaterCalculatorPage(
    this.onCalculate, {
    super.key,
  });

  @override
  State<WaterCalculatorPage> createState() => _WaterCalculatorPageState();
}

class _WaterCalculatorPageState extends State<WaterCalculatorPage> {
  final _weightController = TextEditingController();
  double requiredDrink = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Quantos litros de água preciso beber?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Escreva abaixo o seu peso e mostraremos o quanto de água você deve ingerir',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          hintText: 'Peso em kgs',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Text('= ${requiredDrink.toLocale()}L'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                child: const Text('Calcular'),
                onPressed: () {
                  final text = _weightController.text.replaceAll(',', '.');
                  final currentWeight = double.tryParse(text) ?? 0;

                  setState(() => requiredDrink = (currentWeight * 35.0) / 1000);
                  widget.onCalculate(requiredDrink);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
