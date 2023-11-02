import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'bottle.dart';
import 'day_drink.dart';
import 'day_drink_chart.dart';
import 'default_button.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({super.key});

  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  Box<DayDrink>? box;
  final valueByTap = 0.1;

  initiateBox() async {
    final initialize = await Hive.openBox<DayDrink>('dayDrinkBox');
    final getToday = initialize.get(dateFormat.format(DateTime.now()));

    setState(() {
      box = initialize;
      currentMls = getToday?.drinkedMls ?? 0;
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

  _incrementCounter() {
    if (currentMls >= 5.9) return;
    setState(() => currentMls += valueByTap);
    final currentDate = dateFormat.format(DateTime.now());
    box?.put(currentDate, DayDrink(currentDate, currentMls));
  }

  _decrementCounter() {
    if (currentMls <= 0.1) return;
    setState(() => currentMls -= valueByTap);
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Garrafas Bebidas'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: ShapeDecoration(
                        color: Colors.blue[50],
                        shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                      height: 80,
                      child: Center(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          scrollDirection: Axis.horizontal,
                          itemCount: extraBottles,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, __) {
                            return const Bottle(
                              drinkedMls: 2000,
                              showLimit: false,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Bottle(
                        drinkedMls: currentMls - ((currentMls ~/ goal) * goal),
                      ),
                    ),
                    const SizedBox(width: 24),
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
                              currentMls.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 32,
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
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.maxFinite,
                height: 200,
                decoration: ShapeDecoration(
                  color: Colors.blue[50],
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                ),
                child: ((box?.length ?? 0) > 0)
                    ? SizedBox(
                        height: 200,
                        child: DayDrinkChart(box?.values.toList() ?? []),
                      )
                    : const Center(
                        child: Text('Sem dados salvos até o momento'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
