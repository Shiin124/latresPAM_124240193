import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/services/notification_service.dart';

class FavoriteSpellsView extends StatelessWidget {
  const FavoriteSpellsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Box favBox = Hive.box('favorite_spells');

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Spell')),
      body: ValueListenableBuilder(
        valueListenable: favBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No favorite spells added yet.'));
          }

          final keys = box.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final spell = Map<String, dynamic>.from(box.get(key));

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 1,
                child: ListTile(
                  leading: const Icon(Icons.book, size: 28),
                  title: Text(
                    spell['spell'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(spell['use'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final String spellName = spell['spell'] ?? '';
                      await box.delete(key);
                      await NotificationService.showDeleteNotification(
                        spellName,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
