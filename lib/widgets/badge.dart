import 'package:flutter/material.dart';

class Badge extends StatefulWidget {
  Badge({
    Key? key,
    required this.playerImageUrl,
    required this.playerRank,
    required this.color,
  }) : super(key: key);

  final String playerImageUrl;
  final int playerRank;
  final Color color;

  @override
  State<Badge> createState() => _BadgeState();
}

Widget assignRankImage(int index) {
  switch (index) {
    case 0:
      return Image.asset('assets/images/ranks/rank-first.png');
    case 1:
      return Image.asset('assets/images/ranks/rank-second.png');
    case 2:
      return Image.asset('assets/images/ranks/rank-third.png');
    default:
      return Image.asset('assets/images/ranks/rank-transparent.png');
  }
}

class _BadgeState extends State<Badge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: constraints.maxWidth * 0.2,
              child: Container(
                child: Image.asset(widget.playerImageUrl),
                width: constraints.maxWidth * 0.9,
                height: constraints.maxHeight * 0.9,
              ),
            ),
            Positioned(
              left: constraints.maxWidth - constraints.maxWidth * 0.5,
              top: constraints.maxHeight - constraints.maxHeight * 0.7,
              child: Container(
                width: constraints.maxWidth / 2,
                padding: EdgeInsets.all(2.0),
                // color: Theme.of(context).accentColor,

                child: assignRankImage(widget.playerRank),
              ),
            )
          ],
        ),
      ),
    );
  }
}
