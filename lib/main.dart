import 'dart:ui';

import 'package:drink_watter/bottle.dart';
import 'package:drink_watter/day_drink.dart';
import 'package:drink_watter/day_drink_chart.dart';
import 'package:drink_watter/default_button.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DayDrinkAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.trackpad,
      }),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  Box<DayDrink>? box;

  initiateBox() async {
    final initialize = await Hive.openBox<DayDrink>('dayDrinkBox');
    setState(() {
      box = initialize;
    });
  }

  double goal = 2000;
  double currentMls = 0;
  int extraBottles = 0;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    initiateBox();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      currentMls = _counter * 100;
    });

    final currentDate = dateFormat.format(DateTime(2023, 11, 01));
    box?.put(currentDate, DayDrink(currentDate, currentMls));
  }

  void _decrementCounter() {
    if (_counter == 0) return;
    setState(() {
      _counter--;
      currentMls = _counter * 100;
    });
    box?.clear();
  }

  @override
  Widget build(BuildContext context) {
    extraBottles = currentMls ~/ 2000;
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
                      color: Colors.grey[200],
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
                        drinkedMls: currentMls - (currentMls ~/ 2000 * goal),
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
                              '${currentMls / 1000}',
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
              ((box?.length ?? 0) > 0)
                  ? SizedBox(
                      height: 200,
                      child: DayDrinkChart(box?.values.toList() ?? []))
                  : Container(
                      width: double.maxFinite,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Text('Sem dados Salvos até o momento'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
