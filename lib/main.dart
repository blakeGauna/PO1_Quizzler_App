////////////////////////////////////////////////
//           Blake Gauna
//           4443-Mobile-Apps
//           PO4
//           This program grabs questions from
//           the local api and displays them
//           in a true or false test fashion.
//
////////////////////////////////////////////////
import 'package:flutter/material.dart';
//TODO: Step 2 - Import the rFlutter_Alert package here.
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';

//Making an object of type question
Question question = Question();


void main() async {
  runApp(Quizzler());
}

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
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
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>{
  //Making the right/wrong counter
  List<Icon> scoreKeeper = [];
  //Initializing the currentQuestion to empty
  String currentQuestion = '';


  void setQuestion() async {
    //Gets the question text and make String que = to it.
    String que = await question.getQuestionText();
    setState((){
      currentQuestion = que;
    });
  }


  void checkAnswer(int userPickedAnswer) async {
    //Grabbing both the answer and whether or not it is finished
    bool isFinished = await question.isFinished();
    int correctAnswer = await question.getQuestionAnswer();

    setState(() {


      //TODO: Step 4 - Use IF/ELSE to check if we've reached the end of the quiz. If so,
      //On the next line, you can also use if (quizBrain.isFinished()) {}, it does the same thing.
      if (isFinished) {
        //TODO Step 4 Part A - show an alert using rFlutter_alert,

        //This is the code for the basic alert from the docs for rFlutter Alert:
        //Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();

        //Modified for our purposes:
        if(userPickedAnswer == correctAnswer){
          scoreKeeper.add(const Icon(
            Icons.check,
            color: Colors.green,
          ));
        }
        else{
          scoreKeeper.add(const Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        Alert(
          context: context,
          title: 'Finished!',
          desc: 'You\'ve reached the end of the quiz.',
        ).show();

        //Resets the api,
        question.reset();

        //Empties the scorekeeper.
        scoreKeeper = [];
      }

      //TODO: Step 6 - If we've not reached the end, ELSE do the answer checking steps below 👇
      else {   //Comparing the userPickerAnswer vs. correctAnswer
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(const Icon(
            Icons.check,
            color: Colors.green,
          ));
        } else {
          scoreKeeper.add(const Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        //Gets the next question from the api
        question.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setQuestion();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                currentQuestion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              child: Text("True"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(1);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              child: Text("False"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(0);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
