import 'package:flutter/material.dart';

class FilesTab extends StatelessWidget {
  const FilesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(
        4,
        (i) => ListTile(
          leading: const Icon(Icons.insert_drive_file),
          title: Text('Arquivo_${i + 1}.pdf'),
          subtitle: const Text('120 KB'),
        ),
      ),
    );
  }
}