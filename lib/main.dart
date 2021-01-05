import 'package:flutter/material.dart';
import 'package:home_automation/screens/home_screen.dart';
import 'package:home_automation/screens/light_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Automation',
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == LightScreen.id) {
          final Color args = settings.arguments;
          return MaterialPageRoute(
            builder: (context) {
              return LightScreen(
                color: args,
              );
            },
          );
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
