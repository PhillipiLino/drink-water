import 'dart:ui';

import 'package:drink_water/day_drink.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_components/my_components.dart';

import 'drink_page.dart';

void main() async {
  ThemeManager.shared.initializeTheme();
  Map<String, dynamic> newTheme = {
    ...ThemeManager.shared.theme.toJSON(),
  };

  newTheme['colors']['primary'] = '#1157b2';
  newTheme['colors']['secondary'] = '#609FF0';

  ThemeManager.shared.setThemeByJson(newTheme);
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: ThemeManager.shared.theme.colors.primary,
        ),
        useMaterial3: true,
      ),
      home: const DrinkPage(),
    );
  }
}
