import 'package:drink_watter/bottle.dart';
import 'package:drink_watter/default_button.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
  double goal = 2000;
  double currentMls = 0;
  int extraBottles = 0;
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      currentMls = _counter * 100;
    });
  }

  void _decrementCounter() {
    if (_counter == 0) return;
    setState(() {
      _counter--;
      currentMls = _counter * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    extraBottles = currentMls ~/ 2000;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: extraBottles > 0 ? 80 : 0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: extraBottles,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) {
                  return const Bottle(drinkedMls: 2000, showLimit: false);
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Bottle(
                      drinkedMls: currentMls - (currentMls ~/ 2000 * goal),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
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
                          style: TextStyle(fontSize: 12, color: Colors.grey),
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
          ],
        ),
      ),
    );
  }
}
