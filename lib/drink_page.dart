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

  Box<DayDrink>? box;
  static const valueByTap = 0.05;
  double requiredDrink = 0;

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

  double goal = 2;
  double currentMls = 0;
  int extraBottles = 0;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    extraBottles = currentMls ~/ 2;
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
                              itemBuilder: (_, __) {
                                return const Bottle(
                                  drinkedMls: 2,
                                  showLimit: false,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Bottle(
                        drinkedMls: currentMls - ((currentMls ~/ goal) * goal),
                      ),
                    ),
                    const SizedBox(width: 48),
                    Column(
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
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              'Litros',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
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
                    const SizedBox(width: 16),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
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
