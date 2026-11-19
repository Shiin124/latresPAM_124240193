import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/views/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latres/views/character_view.dart';
import 'package:latres/views/favorite_spells_view.dart';

class SpellsView extends StatefulWidget {
  const SpellsView({super.key});

  @override
  State<SpellsView> createState() => _SpellsViewState();
}

class _SpellsViewState extends State<SpellsView> {
  List<dynamic> _spells = [];
  bool _isLoading = true;
  final Box _favBox = Hive.box('favorite_spells');

  @override
  void initState() {
    super.initState();
    _fetchSpells();
  }

  Future<void> _fetchSpells() async {
    final response = await http.get(
      Uri.parse('https://potterapi-fedeperin.vercel.app/en/spells'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _spells = json.decode(response.body);
        _isLoading = false;
      });
    }
  }

  void _showTopSnackBar(String title, String message, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> spell) {
    final String key = spell['index'].toString();
    final String spellName = spell['spell'] ?? '';

    if (_favBox.containsKey(key)) {
      _favBox.delete(key);
      _showTopSnackBar(
        'Remove!',
        '$spellName removed from fav list!',
        Colors.red,
      );
    } else {
      _favBox.put(key, {
        'index': spell['index'],
        'spell': spell['spell'],
        'use': spell['use'],
      });
      _showTopSnackBar(
        'Add!',
        '$spellName successfully added to fav list!',
        Colors.green,
      );
    }
    setState(() {});
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    if (!mounted) return;
    _showTopSnackBar('Success!', 'Logged out Successfully', Colors.green);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Spells Gallery'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder(
              valueListenable: _favBox.listenable(),
              builder: (context, Box box, _) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: _spells.length,
                  itemBuilder: (context, index) {
                    final spell = _spells[index];
                    final bool isFav = box.containsKey(
                      spell['index'].toString(),
                    );

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
                          icon: Icon(
                            Icons.favorite,
                            color: isFav ? Colors.red : Colors.black87,
                          ),
                          onPressed: () => _toggleFavorite(spell),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteSpellsView()),
          );
        },
        child: const Icon(Icons.favorite, color: Colors.red),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: OutlinedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CharacterView()),
            );
          },
          child: const Text('Characters'),
        ),
      ),
    );
  }
}
