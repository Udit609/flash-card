import 'package:flash_card/db/db_model.dart';
import 'package:flash_card/db/quiz_model.dart';
import 'package:flash_card/screens/quiz_screens/add_questions.dart';
import 'package:flash_card/utilities/constants.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String categoryName = 'Quiz category';
  var db = DatabaseModel();
  bool isLoading = true;
  bool validate = false;
  final TextEditingController categoryController = TextEditingController();
  List<QuizModel> quizzes = [];
  List<Widget> get activeWidgets =>
      quizzes.map((item) => quizButton(item)).toList();

  @override
  void initState() {
    fetchQuiz();
    super.initState();
  }

  void fetchQuiz() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> results = await db.queryQuiz(QuizModel.table);
    quizzes = results.map((quiz) => QuizModel.fromMap(quiz)).toList();
    setState(() {
      isLoading = false;
    });
  }

  void addQuiz(String categoryName, BuildContext context) async {
    QuizModel q = QuizModel(categoryName: categoryName, questionNo: 0);
    db.insert(QuizModel.table, q);
    fetchQuiz();
  }

  void deleteQuiz(QuizModel item) async {
    db.delete(QuizModel.table, item);
    fetchQuiz();
  }

  void nameIsEmpty() {
    if (categoryController.text.isNotEmpty) {
      categoryName = categoryController.text;
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
          'Quizzes',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : const Color(0xFF455A64),
                    child: overlayContainer(context),
                  )
                ],
              );
            },
            barrierDismissible: true,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Colors.black.withOpacity(0.4),
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
        label: const Text('Add Category'),
        icon: const Icon(Icons.add),
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: secondaryColor,
            ))
          : quizzes.isEmpty
              ? const Center(
                  child: Text(
                    'Add Category',
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

  Widget quizButton(QuizModel model) {
    return Dismissible(
      key: Key(model.id.toString()),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddQuestions(
                        quiz: model,
                      )));
        },
        child: Container(
          height: 80.0,
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                  colors: [Colors.blue.shade500, Colors.blue.shade200]),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
              ]),
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${model.questionNo} Questions',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        deleteDialog(context, model);
        return null;
      },
    );
  }

  Container overlayContainer(BuildContext context) {
    return Container(
      width: 300.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextField(
              controller: categoryController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 16.0, color: Colors.black),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                hintText: 'Enter Category Name',
                hintStyle: kTextFormTStyle,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextButton(
              onPressed: () {
                nameIsEmpty();
                addQuiz(categoryName, context);
                Navigator.pop(context);
                categoryController.clear();
              },
              style: TextButton.styleFrom(
                backgroundColor: secondaryColor,
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: const Text(
                'Add Category',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteDialog(BuildContext context, QuizModel model) {
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
                          "Are you sure you wish to delete this item?",
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
                              deleteQuiz(model);
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
