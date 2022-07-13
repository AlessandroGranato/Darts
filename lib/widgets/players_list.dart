import 'package:darts/widgets/badge.dart';
import 'package:flutter/material.dart';

import '../models/player.dart';

class PlayersList extends StatelessWidget {
  final List<Player> playersList;
  final Function showThrowDartsFunction;
  final Function deletePlayerFunction;

  PlayersList(
      {Key? key,
      required this.playersList,
      required this.showThrowDartsFunction,
      required this.deletePlayerFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return playersList.isEmpty
        ? Text('Add players')
        : ListView.builder(
            itemCount: playersList.length,
            itemBuilder: (context, index) {
              return Container(
                height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.1,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  elevation: 5,
                  //color: (index == 0) ? Color.fromRGBO(255, 215, 0, 0.9): (index == 1) ? Color.fromRGBO(192, 192, 192, 0.9) : null,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 3,
                            child: Badge(
                              key: ValueKey(playersList[index].id),
                                playerImageUrl: playersList[index].playerImageUrl,
                                playerRank: index,
                                color: Colors.red)),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            playersList[index].name,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${playersList[index].points}pts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
