import 'package:flutter/material.dart';
import 'package:fisurugby/page/search/players.dart';

class PlayerPage extends StatelessWidget {
  final Player player;

  const PlayerPage({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(player.title),
        ),
        body: Text(player.name),
      );
}
