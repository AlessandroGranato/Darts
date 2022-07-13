class Player {
  final String id;
  final String name;
  int points;
  int playerTurn;
  String playerImageUrl;

  Player({required this.id, required this.name, required this.points, required this.playerTurn, this.playerImageUrl = 'assets/images/avatars/avatar_default.png'});

  
}