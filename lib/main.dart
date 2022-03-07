import 'package:date_piker/database.dart';
import 'package:date_piker/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

void main() {
  runApp(const MyApp());
}

// follow @flutter_tg in instagram

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Samim',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    goToHome();
    super.initState();
  }

  goToHome() async {
    // PlanDatabase.instance.add(
    //   Plan(
    //     title: 'یک تیتر ساختگی',
    //     text:
    //         'یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی',
    //     date: DateTime(DateTime.now().year, DateTime.now().month,
    //             DateTime.now().day, 12, 00)
    //         .toString(),
    //     isdone: 0,
    //   ),
    // );
    // PlanDatabase.instance.add(
    //   Plan(
    //     title: 'یک تیتر ساختگی',
    //     text:
    //         'یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی',
    //     date: DateTime(DateTime.now().year, DateTime.now().month,
    //             DateTime.now().day, 15, 30)
    //         .toString(),
    //     isdone: 0,
    //   ),
    // );
    // PlanDatabase.instance.add(
    //   Plan(
    //     title: 'یک تیتر ساختگی',
    //     text:
    //         'یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی',
    //     date: DateTime(DateTime.now().year, DateTime.now().month,
    //             DateTime.now().day, 20, 00)
    //         .toString(),
    //     isdone: 0,
    //   ),
    // );
    // ////////////////////////////
    // PlanDatabase.instance.add(
    //   Plan(
    //     title: 'یک تیتر ساختگی',
    //     text:
    //         'یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی',
    //     date: DateTime(DateTime.now().year, DateTime.now().month,
    //             DateTime.now().day + 4, 20, 00)
    //         .toString(),
    //     isdone: 0,
    //   ),
    // );
    // PlanDatabase.instance.add(
    //   Plan(
    //     title: 'یک تیتر ساختگی',
    //     text:
    //         'یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی',
    //     date: DateTime(DateTime.now().year, DateTime.now().month,
    //             DateTime.now().day + 4, 12, 23)
    //         .toString(),
    //     isdone: 0,
    //   ),
    // );
    // PlanDatabase.instance.add(
    //   Plan(
    //     title: 'یک تیتر ساختگی',
    //     text:
    //         'یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی',
    //     date: DateTime(DateTime.now().year, DateTime.now().month,
    //             DateTime.now().day + 4, 8, 10)
    //         .toString(),
    //     isdone: 0,
    //   ),
    // );
    // PlanDatabase.instance.add(
    //   Plan(
    //     title: 'یک تیتر ساختگی',
    //     text:
    //         'یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی یک متن ساختگی',
    //     date: DateTime(DateTime.now().year, DateTime.now().month,
    //             DateTime.now().day + 4, 10, 20)
    //         .toString(),
    //     isdone: 0,
    //   ),
    // );

    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GradientText(
              'Planner App',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
              gradientType: GradientType.radial,
              radius: 2.5,
              colors: const [
                Colors.lightBlueAccent,
                Colors.yellowAccent,
                Colors.orangeAccent,
                Colors.pinkAccent,
              ],
            ),
            const Text(
              'Follow @Flutter_Tg in instagram',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
