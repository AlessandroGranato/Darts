import 'package:darts/widgets/play_current_turn.dart';
import 'package:darts/widgets/throw_darts.dart';
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
  final List<Player> _playersList = [
    Player('1', 'player1', 10, 1),
    Player('2', 'Player2', 20, 2)
  ];

  int _currentTurn = 0;

  void addPlayerToList(Player newPlayer) {
    _playersList.add(newPlayer);
    print(
        'Inserted player ${newPlayer.name} with turn ${newPlayer.playerTurn}');
    _rankPlayersByPoints();
  }

  void _showAddPlayer(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewPlayer(
                addPlayerFunction: addPlayerToList,
                playerTurn: _playersList.length + 1),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _incrementTurn() {
    setState(() {
      if (_playersList.isEmpty) {
        _currentTurn = 0;
      } else {
        _currentTurn = (_currentTurn + 1) % _playersList.length;
      }
    });
    print('current turn: ${_currentTurn}' );
  }

    void _decreaseTurn() {
    setState(() {
      if (_playersList.isEmpty) {
        _currentTurn = 0;
      } else {
        _currentTurn = (_currentTurn - 1) % _playersList.length;
      }
    });
    print('current turn: ${_currentTurn}' );
  }

  void _rankPlayersByPoints() {
    setState(() {
      _playersList.sort((a, b) => b.points.compareTo(a.points));
    });
  }

  void _addPoints(String playerId, int points) {
    final index = _playersList.indexWhere((element) => element.id == playerId);
    if (index >= 0) {
      _playersList[index].points += points;
      _rankPlayersByPoints();
      _incrementTurn();
    }
  }

  void _showThrowDarts(BuildContext ctx, String playerId) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child:
                ThrowDarts(playerId: playerId, addPointsFunction: _addPoints),
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
