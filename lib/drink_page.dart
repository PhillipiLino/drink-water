import 'package:drink_water/glass_button.dart';
import 'package:drink_water/number_extensions.dart';
import 'package:drink_water/water_calculator_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'bottle.dart';
import 'day_drink.dart';
import 'day_drink_chart.dart';
import 'default_button.dart';
import 'shared_preferences_adapter.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({super.key});

  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  final preferences = SharedPreferencesAdapter();
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
    extraBottles = currentMls ~/ currentBottleSize.limit;

    Color textColor = Colors.blue;

    if (currentMls <= 1) textColor = Colors.red;

    if (currentMls > 1 && currentMls < 2) {
      textColor = const Color.fromARGB(255, 222, 168, 4);
    }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Garrafas Bebidas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: extraBottles > 0
                          ? ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: extraBottles,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (_, index) {
                                return Stack(
                                  children: [
                                    Bottle(
                                      drinkedMls: 2,
                                      bottleSize: currentBottleSize,
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )
                          : const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Você ainda não bebeu nenhuma garrafa completa hoje',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),
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
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: '${requiredDrink.toLocale()}L',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
                              const Text(
                                'Litros',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DefaultButton(
                            onPressed: _decrementCounter,
                            style: DefaultButtonStyle.secondary,
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
                child: Text(
                  'Você precisa beber ${(requiredDrink / currentBottleSize.limit).toLocale()} garrafas dessa para atingir seu consumo mínimo diário de água!',
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 32,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Água',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'histórico diário',
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 20,
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
                          child: DayDrinkChart(box?.values.toList() ?? []),
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
        backgroundColor: Colors.blue[100],
        foregroundColor: Colors.blue,
        mini: true,
        child: const Icon(Icons.calculate_rounded),
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
