import 'package:atena_events_app/core/widgets/app_logo.dart';
import 'package:atena_events_app/features/home/widgets/config_tab.dart';
import 'package:atena_events_app/features/home/widgets/create_event_tab.dart';
import 'package:atena_events_app/features/home/widgets/my_events_tab.dart';
import 'package:atena_events_app/features/home/widgets/profile_tab.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_item.dart';
import '../widgets/home_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppLogo()
      ),
      body: [
          HomeTab(),
          MyEventsTab(),
          ConfigTab(),
          ProfileTab(),
        ][_index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 16),
        child: SizedBox(
          width: 64,
          height: 64,
          child: FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateEventScreen()),
            ),
            shape: const CircleBorder(),
            elevation: 6,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.none,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Expanded(
                child: BottomItem(
                  icon: Icons.home,
                  label: 'Início',
                  selected: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.event,
                  label: 'Evento',
                  selected: _index == 1,
                  onTap: () {
                    setState(() => _index = 1);
                  },
                ),
              ),
              const SizedBox(width: 72),
              Expanded(
                child: BottomItem(
                  icon: Icons.settings,
                  label: 'Config',
                  selected: _index == 2,
                  onTap: () => setState(() => _index = 2),
                ),
              ),
              Expanded(
                child: BottomItem(
                  icon: Icons.person,
                  label: 'Perfil',
                  selected: _index == 3,
                  onTap: () => setState(() => _index = 3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
