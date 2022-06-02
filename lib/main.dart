import 'package:darts/widgets/play_current_turn.dart';
import 'package:darts/widgets/show_throw_darts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/players_list.dart';
import './widgets/new_player.dart';
import 'models/player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darts',
      theme: ThemeData(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
              titleTextStyle: ThemeData.light()
                  .textTheme
                  .copyWith(
                    headline6: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                  .headline6)),
      home: const MyHomePage(title: 'Darts'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _startingPoints = -301;
  int _endingPoints = 0;
  List<Player> _playersList = [];
  int _currentTurn = 0;

  void addPlayerToList(Player newPlayer) {
    _playersList.add(newPlayer);
    print(
        'Inserted player ${newPlayer.name} with turn ${newPlayer.playerTurn}');
    _rankPlayersByPoints();
    _printState();
  }
  
  _MyHomePageState() {
    _playersList.add(Player('1', 'Mario', -30, 0));
    _playersList.add(Player('2', 'Luigi', _startingPoints, 1));
  }

  void _showAddPlayer(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewPlayer(
                addPlayerFunction: addPlayerToList,
                playerTurn: _playersList.length,
                startingPoints: _startingPoints),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _printState() {
    print('_startingPoints: ${_startingPoints}');
    print('_endingPoints: ${_endingPoints}');
    print('_playersList: ${_playersList}');
    print('current turn: ${_currentTurn}');
  }

  void _incrementTurn() {
    setState(() {
      if (_playersList.isEmpty) {
        _currentTurn = 0;
      } else {
        _currentTurn = (_currentTurn + 1) % _playersList.length;
      }
    });
    print('current turn: ${_currentTurn}');
  }

  void _decreaseTurn() {
    setState(() {
      if (_playersList.isEmpty || _currentTurn == 0) {
        _currentTurn = 0;
      } else {
        _currentTurn = (_currentTurn - 1) % _playersList.length;
      }
    });
    print('current turn: ${_currentTurn}');
  }

  void _rankPlayersByPoints() {
    setState(() {
      _playersList.sort((a, b) => b.points.compareTo(a.points));
    });
  }

  void _setNewGame() {
    setState(() {
      _startingPoints = -301;
      _endingPoints = 0;
      _playersList = [];
      _currentTurn = 0;
    });
    _printState();
  }

  Future<void> _showEndGame() async {
    print('_showEndGame start');
    await Future.delayed(Duration(milliseconds: 500));
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Winner winner chicken dinner!'),
          content: Container(
            padding: EdgeInsets.all(10),
            //TODO - modify height
            height: MediaQuery.of(context).size.height/3,
            child: Column(
              children: [
                Text(_playersList[0].name),
                Image.asset(
                  "assets/images/darts-winner-image-1.gif",
                  height: 125.0,
                  width: 125.0,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('New Game'),
              onPressed: () {
                _setNewGame();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _checkEndGame(int index) {
    if (_playersList[index].points == _endingPoints) {
      print('Should END GAME');
      _showEndGame();
    }
  }

  void _addPoints(String playerId, int points) {
    final index = _playersList.indexWhere((element) => element.id == playerId);
    if (index >= 0) {
      _playersList[index].points += points;
      _rankPlayersByPoints();
      _incrementTurn();
      _checkEndGame(index);
    }
  }

  void _showThrowDarts(BuildContext ctx, Player player) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child:
                ShowThrowDarts(player: player, addPointsFunction: _addPoints, endingPoints: _endingPoints),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deletePlayer(String id) {
    final index = _playersList.indexWhere((element) => element.id == id);
    final playerToDeleteTurn = _playersList[index].playerTurn;
    if (index < 0) {
      return;
    }
    final Player playerToDelete = _playersList[index];
    _playersList.removeWhere((player) {
      return player.id == id;
    });

    for (Player player in _playersList) {
      print(
          'Before deleting ${playerToDelete.name},  Player: ${player.name} had turn: ${player.playerTurn}');
      if (player.playerTurn > playerToDeleteTurn) {
        player.playerTurn--;
      }
      print(
          'After deleting ${playerToDelete.name},  Player: ${player.name} has turn: ${player.playerTurn}');
    }
    _decreaseTurn();
    _rankPlayersByPoints();
  }

  @override
  Widget build(BuildContext context) {
    for (Player player in _playersList) {
      print('Player: ${player.name} has turn: ${player.playerTurn}');
    }
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {},
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: PlayCurrentTurn(
                    playersList: _playersList,
                    showThrowDartsFunction: _showThrowDarts,
                    currentTurn: _currentTurn,
                    incrementTurnFunction: _incrementTurn),
              ),
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.7,
                child: PlayersList(
                  playersList: _playersList,
                  showThrowDartsFunction: _showThrowDarts,
                  deletePlayerFunction: _deletePlayer,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Player'),
        icon: const Icon(Icons.add),
        onPressed: () => _showAddPlayer(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
