import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzer/question.dart';

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> _icon = [];
  QuizBrain ques = QuizBrain();
  int score = 0;
  String button1 = " True ";
  String button2 = " False ";

  void checkAns(bool ans) {
    setState(() {
      if (ques.getQuestionText().startsWith("Game Ended")) {
        ques.setQuestion("Game Ended \nYour Score is $score");
        button1 = " Restart ";
        button2 = " Exit ";
      } else {
        if (ques.getCorrectAnswer() == ans) {
          _icon.add(const Icon(
            Icons.check,
            color: Colors.green,
          ));
          score++;
        } else {
          _icon.add(const Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        ques.nextQuestion();
        if (ques.getQuestionText().startsWith("Game Ended")) {
          ques.setQuestion("Game Ended \nYour Score is $score");
          button1 = " Restart ";
          button2 = " Exit ";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                ques.getQuestionText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                button1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                if (button1 == " True ") {
                  checkAns(true);
                } else {
                  setState(() {
                    _icon = [];
                    score = 0;
                    ques = QuizBrain();
                    button1 = " True ";
                    button2 = " False ";
                  });
                }
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                button2,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (button2 == " False ") {
                  checkAns(false);
                } else {
                  SystemNavigator.pop();
                }
              },
            ),
          ),
        ),
        Row(
          children: _icon,
        ),
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
