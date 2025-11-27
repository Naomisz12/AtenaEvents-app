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

    final user = context.read<UserProvider>();
    final userId = user.userId;

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

      setState(() => comments.add(newComment));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao enviar comentário")),
      );
    }
  }

  Future<void> editComment(Map comment) async {
    final controller = TextEditingController(text: comment["text"]);

    final newText = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar comentário"),
        content: TextField(
          controller: controller,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text("Salvar"),
          ),
        ],
      ),
    );

    if (newText == null || newText.trim().isEmpty) return;

    final userId = context.read<UserProvider>().userId;
    if(userId == null) throw Exception("Usuário deslogado");

    try {
      await _service.updateComment(
        commentId: comment["id"],
        newText: newText, 
      );

      setState(() {
        comment["text"] = newText;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao editar comentário")),
      );
    }
  }

  Future<void> deleteComment(Map comment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Deletar comentário"),
        content: const Text("Tem certeza que deseja deletar este comentário?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Deletar"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.deleteComment(commentId: comment["id"]);

      setState(() {
        comments.remove(comment);
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao deletar comentário")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UserProvider>().userId;

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
                        final isAuthor = c["authorId"] == userId;

                        return CommentTile(
                          name: c["authorName"] ?? "Usuário",
                          text: c["text"],
                          timeAgo: c["createdAt"]
                                  ?.toString()
                                  .split("T")
                                  .first ??
                              "",
                          canEdit: isAuthor,
                          onEdit: () => editComment(c),
                          onDelete: () => deleteComment(c),
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
  final bool canEdit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommentTile({
    super.key,
    required this.name,
    required this.text,
    required this.timeAgo,
    required this.canEdit,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(text),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(timeAgo),
          if (canEdit) ...[
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: onDelete,
            ),
          ]
        ],
      ),
    );
  }
}
