import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/loading_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_edit_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notification_settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const RemindersApp(),
    ),
  );
}

class RemindersApp extends StatelessWidget {
  const RemindersApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    
    return MaterialApp(
      title: 'Reminders',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.primaryColor,
          primary: settings.primaryColor,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.primaryColor,
          primary: settings.primaryColor,
          brightness: Brightness.dark,
          surface: const Color(0xFF101922),
        ),
        scaffoldBackgroundColor: const Color(0xFF101922),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/main': (context) => const DashboardScreen(),
        '/add_edit': (context) => const AddEditScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/settings/notifications': (context) => const NotificationSettingsScreen(),
      },
    );
  }
}
