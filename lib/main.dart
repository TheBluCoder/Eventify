import 'controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Echoes ',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white.withValues(alpha: 0.85),),
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
      routerConfig: AppRouter.router,
    );
  }
}

