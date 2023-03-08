import 'package:flash_card/db/quiz_model.dart';
import 'package:flash_card/screens/quiz_screens/question_page.dart';
import 'package:flash_card/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../../db/db_model.dart';

class AddQuestions extends StatefulWidget {
  const AddQuestions({
    Key? key,
    required this.quiz,
  }) : super(key: key);
  final QuizModel quiz;

  @override
  State<AddQuestions> createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  var db = DatabaseModel();

  bool isLoading = true;

  List<QuestionModel> questions = [];
  List<Widget> get activeWidgets =>
      questions.map((item) => questionList(item)).toList();

  final TextEditingController questionController = TextEditingController();
  final TextEditingController correctAnsController = TextEditingController();
  final TextEditingController wrongAns1Controller = TextEditingController();
  final TextEditingController wrongAns2Controller = TextEditingController();
  final TextEditingController wrongAns3Controller = TextEditingController();

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

  void addQuestion(List data, BuildContext context) {
    QuestionModel question = QuestionModel(
        questionId: widget.quiz.id,
        question: data[0],
        correctAns: data[1],
        wrongAns1: data[2],
        wrongAns2: data[3],
        wrongAns3: data[4]);
    db.insert(QuestionModel.table, question);
    widget.quiz.questionNo += 1;
    db.update(QuizModel.table, widget.quiz);
    fetchQuestions();
  }

  void deleteQuestion(QuestionModel model) async {
    db.delete(QuestionModel.table, model);
    widget.quiz.questionNo -= 1;
    db.update(QuizModel.table, widget.quiz);
    fetchQuestions();
  }

  void nameIsEmpty() {
    if (questionController.text.isEmpty) {
      questionController.text = 'Question';
    }
    if (correctAnsController.text.isEmpty) {
      correctAnsController.text = 'choice 1';
    }
    if (wrongAns1Controller.text.isEmpty) {
      wrongAns1Controller.text = 'choice 2';
    }
    if (wrongAns2Controller.text.isEmpty) {
      wrongAns2Controller.text = 'choice 3';
    }
    if (wrongAns3Controller.text.isEmpty) {
      wrongAns3Controller.text = 'choice 4';
    }
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (BuildContext buildContext,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          child: overlayAddQues(context),
                        ),
                      ],
                    );
                  },
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context)
                      .modalBarrierDismissLabel,
                  barrierColor: Colors.black.withOpacity(0.4),
                  transitionDuration: const Duration(milliseconds: 300),
                );
              },
              icon: Icon(
                Icons.add,
                size: 25.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return QuesPage(
              quiz: widget.quiz,
            );
          }));
        },
        backgroundColor: secondaryColor,
        child: const Icon(Icons.play_arrow, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: secondaryColor,
            ))
          : questions.isEmpty
              ? const Center(
                  child: Text(
                    'Add Questions',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListView(
                    children: activeWidgets,
                  ),
                ),
    );
  }

  Widget questionList(QuestionModel model) {
    return Dismissible(
      key: Key(model.id.toString()),
      child: Container(
        height: 70.0,
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          gradient: LinearGradient(
              colors: [Colors.blue.shade500, Colors.blue.shade200]),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            model.question,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        deleteDialog(context, model);
        return null;
      },
    );
  }

  Container overlayAddQues(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          formField(questionController, 'Question'),
          const SizedBox(
            height: 10.0,
          ),
          formField(correctAnsController, 'Correct Answer'),
          const SizedBox(
            height: 10.0,
          ),
          formField(wrongAns1Controller, 'Wrong Answer 1'),
          const SizedBox(
            height: 10.0,
          ),
          formField(wrongAns2Controller, 'Wrong Answer 2'),
          const SizedBox(
            height: 10.0,
          ),
          formField(wrongAns3Controller, 'Wrong Answer 3'),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  nameIsEmpty();
                  List data = ["", "", "", "", ""];
                  data[0] = questionController.text;
                  data[1] = correctAnsController.text;
                  data[2] = wrongAns1Controller.text;
                  data[3] = wrongAns2Controller.text;
                  data[4] = wrongAns3Controller.text;
                  addQuestion(data, context);
                  Navigator.pop(context);
                  clearTextController();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  void clearTextController() {
    questionController.clear();
    correctAnsController.clear();
    wrongAns1Controller.clear();
    wrongAns2Controller.clear();
    wrongAns3Controller.clear();
  }

  Widget formField(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 1,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 8.0),
        hintText: hintText,
        hintStyle: kTextFormTStyle,
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0)),
        enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black.withOpacity(0.2), width: 1.0)),
      ),
      cursorColor: Colors.black,
      cursorHeight: 20.0,
    );
  }

  void deleteDialog(BuildContext context, QuestionModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: (Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                          "Are you sure you wish to delete this question?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              deleteQuestion(model);
                              Navigator.of(context).pop(true);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
          );
        });
  }
}
