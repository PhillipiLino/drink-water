import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:my_components/my_components.dart';

import '../../domain/models/day_drink.dart';
import '../../utils/extensions/number_extensions.dart';
import '../../utils/shared_preferences_adapter.dart';
import '../widgets/bottle.dart';
import '../widgets/day_drink_chart.dart';
import '../widgets/default_button.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_buttons_list.dart';
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

  final bottlesSizes = BottleSize.values.toList().reversed;
  final glassTypes = GlassButtonSize.values.toList().reversed;

  Box<DayDrink>? box;
  double requiredDrink = 0;
  int selectedBottleSize = 1;
  BottleSize currentBottleSize = BottleSize.small;
  late String selectedDate = dateFormat.format(DateTime.now());
  late int selectedIndex = 0;
  late String topDate;

  initiateBox() async {
    box = await Hive.openBox<DayDrink>('dayDrinkBox');
    selectedIndex = (box?.values.length ?? 0) - 1;
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
    final listSize = box?.length ?? 0;
    if (listSize <= 0) return;
    final scrollEnd = chartScrollController.position.maxScrollExtent;
    if (forceOffset != null) {
      chartScrollController.jumpTo(forceOffset);
      return;
    }

    var widthOfItem = 40 + 12;
    final isLastItem = selectedIndex == listSize - 1;
    final currentOffset = chartScrollController.offset;
    final newOffset = selectedIndex * widthOfItem;
    final offsetGreaterThanFinal = newOffset > scrollEnd || isLastItem;
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

  String getDrunkedBottlesCount(num count) {
    return Intl.plural(
      count,
      zero: 'Nenhuma garrafa bebida',
      one: '1 garrafa bebida',
      other: '$count garrafas bebidas',
    );
  }

  String getBottlesCount(num count) {
    return Intl.plural(
      count.ceil(),
      zero: 'Nenhuma garrafa',
      one: '1 garrafa',
      other: '${count.toLocale()} garrafas',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.shared.theme;
    final colors = theme.colors;
    final spacings = theme.spacings;
    final borderRadius = theme.borderRadius;
    final textColor = currentMls.getDrinkedValueColor(requiredDrink);
    extraBottles = currentMls ~/ currentBottleSize.limit;

    final drinkedBottles = getDrunkedBottlesCount(extraBottles);
    const requiredDrinkText1 = 'Seu consumo de água necessário é de:\n';
    final requiredDrinkText2 = '${requiredDrink.toLocale()}L';
    const requiredDrinkText3 = ' por dia';
    const recalculateButton = 'Recalcular';
    const liters = 'Litros';

    final requiredBottles = requiredDrink / currentBottleSize.limit;
    const needDrinkText1 = 'Você precisa beber ';
    final needDrinkText2 = getBottlesCount(requiredBottles);
    const needDrinkText3 =
        ' dessa para atingir seu consumo mínimo diário de água!';
    const historyTitle = 'Histórico diário';

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(spacings.xxsmall),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacings.small),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            topDate,
                            style: MyTextStyle.h5(
                              color: colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: spacings.xxsmall),
                          Text(
                            drinkedBottles,
                            style: MyTextStyle.light(color: colors.white),
                          ),
                          SizedBox(height: spacings.xxsmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(spacings.xsmall).copyWith(
                    top: spacings.medium,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(borderRadius.large),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text: requiredDrinkText1,
                            style: MyTextStyle.small(
                              color: colors.textColors.primary,
                            ),
                            children: [
                              TextSpan(
                                text: requiredDrinkText2,
                                style: MyTextStyle.bold(),
                              ),
                              const TextSpan(text: requiredDrinkText3),
                            ],
                          ),
                        ),
                        TextButton(
                          child: Text(
                            recalculateButton,
                            style: MyTextStyle.light().underlined(
                              color: colors.secondary,
                              distance: 2,
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              enableDrag: false,
                              builder: (context) {
                                return WaterCalculatorPage((value) {
                                  setState(() => requiredDrink = value);
                                  preferences.setDouble(
                                    requiredDrinkKey,
                                    value,
                                  );
                                });
                              },
                            );
                          },
                        ),
                        Expanded(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  DropdownButton(
                                    value: selectedBottleSize,
                                    onChanged: onChangeBottleSize,
                                    items: bottlesSizes
                                        .mapIndexed(
                                          (index, e) => DropdownMenuItem(
                                            value: index + 1,
                                            child: Text(e.label),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  Expanded(
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
                              SizedBox(width: spacings.xxlarge),
                              SizedBox(
                                width: 60,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    DefaultButton(
                                      onPressed: _incrementCounter,
                                      child: const Icon(Icons.add),
                                    ),
                                    SizedBox(height: spacings.medium),
                                    Text(
                                      currentMls.toLocale(),
                                      style: MyTextStyle.h4(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      liters,
                                      style: MyTextStyle.tiny(
                                        color: colors.textColors.secondary,
                                      ),
                                    ),
                                    SizedBox(height: spacings.medium),
                                    DefaultButton(
                                      onPressed: _decrementCounter,
                                      type: MyButtonType.secondary,
                                      child: const Icon(Icons.remove),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: spacings.small),
                              GlassButtonsList(_incrementCounter),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                text: needDrinkText1,
                                style: MyTextStyle.small(
                                  color: colors.textColors.primary,
                                ),
                                children: [
                                  TextSpan(
                                    text: needDrinkText2,
                                    style: MyTextStyle.bold(),
                                  ),
                                  const TextSpan(
                                    text: needDrinkText3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: spacings.xxxsmall),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacings.xsmall,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  historyTitle,
                                  style: MyTextStyle.h4(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: spacings.xxsmall),
                        Expanded(
                          flex: 2,
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
