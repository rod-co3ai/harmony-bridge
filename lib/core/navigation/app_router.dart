import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/messaging/screens/messaging_screen.dart';
import '../../features/messaging/screens/conversation_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/child_profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';

/// Router class for handling navigation in the Harmony Bridge app
class AppRouter {
  static const String initialRoute = '/onboarding';
  
  // Auth routes
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  
  // Main app routes
  static const String dashboard = '/dashboard';
  static const String calendar = '/calendar';
  static const String messaging = '/messaging';
  static const String conversation = '/conversation';
  static const String profile = '/profile';
  static const String childProfile = '/child-profile';
  static const String settings = '/settings';
  
  /// Get the app routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Auth routes
      onboarding: (context) => const OnboardingScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      
      // Main app routes
      dashboard: (context) => const DashboardScreen(),
      calendar: (context) => const CalendarScreen(),
      messaging: (context) => const MessagingScreen(),
      conversation: (context) {
        // Extract participantId from arguments or use a default value
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final participantId = args?['participantId'] ?? 'default-participant';
        return ConversationScreen(participantId: participantId);
      },
      profile: (context) => const ProfileScreen(),
      childProfile: (context) {
        // Extract childId from arguments or use a default value
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        final childId = args?['childId'] ?? 'default-child';
        return ChildProfileScreen(childId: childId);
      },
      settings: (context) => const SettingsScreen(),
    };
  }
  
  /// Navigate to a named route
  static Future<void> navigateTo(BuildContext context, String routeName, {Object? arguments}) async {
    await Navigator.pushNamed(context, routeName, arguments: arguments);
  }
  
  /// Navigate to a named route and remove all previous routes
  static Future<void> navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) async {
    await Navigator.pushNamedAndRemoveUntil(
      context, 
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
  
  /// Navigate to a named route and remove all previous routes until a specific route
  static Future<void> navigateAndRemoveUntil(BuildContext context, String routeName, String untilRouteName, {Object? arguments}) async {
    await Navigator.pushNamedAndRemoveUntil(
      context, 
      routeName,
      (route) => route.settings.name == untilRouteName,
      arguments: arguments,
    );
  }
  
  /// Navigate back
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
  
  /// Check if can go back
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }

  // Route getters for convenience
  static String get editProfile => profile;
  static String get addChild => childProfile;
  static String get editChild => childProfile;
}
