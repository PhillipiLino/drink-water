import 'package:hive/hive.dart';

part 'day_drink.g.dart';

@HiveType(typeId: 0)
class DayDrink extends HiveObject {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final double drinkedMls;

  DayDrink(this.date, this.drinkedMls);

  @override
  String toString() {
    return 'DATE: $date drinked: $drinkedMls';
  }
}
