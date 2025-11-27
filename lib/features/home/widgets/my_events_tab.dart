import 'package:atena_events_app/providers/user_provider.dart';
import 'package:atena_events_app/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyEventsTab extends StatefulWidget {
  const MyEventsTab({super.key});

  @override
  State<MyEventsTab> createState() => MyEventsTabState();
}

class MyEventsTabState extends State<MyEventsTab> {
  final EventService _service = EventService();

  List createdEvents = [];
  List participatedEvents = [];

  TextEditingController searchController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadEvents() async {
    final userId = context.read<UserProvider>().userId;


    if (userId == null) {
      setState(() => loading = false);
      return;
    }

    List created = [];
    List participated = [];

    try {
      created = await _service.getCreatedEvents(userId);
      participated = await _service.getParticipatedEvents(userId);
    } catch (_) {
      created = [];
      participated = [];
    }

    if (!mounted) return;

    setState(() {
      createdEvents = created;
      participatedEvents = participated;
      loading = false;
    });
  }

  Widget buildEventCard(BuildContext context, Map event, int i) {
    final title = event["title"] ?? "Sem título";
    final id = event["id"];
    final imageUrl =
        event["imageUrl"] ?? "https://picsum.photos/${400 + i}/${300 + i}";

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/eventDetails', arguments: id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black26,
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black54,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(BuildContext context, String title, List events) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          if (events.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Nenhum evento encontrado.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            )
          else
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: events.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .85,
              ),
              itemBuilder: (_, i) => buildEventCard(context, events[i], i),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gerencie seus eventos e participações.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: searchController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Buscar evento pelo ID",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  final id = int.tryParse(searchController.text.trim());
                  if (id != null) {
                    Navigator.pushNamed(context, '/eventDetails', arguments: id);
                  }
                },
              ),
            ),
            onSubmitted: (value) {
              final id = int.tryParse(value.trim());
              if (id != null) {
                Navigator.pushNamed(context, '/eventDetails', arguments: id);
              }
            },
          ),

          const SizedBox(height: 16),
          buildSection(context, "Meus Eventos Criados", createdEvents),
          buildSection(context, "Eventos que Estou Participando", participatedEvents),
        ],
      ),
    );
  }
}
