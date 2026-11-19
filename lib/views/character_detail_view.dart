import 'package:flutter/material.dart';

class CharacterDetailView extends StatelessWidget {
  final Map<String, dynamic> character;

  const CharacterDetailView({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> children = character['children'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(character['fullName'] ?? 'Character Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  character['image'] ?? '',
                  height: 350,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.person, size: 150),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Full Name', character['fullName']),
            _buildDetailRow('Nickname', character['nickname']),
            _buildDetailRow('Hogwarts House', character['hogwartsHouse']),
            _buildDetailRow('Interpreted By', character['interpretedBy']),
            _buildDetailRow('Birthdate', character['birthdate']),
            _buildDetailRow(
              'Children',
              children.isEmpty ? 'None' : children.join(', '),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
