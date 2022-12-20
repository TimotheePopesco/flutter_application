import 'package:flutter/material.dart';
import 'package:fisurugby/page/search/players.dart';
import 'package:fisurugby/page/search/page/player_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  List<Player> players = allPlayers;

  @override
  Widget build(BuildContext context) {
    final style = controller.text.isEmpty
        ? const TextStyle(color: Colors.black54)
        : const TextStyle(color: Colors.black);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isNotEmpty
                    ? GestureDetector(
                        child: Icon(Icons.close, color: style.color),
                        onTap: () {
                          controller.clear();
                          FocusScope.of(context).requestFocus(FocusNode());

                          searchPlayer('');
                        },
                      )
                    : null,
                hintText: 'Player Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black26),
                ),
              ),
              onChanged: searchPlayer,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];

                return ListTile(
                  leading: Text(
                    player.name),
                  title: Text(player.title),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerPage(player: player),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchPlayer(String query) {
    final suggestions = allPlayers.where((player) {
      final playerTitle = player.title.toLowerCase();
      final input = query.toLowerCase();

      return playerTitle.contains(input);
    }).toList();

    setState(() => players = suggestions);
  }
}
