import 'package:flutter/material.dart';

import '../models/player.dart';
import '../widgets/throw_darts.dart';
import '../widgets/throw_final_darts.dart';

class ShowThrowDarts extends StatelessWidget {
  final Player player;
  final Function addPointsFunction;
  final int endingPoints;
  const ShowThrowDarts(
      {Key? key, required this.player, required this.addPointsFunction, required this.endingPoints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Ending points: ${endingPoints}');
    print('Player points: ${player.points}');
    print('endingPoints - player.points = ${endingPoints - player.points}');
    return Container(
      child: endingPoints - player.points > 40
          ? ThrowDarts(player: player, addPointsFunction: addPointsFunction)
          : ThrowFinalDarts(player: player, addPointsFunction: addPointsFunction, endingPoints: endingPoints),
    );
  }
}
