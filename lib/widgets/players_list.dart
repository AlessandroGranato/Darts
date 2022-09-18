import 'package:darts/widgets/badge.dart';
import 'package:flutter/material.dart';

import '../models/player.dart';

class PlayersList extends StatelessWidget {
  final List<Player> playersList;
  int currentTurn;
  final Function showThrowDartsFunction;
  final Function deletePlayerFunction;

  PlayersList(
      {Key? key,
      required this.playersList,
      required this.currentTurn,
      required this.showThrowDartsFunction,
      required this.deletePlayerFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return playersList.isEmpty
        ? Container(
          padding: EdgeInsets.all(20),
          child: Image.asset('assets/images/start-game-text.png',
        alignment: Alignment.topCenter,
        fit: BoxFit.contain,
        
        ),)
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
                  margin: playersList[index].playerTurn == currentTurn
                      ? EdgeInsets.symmetric(vertical: 6, horizontal: 30)
                      : EdgeInsets.symmetric(vertical: 8, horizontal: 40),

                  child: Container(
                    decoration: playersList[index].playerTurn == currentTurn
                        ? BoxDecoration(
                            color: Colors.white.withOpacity(1),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(223, 229, 17, 1).withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          )
                        : null,
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
                                playerImageUrl:
                                    playersList[index].playerImageUrl,
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
