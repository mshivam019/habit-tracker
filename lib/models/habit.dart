import 'package:isar/isar.dart';
// cmd command to generate file: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit{
  Id id = Isar.autoIncrement;

  late String name;

  List<DateTime> completedDays =[
    //DateTime(year,month,day)
  ];
}