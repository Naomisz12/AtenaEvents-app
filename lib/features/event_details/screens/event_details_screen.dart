import 'package:atena_events_app/features/event_details/widgets/edit_event_screen.dart';
import 'package:provider/provider.dart';
import 'package:atena_events_app/providers/user_provider.dart';
import 'package:atena_events_app/services/event_service.dart';
import 'package:atena_events_app/features/event_details/widgets/comments_tab.dart';
import 'package:atena_events_app/features/event_details/widgets/files_tab.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class EventDetailsScreen extends StatefulWidget {
  final int eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final EventService _eventService = EventService();

  // Event data:
  String title = "Evento";
  String description = "Descrição";
  String type = "Tipo";
  String date = "0/0/0";
  bool isParticipating = false;
  int numberParticipants = 0;
  bool isLoading = true;

  int? userId;
  int ownerId = 0;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);

    // Esperar o primeiro frame para garantir que o Provider existe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchEvent();
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> fetchEvent() async {
    final userProvider = context.read<UserProvider>();

    if (userProvider.userId == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final event = await _eventService.getEventById(widget.eventId);
      final participating = await _eventService.isParticipating(
        widget.eventId,
        userProvider.userId!,
      );
      setState(() {
        title = event["title"] ?? "Evento";
        description = event["description"] ?? "Descrição";
        type = event["type"] ?? "Tipo";
        date = event["date"] ?? "0/0/0";
        ownerId = event["ownerId"];

        userId = userProvider.userId;
        isParticipating = participating;
        numberParticipants = event["participantsIds"].length;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        title = "Erro: Não encontrado";
        description = "";
        type = "";
        date = "0/0/0";
        isLoading = false;
      });
    }
  }

  Future<void> participateToggle() async {
    final userProvider = context.read<UserProvider>();

    if (userProvider.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Você precisa estar logado")),
      );
      return;
    }

    try {
      final newState = await _eventService.toggleParticipation(
        widget.eventId,
        userProvider.userId!,
      );

      setState(() {
        isParticipating = newState;
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao alterar participação")),
      );
    }
  }

  Future<void> shareEvent() async {
    final link = "https://atenaevents.page.link/event/${widget.eventId}";
    Share.share(
      "Confira este evento que encontrei no Atena Events:\n$link "
      "(caso o link não funcione, tente acessar o app pelo id ${widget.eventId})",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        'https://picsum.photos/900/300',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: IconButton.filledTonal(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),

                      if (userId != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton.filledTonal(
                            onPressed: participateToggle,
                            icon: Icon(
                              isParticipating
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                          ),
                        ),

                      if (userId == ownerId)
                        Positioned(
                          top: 8,
                          right: 104,
                          child: IconButton.filledTonal(
                            onPressed: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => EditEventScreen(eventId: widget.eventId)),
                              );

                              if (updated == true) {
                                fetchEvent();
                              }
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),

                      Positioned(
                        top: 8,
                        right: 56,
                        child: IconButton.filledTonal(
                          onPressed: shareEvent,
                          icon: const Icon(Icons.share),
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            type,
                            style: const TextStyle(color: Colors.black54),
                          ),

                          const SizedBox(height: 10),

                          Text(description),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                size: 18,
                                color: Colors.pink,
                              ),
                              const SizedBox(width: 6),
                              Text("$numberParticipants Salvos"),
                            ],
                          ),

                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined),
                              const SizedBox(width: 8),
                              Text(date),
                            ],
                          ),

                          const SizedBox(height: 12),

                          TabBar(
                            controller: _tab,
                            tabs: const [
                              Tab(text: 'Comentários'),
                              Tab(text: 'Arquivos'),
                            ],
                          ),

                          SizedBox(
                            height: 340,
                            child: TabBarView(
                              controller: _tab,
                              children: [
                                CommentsTab(eventId: widget.eventId),
                                FilesTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
