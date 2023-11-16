import 'package:flutter/material.dart';
import 'package:my_components/my_components.dart';

import '../../utils/extensions/number_extensions.dart';

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

    const title = 'Quantos litros de água preciso beber?';
    const message =
        'Escreva abaixo o seu peso e mostraremos o quanto de água você deve ingerir';
    const textHint = 'Peso em kgs';
    const btnTitle = 'Calcular';

    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.borderRadius.large),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacings.medium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: MyTextStyle.h5(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacings.medium),
              Text(
                message,
                textAlign: TextAlign.center,
                style: MyTextStyle.light(),
              ),
              SizedBox(height: spacings.medium),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _weightController,
                        decoration: const InputDecoration(hintText: textHint),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Text('= ${requiredDrink.toLocale()}L'),
                  ],
                ),
              ),
              SizedBox(height: spacings.xlarge),
              SizedBox(
                width: double.maxFinite,
                child: MyButton(
                  title: btnTitle,
                  onPressed: () {
                    final text = _weightController.text.replaceAll(',', '.');
                    final currentWeight = double.tryParse(text) ?? 0;

                    setState(
                      () => requiredDrink = (currentWeight * 35.0) / 1000,
                    );
                    widget.onCalculate(requiredDrink);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
