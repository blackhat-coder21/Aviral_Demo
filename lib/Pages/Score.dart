import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Components/CourseCard.dart';
import '../Utils/Api.dart';

class Score extends StatefulWidget {
  final String jwtToken;
  final String sessionId;

  const Score({
    Key? key,
    required this.jwtToken,
    required this.sessionId,
  }) : super(key: key);

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  List<dynamic>? scores;

  @override
  void initState() {
    super.initState();
    _setUserScore();
  }

  Future<void> _setUserScore() async {
    final res = await getScore(widget.jwtToken, widget.sessionId);
    setState(() {
      scores = res!.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (scores == null) {
      return Scaffold(
        body: Center(
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 50.0,
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: scores?.length ?? 0,
          itemBuilder: (context, index) {
            return CourseCard(data: scores![index]);
          },
        ),
      ),
    );
  }
}
