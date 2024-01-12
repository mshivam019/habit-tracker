import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:myapp/models/app_settings.dart';
import 'package:myapp/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  //initialize db
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema,AppSettingsSchema],
      directory: dir.path,
    );
  }
  //save first date of app startup for map
  Future<void> saveFirstLaunchDate() async{
    final existingSettings = await isar.appSettings.where().findFirst();
    if(existingSettings == null){
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }
  //get first date of app launch
  Future<DateTime?> getFirstLaunchDate() async{
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }
  //list habits crud
  final List<Habit> currentHabits =[];

  //create 
  Future<void> addHabit(String habitName) async{
    final newHabit = Habit()..name = habitName;

    await isar.writeTxn(() => isar.habits.put(newHabit));

    readHabits();
  }
  //read
  Future<void> readHabits() async{
    List<Habit> fetchedHabit = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchedHabit);
    notifyListeners();
  }
  //update habit state
  Future<void> updateHabitCompletion(int id, bool isCompleted) async{
    final habit = await isar.habits.get(id);
    if(habit !=null){
      await isar.writeTxn(()async {
        //if habit is completed add current date to the days list
        if(isCompleted&& !habit.completedDays.contains(DateTime.now()) ){
          final today = DateTime.now();
          // add if not already
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day
            ),
          );
        }
        // not completed remove current date from the days list
        else{
          habit.completedDays.removeWhere((date) => 
          date.year == DateTime.now().year && 
          date.month == DateTime.now().month && 
          date.day == DateTime.now().day 
          );
        }
        //save to db
        await isar.habits.put(habit);
        //read from db
        readHabits();
      });
    }
  }
  // update habit  name 
  Future<void> updateHabitName(int id, String newName) async{
    //find
    final habit = await isar.habits.get(id);
    if(habit != null){
      await isar.writeTxn(() async{
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }
  //delete
  Future<void> deleteHabit(int id) async{
    await isar.writeTxn(() async{
      await isar.habits.delete(id);
    });
    readHabits();
  }
}