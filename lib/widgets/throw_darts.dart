import 'package:flutter/material.dart';

class ThrowDarts extends StatefulWidget {

  final String playerId;
  final Function addPointsFunction;
  const ThrowDarts({ Key? key, required this.playerId, required this.addPointsFunction }) : super(key: key);

  @override
  State<ThrowDarts> createState() => _ThrowDartsState();
}

class _ThrowDartsState extends State<ThrowDarts> {
  final TextEditingController _pointsController1 = TextEditingController();
  final TextEditingController _pointsController2 = TextEditingController();
  final TextEditingController _pointsController3 = TextEditingController();

  void _submitData() {
    if (_pointsController1.text.isEmpty && _pointsController2.text.isEmpty && _pointsController3.text.isEmpty) {
      return;
    }
    if (_pointsController1.text.isEmpty) {
      _pointsController1.text = '0';
    }
    if (_pointsController2.text.isEmpty) {
      _pointsController2.text = '0';
    }
    if (_pointsController3.text.isEmpty) {
      _pointsController3.text = '0';
    }

    int points = int.parse(_pointsController1.text) + int.parse(_pointsController2.text) + int.parse(_pointsController3.text);
    widget.addPointsFunction(widget.playerId, points);
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: mediaQuery.viewInsets.bottom + 10,
        ),
        child: Container(
          height: mediaQuery.size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text("Add throw result", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Darts points',
                ),
                controller: _pointsController1,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {},
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Darts points',
                ),
                controller: _pointsController2,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {},
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Darts points',
                ),
                controller: _pointsController3,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {},
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary,
                    onPrimary: Theme.of(context).textTheme.button?.color),
                onPressed: _submitData,
                child: const Text('insert points'),
              ),              
            ],
          ),
        ),
      ),
    );
  }
}