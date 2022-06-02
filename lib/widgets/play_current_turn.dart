import 'package:flutter/material.dart';

import '../models/player.dart';

class PlayCurrentTurn extends StatelessWidget {
  final List<Player> playersList;
  final int currentTurn;
  final Function showThrowDartsFunction;
  final Function incrementTurnFunction;
  const PlayCurrentTurn(
      {Key? key,
      required this.playersList,
      required this.showThrowDartsFunction,
      required this.currentTurn,
      required this.incrementTurnFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final int actualTurn = currentTurn == 0 ? 0 :  currentTurn - 1;
    final mediaQuery = MediaQuery.of(context);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: playersList.isEmpty
            ? Text('Add players')
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('It\'s your turn'),
                      Text('${playersList[currentTurn].name}'),
                    ],
                  ),
                  Column(
                    children: [
                      mediaQuery.size.width > 360
                          ? TextButton.icon(
                              onPressed: () => showThrowDartsFunction(
                                  context, playersList[currentTurn]),
                              icon: Icon(Icons.add),
                              label: Text(
                                'Throw',
                              ),
                              style: TextButton.styleFrom(
                                primary: Theme.of(context).errorColor,
                              ),
                            )
                          : IconButton(
                              icon: Icon(Icons.add),
                              color: Theme.of(context).errorColor,
                              onPressed: () => showThrowDartsFunction(
                                  context, playersList[currentTurn]),
                            ),
                      mediaQuery.size.width > 360
                          ? TextButton.icon(
                              onPressed: () => incrementTurnFunction(),
                              icon: Icon(Icons.delete),
                              label: Text(
                                'Skip Turn',
                              ),
                              style: TextButton.styleFrom(
                                primary: Theme.of(context).errorColor,
                              ),
                            )
                          : IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).errorColor,
                              onPressed: () => incrementTurnFunction(),
                            ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
