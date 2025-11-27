import 'package:atena_events_app/providers/user_provider.dart';
import 'package:atena_events_app/services/event_service.dart';
import 'package:atena_events_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'event_card.dart';
import 'recommended_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? userName;
  bool loadingUserInfo = true;

  List events = [];

  final UserService _userService = UserService();
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _loadEvents();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUser();
     });
  }

  Future<void> _loadUser() async {
  try {
    final userId = context.read<UserProvider>().userId;
    if (userId == null) {
      setState(() {
        userName = "Usuário";
        loadingUserInfo = false;
      });
      return;
    }

    final data = await _userService.getUser(userId);
    if (!mounted) return;

    setState(() {
      userName = data?["name"] ?? "Usuário";
      loadingUserInfo = false;
    });
  } catch (e) {
    print("Erro carregando usuario: $e");
  }
}

  Future<void> _loadEvents() async {
    final data = await _eventService.getRecommendedEvents();

    setState(() {
      events = data.take(8).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final has1 = events.isNotEmpty;
    final has2 = events.length >= 2;
    final has3 = events.length >= 3;
    final rest = events.length > 3 ? events.sublist(3) : [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          loadingUserInfo ? 'Carregando...' : 'Olá, $userName',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 4),
        Text(
          'Esperamos que esteja bem! =D',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),

        const SizedBox(height: 24),

        if (has1 || has2)
          Row(
            children: [
              if (has1)
                Expanded(
                  child: EventCard(
                    title: events[0]["title"] ?? "Sem título",
                    date: events[0]["date"].split('T')[0] ?? "",
                    badge: events[0]["type"] ?? "",
                    imageUrl: events[0]["imageUrl"] ?? "https://picsum.photos/400/300",
                    onTap: (_) => Navigator.pushNamed(
                      context,
                      '/eventDetails',
                      arguments: events[0]["id"],
                    ),
                  ),
                ),
              if (has1 && has2) const SizedBox(width: 12),
              if (has2)
                Expanded(
                  child: EventCard(
                    title: events[1]["title"] ?? "Sem título",
                    date: events[1]["date"].split('T')[0] ?? "",
                    badge: events[1]["type"] ?? "",
                    imageUrl: events[1]["imageUrl"] ?? "https://picsum.photos/401/301",
                    onTap: (_) => Navigator.pushNamed(
                      context,
                      '/eventDetails',
                      arguments: events[1]["id"],
                    ),
                  ),
                ),
            ],
          ),

        const SizedBox(height: 16),

        if (has3)
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/eventDetails', arguments: events[2]["id"]),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                    child: Image.network(
                      events[2]["imageUrl"] ?? "https://picsum.photos/800/260",
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: Text(
                    events[2]["title"] ?? "Sem título",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 12,
                  child: Text(
                    "${events[2]["type"] ?? ""} • ${events[2]["date"].split('T')[0] ?? ""}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/eventDetails', arguments: events[2]["id"]),
                    child: const CircleAvatar(child: Icon(Icons.play_arrow)),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 24),

        if (rest.isNotEmpty) ...[
          Text(
            'Recomendados para Você',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => RecommendedCard(
                event: {
                  "title": rest[i]["title"] ?? "Sem título",
                  "date": rest[i]["date"].split('T')[0] ?? "",
                  "type": rest[i]["type"] ?? "",
                  "imageUrl": rest[i]["imageUrl"] ?? "",
                  "id": rest[i]["id"],
                },
                index: i,
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: rest.length,
            ),
          ),
        ],
      ],
    );
  }
}
