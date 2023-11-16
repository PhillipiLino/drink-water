import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:my_components/my_components.dart';

import 'bottle.dart';
import 'day_drink.dart';
import 'day_drink_chart.dart';
import 'default_button.dart';
import 'glass_button.dart';
import 'number_extensions.dart';
import 'shared_preferences_adapter.dart';
import 'water_calculator_page.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({super.key});

  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  final preferences = SharedPreferencesAdapter();
  late final chartScrollController = ScrollController(
    onAttach: (position) async {
      await Future.delayed(const Duration(milliseconds: 300));
      scrollChartToIndex(position.maxScrollExtent);
    },
  );

  late final DateFormat topDateFormat;
  final dateFormat = DateFormat('dd/MM/yyyy');
  final requiredDrinkKey = 'required_drink';
  final bottleKey = 'selected_bottle';
  static const valueByTap = 0.01;

  Box<DayDrink>? box;
  double requiredDrink = 0;
  int selectedBottleSize = 1;
  BottleSize currentBottleSize = BottleSize.small;
  late String selectedDate = dateFormat.format(DateTime.now());
  late int selectedIndex = 0;
  late String topDate;

  initiateBox() async {
    box = await Hive.openBox<DayDrink>('dayDrinkBox');
    setDateInfo(selectedDate, false);
  }

  setDateInfo(String date, [bool scroll = true]) async {
    final getToday = box?.get(date);
    final drink = await preferences.getDouble(requiredDrinkKey);
    final topDateTime = dateFormat.parse(date);
    topDate = topDateFormat.format(topDateTime);

    setState(() {
      currentMls = getToday?.drinkedMls ?? 0;
      requiredDrink = drink ?? 0;
    });

    if (!scroll) return;
    scrollChartToIndex();
  }

  scrollChartToIndex([double? forceOffset]) {
    if ((box?.length ?? 0) <= 0) return;
    final scrollEnd = chartScrollController.position.maxScrollExtent;
    if (forceOffset != null) {
      chartScrollController.jumpTo(forceOffset);
      return;
    }

    final currentOffset = chartScrollController.offset;
    final newOffset = selectedIndex * 35;
    final offsetGreaterThanFinal = newOffset > scrollEnd;
    final offsetToUse = offsetGreaterThanFinal ? scrollEnd : newOffset;

    if (offsetToUse >= currentOffset - 2 && offsetToUse <= -currentOffset + 2) {
      return;
    }

    chartScrollController.animateTo(
      offsetToUse.toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
    topDate = topDateFormat.format(DateTime.now());

    initiateBottle();
    super.initState();
    initiateBox();
  }

  _incrementCounter([double value = valueByTap]) {
    setState(() {
      currentMls + value >= 6 ? currentMls = 6 : currentMls += value;
    });

    box?.put(selectedDate, DayDrink(selectedDate, currentMls));
    scrollChartToIndex();
  }

  _decrementCounter() {
    setState(() {
      currentMls <= 0.1 ? currentMls = 0 : currentMls -= valueByTap;
    });

    box?.put(selectedDate, DayDrink(selectedDate, currentMls));
    scrollChartToIndex();
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
      backgroundColor: colors.secondary,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(

                    // borderRadius: BorderRadius.circular(12),
                    ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            topDate,
                            style: MyTextStyle.h5(
                              color: colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$extraBottles garrafas bebidas',
                            style: MyTextStyle.light(
                              color: colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12).copyWith(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Seu consumo de água necessário é de:\n',
                            style: MyTextStyle.small(
                              color: colors.textColors.primary,
                            ),
                            children: [
                              TextSpan(
                                text: '${requiredDrink.toLocale()}L',
                                style: MyTextStyle.bold(),
                              ),
                              const TextSpan(text: ' por dia'),
                            ],
                          ),
                        ),
                        TextButton(
                          child: Text(
                            'Recalcular',
                            style: MyTextStyle.light().underlined(
                              color: colors.secondary,
                              distance: 2,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      WaterCalculatorPage((value) {
                                        setState(() => requiredDrink = value);
                                        preferences.setDouble(
                                          requiredDrinkKey,
                                          value,
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
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
                                    onChanged: (value) =>
                                        onChangeBottleSize(value),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Bottle(
                                      bottleSize: currentBottleSize,
                                      drinkedMls: currentMls -
                                          ((currentMls ~/
                                                  currentBottleSize.limit) *
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
                                  GlassButton(
                                    _incrementCounter,
                                    GlassButtonSize.big,
                                  ),
                                  const SizedBox(height: 16),
                                  GlassButton(
                                    _incrementCounter,
                                    GlassButtonSize.medium,
                                  ),
                                  const SizedBox(height: 16),
                                  GlassButton(
                                    _incrementCounter,
                                    GlassButtonSize.small,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Você precisa beber ',
                              style: MyTextStyle.small(
                                color: colors.textColors.primary,
                              ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Histórico diário',
                                  style: MyTextStyle.h4().copyWith(
                                    fontWeight: FontWeight.w600,
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
                            margin: const EdgeInsets.only(left: 12, right: 12),
                            width: double.maxFinite,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colors.elementsColors.lineAndBorders,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [],
                              ),
                              child: DayDrinkChart(
                                box?.values.toList() ?? [],
                                requiredDrink,
                                selectedDate,
                                scrollController: chartScrollController,
                                onTapBar: (index, data) {
                                  setState(() {
                                    selectedDate = data.xValue;
                                    selectedIndex = index;
                                  });

                                  setDateInfo(selectedDate);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
