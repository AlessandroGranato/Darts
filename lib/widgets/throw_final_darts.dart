import 'package:flutter/material.dart';

import '../models/player.dart';

class ThrowFinalDarts extends StatefulWidget {
  final Player player;
  final Function addPointsFunction;
  final int endingPoints;
  const ThrowFinalDarts(
      {Key? key,
      required this.player,
      required this.addPointsFunction,
      required this.endingPoints})
      : super(key: key);

  @override
  State<ThrowFinalDarts> createState() =>
      _ThrowFinalDartsState(player, endingPoints);
}

class _ThrowFinalDartsState extends State<ThrowFinalDarts> {
  int _throwNumber = 1;
  int _endingPoints = 0;
  final TextEditingController _pointsController = TextEditingController();
  int _throwsCumulativePoints = 0;
  int _playerPointsBeforeThrows = 0;

  _ThrowFinalDartsState(Player player, int endingPoints) {
    _throwNumber = 1;
    _throwsCumulativePoints = 0;
    _endingPoints = endingPoints;
    _playerPointsBeforeThrows = player.points;
    _pointsController.clear();
  }

  bool get _canBeLastThrow {
    return (_endingPoints -
                _throwsCumulativePoints -
                _playerPointsBeforeThrows) %
            2 ==
        0;
  }

  int get _getMissingPoints {
    return _endingPoints - _throwsCumulativePoints - _playerPointsBeforeThrows;
  }

  int get _winningPoints {
    return _endingPoints - _playerPointsBeforeThrows;
  }

  void _instantVictory() {
    if (!_canBeLastThrow) {
      return;
    }
    widget.addPointsFunction(widget.player.id, _winningPoints);
    Navigator.of(context).pop();
  }

  void _nextThrow() {
    if (_throwNumber > 3) {
      widget.addPointsFunction(widget.player.id, _throwsCumulativePoints);
      Navigator.of(context).pop();
      return;
    }
  }

  void _checkThrow() {
    if (_pointsController.text.isEmpty) {
      return;
    }
    int points = int.parse(_pointsController.text);
    if (points > _getMissingPoints || (_getMissingPoints - points == 1)) {
      widget.addPointsFunction(widget.player.id, _throwsCumulativePoints);
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _throwNumber++;
      _throwsCumulativePoints += points;
      _pointsController.clear();
    });

    _nextThrow();
  }

  void _multiplyDartShot(
      TextEditingController textEditingController, int multiplier) {
    if (textEditingController.text.isEmpty) {
      return;
    }
    int points = multiplier * int.parse(textEditingController.text);
    setState(() {
      textEditingController.text = points.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Container(
        height: mediaQuery.size.height,
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
              child: Text('Final Throws, attempt n.${_throwNumber}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                      'To win, you must score ${_getMissingPoints} points'),
                ),
                Expanded(
                  child: Text(
                    _canBeLastThrow
                        ? 'by hitting DOUBLE ${_getMissingPoints / 2}'
                        : 'but you can\'t with this throw',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (_canBeLastThrow)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                        onPrimary: Theme.of(context).textTheme.button?.color),
                    onPressed: _instantVictory,
                    child: const Text('I WON!'),
                  ),
                Expanded(
                  child: Text('I scored'),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'points',
                    ),
                    controller: _pointsController,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) => _checkThrow(),
                  ),
                ),
                TextButton(
                  child: const Text('X2'),
                  onPressed: () => _multiplyDartShot(_pointsController, 2),
                ),
                TextButton(
                  child: const Text('X3'),
                  onPressed: () => _multiplyDartShot(_pointsController, 3),
                ),
                IconButton(
                  icon: Icon(Icons.check_box),
                  onPressed: _checkThrow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
