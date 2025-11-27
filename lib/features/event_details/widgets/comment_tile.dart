import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  final String name;
  final String text;
  final String timeAgo;
  const CommentTile({super.key, required this.name, required this.text, required this.timeAgo});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      subtitle: Text(text),
      trailing: Text(
        timeAgo,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }
}