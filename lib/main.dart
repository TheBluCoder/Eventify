import 'package:flutter/material.dart';
import 'features/home/pages/map_view_page.dart';
import 'providers/app_providers.dart';

void main() {
  runApp(
    AppProviders.createMultiProvider(
      child: const MyApp(),
    ),
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
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Poppins',
       
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          // foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(title: 'Echoes '),
    );
  }
}

