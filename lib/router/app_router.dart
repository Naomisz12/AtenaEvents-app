import 'package:atena_events_app/features/auth/screens/sign_in_screen.dart';
import 'package:atena_events_app/features/auth/screens/sign_up_screen.dart';
import 'package:atena_events_app/features/event_details/screens/event_details_screen.dart';
import 'package:atena_events_app/features/home/screens/home_screen.dart';
import 'package:atena_events_app/features/welcome/screens/welcome_sign_up_screen.dart';
import 'package:flutter/material.dart';



class AppRouter {
  static const String welcome = '/welcome';
  static const String home = '/home';

  static final Map<String, WidgetBuilder> routes = {
    '/welcome': (_) => const WelcomeSignUpScreen(),
    '/signin': (_) => const SignInScreen(),
    '/signup': (_) => const SignUpScreen(),
    '/home': (_) => const HomeScreen(),
    '/eventDetails': (context) {
      final eventId = ModalRoute.of(context)!.settings.arguments as int;
      return EventDetailsScreen(eventId: eventId);
    },
  };
}