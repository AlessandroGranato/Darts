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

    print('PLAY_CURRENT_TURN - currentTurn: ${currentTurn}');
    for (Player player in playersList) {
      print('PLAY_CURRENT_TURN - Player: ${player.name} has turn: ${player.playerTurn}');
    }
    
    final mediaQuery = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(20),
      height: double.infinity,
      width: double.infinity,
      child: playersList.isEmpty
          ? Text('')
          : Column(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: IntrinsicHeight(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: InkWell(
                              onTap: () => showThrowDartsFunction(
                                  context, playersList[playersList.indexWhere((element) => element.playerTurn == currentTurn)]),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                
                                child: Image.asset(
                                  'assets/images/throw.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: InkWell(
                              onTap: () => incrementTurnFunction(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                height: double.infinity,
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/skip.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                      Image.asset(
                        "assets/images/banner.png",
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'It\'s your turn',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '${playersList[playersList.indexWhere((element) => element.playerTurn == currentTurn)].name.toUpperCase()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }
}
