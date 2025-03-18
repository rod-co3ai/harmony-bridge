import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/dashboard/providers/dashboard_provider.dart';
import 'features/calendar/providers/calendar_provider.dart';
import 'features/messaging/providers/messaging_provider.dart';
import 'features/profile/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => MessagingProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Harmony Bridge',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, // Will be dynamic in the future
        initialRoute: AppRouter.initialRoute,
        routes: AppRouter.getRoutes(),
        onGenerateRoute: (settings) {
          // Handle dynamic routes here
          return null;
        },
        builder: (context, child) {
          // Apply global styles or wrappers here
          return MediaQuery(
            // Set default text scaling
            data: MediaQuery.of(
              context,
            ).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}
