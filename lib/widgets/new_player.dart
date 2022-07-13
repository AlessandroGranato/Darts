import 'package:flutter/material.dart';

import '../models/player.dart';

class NewPlayer extends StatefulWidget {
  final int playerTurn;
  final int startingPoints;
  final Function addPlayerFunction;
  final String playerImageUrl;
  
  const NewPlayer({Key? key, required this.addPlayerFunction, required this.playerTurn, required this.startingPoints, required this.playerImageUrl})
      : super(key: key);

  @override
  State<NewPlayer> createState() => _NewPlayerState();
}

class _NewPlayerState extends State<NewPlayer> {
  final TextEditingController _nameController = TextEditingController();

  void _submitData() {
    if (_nameController.text.isEmpty) {
      return;
    }

    String playerName = _nameController.text;
    String id = '${playerName}-${DateTime.now().toString()}';
    Player newPlayer = Player(id: id, name: playerName, points:  widget.startingPoints, playerTurn: widget.playerTurn, playerImageUrl: widget.playerImageUrl);
    widget.addPlayerFunction(newPlayer);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: mediaQuery.viewInsets.bottom + 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text("Add new player", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Player name',
              ),
              controller: _nameController,
              onFieldSubmitted: (_) => _submitData(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Theme.of(context).textTheme.button?.color),
              onPressed: _submitData,
              child: const Text('Add player'),
            ),
          ],
        ),
      ),
    );
  }
}
