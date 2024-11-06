import 'package:flutter/material.dart';
import 'package:taskmanagementsystem/controller/home_screen_controller.dart';
import 'package:taskmanagementsystem/utils/color_constants.dart';
import 'package:taskmanagementsystem/view/home_screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeScreenController.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: ColorConstants.primaryColor),
        home: HomeScreen());
  }
}
