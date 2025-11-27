import 'package:atena_events_app/providers/user_provider.dart';
import 'package:atena_events_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');

  final initialRoute =
      userId == null ? AppRouter.welcome : AppRouter.home;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider(UserService())..loadUser())
    ],
    child: AtenaEventApp(initialRoute : initialRoute)),
  );
}

class AtenaEventApp extends StatelessWidget {
  final String initialRoute;

  const AtenaEventApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atena Event',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: initialRoute,
      routes: AppRouter.routes,
    );
  }
}