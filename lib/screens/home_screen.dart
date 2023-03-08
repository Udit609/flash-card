import 'package:flash_card/custom_widget/card_title.dart';
import 'package:flash_card/custom_widget/future_builder.dart';
import 'package:flash_card/db/db_model.dart';
import 'package:flash_card/db/f_card_model.dart';
import 'package:flash_card/screens/favourite_page.dart';
import 'package:flash_card/main.dart';
import 'package:flash_card/utilities/constants.dart';
import 'package:flash_card/screens/quiz_screens/quiz_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db = DatabaseModel();

  @override
  void initState() {
    FutureBuild(
      future: db.getCard(),
      insertFunction: addItem,
      deleteFunction: deleteItem,
    );
    super.initState();
  }

  void addItem(FlashCard flashCard) async {
    await db.insertCard(flashCard);
    setState(() {});
  }

  void deleteItem(FlashCard flashCard) async {
    await db.deleteCard(flashCard);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: kAppBarTStyle),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white.withOpacity(0.95),
        ),
        child: Theme(
          data: Theme.of(context),
          child: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/FlashCardDrawer.png"))),
                  child: Text(
                    'Flashcards',
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.home,
                            size: 25,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        TextSpan(
                            text: " Home",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const HomePage();
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.quiz_rounded,
                            size: 25,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        TextSpan(
                            text: " Quiz",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const QuizPage();
                      }),
                    );
                  },
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.favorite,
                            size: 25.0,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        TextSpan(
                            text: " Favorites",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const FavouritePage();
                      }),
                    );
                  },
                ),
                const SizedBox(
                  height: 20.0,
                  width: 180.0,
                  child: Divider(
                    indent: 10.0,
                    endIndent: 10.0,
                    thickness: 1.50,
                    color: Color(0xFF9C99B2),
                  ),
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.dark_mode,
                            size: 25,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        TextSpan(
                            text: ' DarkMode',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ],
                    ),
                  ),
                  onTap: () => MyApp.of(context).changeTheme(ThemeMode.dark),
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.light_mode,
                            size: 25,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        TextSpan(
                            text: ' LightMode',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ],
                    ),
                  ),
                  onTap: () => MyApp.of(context).changeTheme(ThemeMode.light),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(secondary: Color(0xFF1A99EE)),
        ),
        child: FloatingActionButton(
          onPressed: () {
            showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext buildContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: <Widget>[
                    CardTitle(
                      insertFunction: addItem,
                    ),
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
          child: const Icon(
            Icons.add,
            size: 30.0,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuild(
        future: db.getCard(),
        insertFunction: addItem,
        deleteFunction: deleteItem,
      ),
    );
  }
}
