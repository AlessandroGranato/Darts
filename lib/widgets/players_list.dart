import 'package:flutter/material.dart';

import '../models/player.dart';

class PlayersList extends StatelessWidget {
  final List<Player> playersList;
  final Function showThrowDartsFunction;
  final Function deletePlayerFunction;

  PlayersList({Key? key, required this.playersList, required this.showThrowDartsFunction, required this.deletePlayerFunction}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return playersList.isEmpty
        ? Text('Add players')
        : ListView.builder(
            itemCount: playersList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage('assets/images/dart-board.png'),
                    ),
                    Column(
                      children: [
                        Text(playersList[index].name),
                        Text('points: ${playersList[index].points}'),
                      ],
                    ),
                    mediaQuery.size.width > 360
                        ? TextButton.icon(
                            onPressed: () => showThrowDartsFunction(context, playersList[index]),
                            icon: Icon(Icons.add),
                            label: Text(
                              'Throw',
                            ),
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).errorColor,
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () {},
                          ),
                    mediaQuery.size.width > 360
                        ? TextButton.icon(
                            onPressed: () => deletePlayerFunction(playersList[index].id),
                            icon: Icon(Icons.delete),
                            label: Text(
                              'Delete',
                            ),
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).errorColor,
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () {},
                          ),
                  ],
                ),
              );
            },
          );
  }
}
