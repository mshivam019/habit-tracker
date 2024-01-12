import 'package:flutter/material.dart';
import 'package:myapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'package:myapp/database/habit_database.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //init db
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(providers: [
      //habit
      ChangeNotifierProvider(create: (context) => HabitDatabase()),
      //theme
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ], child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
