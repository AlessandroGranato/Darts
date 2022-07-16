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

    print('points :${points}');
    print('cumulativePoints :${_throwsCumulativePoints}');
    print('missingPoints :${_getMissingPoints}');

    if (points > _getMissingPoints || (_getMissingPoints - points == 1)) {
      widget.addPointsFunction(widget.player.id, _throwsCumulativePoints);
      Navigator.of(context).pop();
      return;
    }
    if (points == _getMissingPoints) {
      _instantVictory();
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text('Final Throws!'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                      fontFamily: 'OpenSans')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Attempt '.toUpperCase(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans')),
                Text(
                  '#${_throwNumber}',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans'),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _canBeLastThrow
                    ? SizedBox(width: MediaQuery.of(context).size.width * 0.15)
                    : SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                Image.asset(
                  'assets/images/hint.png',
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: _canBeLastThrow
                          ? Text(
                              'You could win by scoring:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontFamily: 'OpenSans'),
                            )
                          : Text(
                              '${_getMissingPoints}pts left',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans'),
                            ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: _canBeLastThrow
                          ? [
                              Text(
                                '${_getMissingPoints}pts',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              Text(' with ',
                                  style: TextStyle(
                                      fontSize: 15, fontFamily: 'OpenSans')),
                              Text(
                                '${(_getMissingPoints / 2).toInt()}x2',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ]
                          : [
                              Text(
                                'You can\'t win with this throw.',
                                style: TextStyle(
                                    fontSize: 15, fontFamily: 'OpenSans'),
                              ),
                            ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            _canBeLastThrow
                ? SizedBox(
                    height: 0,
                  )
                : Text(
                    '*Last Throw must be a double',
                    style: TextStyle(fontSize: 12, fontFamily: 'OpenSans'),
                  ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Insert Score',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
height: MediaQuery.of(context).size.height * 0.08,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            labelText: 'Points',
                            fillColor: Colors.grey.shade200),
                        style: TextStyle(
                            fontSize: 10.0, height: 1, color: Colors.black),
                        controller: _pointsController,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) => _checkThrow(),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(223, 229, 17, 1),
                          onPrimary: Colors.black,
                          shape: const RoundedRectangleBorder(
                            
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        onPressed: () =>
                            _multiplyDartShot(_pointsController, 2),
                        child: Text(
                          'x2',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(223, 229, 17, 1),
                          onPrimary: Colors.black,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        onPressed: () =>
                            _multiplyDartShot(_pointsController, 3),
                        child: Text(
                          'x3',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(223, 229, 17, 1),
                            onPrimary: Colors.black,
                            fixedSize: Size(10, 10),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          onPressed:
                              _checkThrow, //onPressed is empty because its child is an icon with onPressed. I could have also added _checkThrow here tho.
                          child: GestureDetector(
                            child: Image.asset(
                              'assets/images/check.png',
                              width: 15,
                            ),
                            onTap: _checkThrow,
                          )

                          //child: Text('yoasda'),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            if (_canBeLastThrow)
              Text(
                'or',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            if (_canBeLastThrow)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(223, 229, 17, 1),
                  onPrimary: Colors.black,
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: 20),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
                onPressed: _instantVictory,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('I WON!'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
