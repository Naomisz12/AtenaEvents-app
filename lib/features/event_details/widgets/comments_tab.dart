import 'package:atena_events_app/providers/user_provider.dart';
import 'package:atena_events_app/services/comments_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CommentsTab extends StatefulWidget {
  final int eventId;

  const CommentsTab({super.key, required this.eventId});

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  final TextEditingController _controller = TextEditingController();
  final CommentsService _service = CommentsService();

  List comments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      final data = await _service.getComments(widget.eventId);

      setState(() {
        comments = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> sendComment() async {
    if (_controller.text.isEmpty) return;

    final userProvider = context.read<UserProvider>();
    final userId = userProvider.userId;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Você precisa estar logado")),
      );
      return;
    }

    final text = _controller.text;
    _controller.clear();

    try {
      final newComment = await _service.createComment(
        eventId: widget.eventId,
        userId: userId,
        text: text,
      );

      setState(() {
        comments.add(newComment);
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao enviar comentário")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : comments.isEmpty
                  ? const Center(child: Text("Nenhum comentário ainda."))
                  : ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final c = comments[index];

                        return CommentTile(
                          name: c["authorName"] ?? "Usuário",
                          text: c["text"] ?? "",
                          timeAgo: c["createdAt"] != null
                              ? c["createdAt"].toString().split("T")[0]
                              : "",
                        );
                      },
                    ),
        ),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Escreva um comentário…',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: sendComment,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }
}

class CommentTile extends StatelessWidget {
  final String name;
  final String text;
  final String timeAgo;

  const CommentTile({
    super.key,
    required this.name,
    required this.text,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(text),
      trailing: Text(timeAgo),
    );
  }
}
