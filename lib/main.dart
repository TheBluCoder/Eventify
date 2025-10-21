import 'controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/main_navigation_page.dart';
// import 'providers/app_providers.dart';

void main() {
  runApp(
   ChangeNotifierProvider(
    create: (context) => LocationController()..initialize(),
    child: MyApp(),
   )
  );
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Echoes ',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.withValues(alpha: 0.85),),
        useMaterial3: true,
      ).copyWith(
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
       
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          // foregroundColor: Colors.white,
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}

