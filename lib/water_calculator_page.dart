import 'package:flutter/material.dart';
import 'package:my_components/my_components.dart';

import 'number_extensions.dart';

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
    final theme = ThemeManager.shared.theme;
    final spacings = theme.spacings;
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.borderRadius.regular),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacings.medium),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Quantos litros de água preciso beber?',
                style: MyTextStyle.h5(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Escreva abaixo o seu peso e mostraremos o quanto de água você deve ingerir',
                textAlign: TextAlign.center,
                style: MyTextStyle.light(),
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
              MyButton(
                title: 'Calcular',
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
