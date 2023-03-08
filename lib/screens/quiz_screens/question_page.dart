import 'package:flash_card/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../../db/db_model.dart';
import '../../db/quiz_model.dart';

class QuesPage extends StatefulWidget {
  final QuizModel quiz;
  const QuesPage({
    required this.quiz,
    Key? key,
  }) : super(key: key);

  @override
  State<QuesPage> createState() => _QuesPageState();
}

class _QuesPageState extends State<QuesPage> {
  var db = DatabaseModel();
  bool isLoading = true;
  bool buildAns = false;
  int index = 0;
  int score = 0;

  List<QuestionModel> questions = [];
  List<Widget> get questionsList =>
      questions.map((item) => viewQuestions(item)).toList();
  List<Widget> get answersList =>
      questions.map((item) => showAnswers(item)).toList();

  @override
  void initState() {
    fetchQuestions();
    super.initState();
  }

  void fetchQuestions() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> results =
        await db.queryQuestions(QuestionModel.table, widget.quiz);
    questions = results.map((quiz) => QuestionModel.fromMap(quiz)).toList();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        centerTitle: true,
        title: Text(
          widget.quiz.categoryName,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? const CircularProgressIndicator(
              color: secondaryColor,
            )
          : questionsList.isEmpty
              ? const Center(
                  child: Text(
                    'No Questions!',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                )
              : body(),
    );
  }

  Widget body() {
    if (questionsList.length == index) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'You got a score of $score / $index !',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 50.0,
            ),
            if (buildAns == true) ...[
              ListView(
                shrinkWrap: true,
                children: answersList,
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    buildAns = true;
                  });
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
                    foregroundColor: Colors.white),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.question_answer),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text('Show Answers'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return questionsList[index];
    }
  }

  Container viewQuestions(QuestionModel model) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              model.question,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Column(children: answerButtons(model)),
        ],
      ),
    );
  }

  Widget answerButton(String answerText, bool isCorrect) {
    void action() {
      if (isCorrect) {
        setState(() {
          index += 1;
          score += 1;
        });
      } else {
        setState(() {
          index += 1;
        });
      }
    }

    return GestureDetector(
      onTap: () {
        action();
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
              colors: [Colors.blue.shade500, Colors.blue.shade200]),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answerText,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> answerButtons(QuestionModel model) {
    List<Widget> buttons = [];
    buttons.add(answerButton(model.correctAns, true));
    buttons.add(answerButton(model.wrongAns1, false));
    buttons.add(answerButton(model.wrongAns2, false));
    buttons.add(answerButton(model.wrongAns3, false));
    buttons.shuffle();
    return buttons;
  }

  Widget showAnswers(QuestionModel model) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.blue.shade200]),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Q. ',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    model.question,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A. ',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    model.correctAns,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
