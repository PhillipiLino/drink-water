import 'package:drink_water/default_button.dart';
import 'package:drink_water/glass_button.dart';
import 'package:drink_water/number_extensions.dart';
import 'package:drink_water/water_calculator_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:my_components/my_components.dart';

import 'bottle.dart';
import 'day_drink.dart';
import 'day_drink_chart.dart';
import 'shared_preferences_adapter.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({super.key});

  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  final preferences = SharedPreferencesAdapter();
  late final DateFormat topDateFormat;
  final dateFormat = DateFormat('dd/MM/yyyy');
  final requiredDrinkKey = 'required_drink';
  final bottleKey = 'selected_bottle';
  static const valueByTap = 0.01;

  Box<DayDrink>? box;
  double requiredDrink = 0;
  int selectedBottleSize = 1;
  BottleSize currentBottleSize = BottleSize.small;

  initiateBox() async {
    final initialize = await Hive.openBox<DayDrink>('dayDrinkBox');
    final getToday = initialize.get(dateFormat.format(DateTime.now()));
    final drink = await preferences.getDouble(requiredDrinkKey);

    setState(() {
      box = initialize;
      currentMls = getToday?.drinkedMls ?? 0;
      requiredDrink = drink ?? 0;
    });
  }

  initiateBottle() async {
    final bottle = await preferences.getInt(bottleKey);
    onChangeBottleSize(bottle ?? 1);
  }

  double currentMls = 0;
  int extraBottles = 0;

  @override
  void initState() {
    initializeDateFormatting('pt');
    topDateFormat = DateFormat("dd 'de' MMMM 'de' yyyy", 'pt');
    initiateBottle();
    super.initState();
    initiateBox();
  }

  _incrementCounter([double value = valueByTap]) {
    setState(() {
      currentMls + value >= 6 ? currentMls = 6 : currentMls += value;
    });

    final currentDate = dateFormat.format(DateTime.now());
    box?.put(currentDate, DayDrink(currentDate, currentMls));
  }

  _decrementCounter() {
    setState(() {
      currentMls <= 0.1 ? currentMls = 0 : currentMls -= valueByTap;
    });

    final currentDate = dateFormat.format(DateTime.now());
    box?.put(currentDate, DayDrink(currentDate, currentMls));
  }

  onChangeBottleSize(dynamic value) {
    setState(() {
      selectedBottleSize = value;
      currentBottleSize = BottleSize.big;
      if (value == 2) currentBottleSize = BottleSize.medium;
      if (value == 3) currentBottleSize = BottleSize.small;
    });

    preferences.setInt(bottleKey, selectedBottleSize);
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeManager.shared.theme.colors;
    extraBottles = currentMls ~/ currentBottleSize.limit;

    Color textColor = colors.feedbackColors.success.dark;

    if (currentMls <= 1) textColor = colors.feedbackColors.attention.dark;

    if (currentMls > 1 && currentMls < 2) textColor = colors.energy;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      topDateFormat.format(DateTime.now()),
                      style: MyTextStyle.h5(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$extraBottles garrafas bebidas',
                      style: MyTextStyle.light(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Divider(),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Seu consumo de água necessário é de:\n',
                  style: MyTextStyle.small(color: colors.textColors.primary),
                  children: [
                    TextSpan(
                      text: '${requiredDrink.toLocale()}L',
                      style: MyTextStyle.bold(),
                    ),
                    const TextSpan(text: ' por dia'),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        DropdownButton(
                          value: selectedBottleSize,
                          items: const [
                            DropdownMenuItem(
                              value: 1,
                              child: Text('2 Litros'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text('1 Litro'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text('500 ml'),
                            ),
                          ],
                          onChanged: (value) => onChangeBottleSize(value),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Bottle(
                            bottleSize: currentBottleSize,
                            drinkedMls: currentMls -
                                ((currentMls ~/ currentBottleSize.limit) *
                                    currentBottleSize.limit),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 48),
                    SizedBox(
                      width: 60,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DefaultButton(
                            onPressed: _incrementCounter,
                            child: const Icon(Icons.add),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              Text(
                                currentMls.toLocale(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'Litros',
                                style: MyTextStyle.tiny(
                                  color: colors.textColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DefaultButton(
                            onPressed: _decrementCounter,
                            type: MyButtonType.secondary,
                            child: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GlassButton(_incrementCounter, GlassButtonSize.big),
                        const SizedBox(height: 16),
                        GlassButton(_incrementCounter, GlassButtonSize.medium),
                        const SizedBox(height: 16),
                        GlassButton(_incrementCounter, GlassButtonSize.small),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Você precisa beber ',
                    style: MyTextStyle.small(color: colors.textColors.primary),
                    children: [
                      TextSpan(
                        text:
                            '${(requiredDrink / currentBottleSize.limit).toLocale()} garrafas',
                        style: MyTextStyle.bold(),
                      ),
                      const TextSpan(
                        text:
                            ' dessa para atingir seu consumo mínimo diário de água!',
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Água', style: MyTextStyle.h4()),
                      Text(
                        'histórico diário',
                        style: MyTextStyle.light(
                          color: colors.textColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 32, right: 12),
                  width: double.maxFinite,
                  child: ((box?.length ?? 0) > 0)
                      ? SizedBox(
                          child: DayDrinkChart(
                              box?.values.toList() ?? [], requiredDrink),
                        )
                      : const Center(
                          child: Text('Sem dados salvos até o momento'),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: colors.white,
        backgroundColor: colors.primary,
        mini: true,
        child: const HeroIcon(HeroIcons.calculator),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WaterCalculatorPage((value) {
                      setState(() => requiredDrink = value);
                      preferences.setDouble(requiredDrinkKey, value);
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
