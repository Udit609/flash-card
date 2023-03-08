import 'package:flash_card/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../custom_widget/future_builder.dart';
import '../db/db_model.dart';
import '../db/f_card_model.dart';
import '../utilities/constants.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  var db = DatabaseModel();

  void addItem(FlashCard fCardModel) async {
    await db.insertCard(fCardModel);
    setState(() {});
  }

  void deleteItem(FlashCard fCardModel) async {
    await db.deleteCard(fCardModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const HomePage();
            }));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Favourites',
          style: kAppBarTStyle,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: FutureBuild(
          future: db.getFavCard(),
          insertFunction: addItem,
          deleteFunction: deleteItem,
        ),
      ),
    );
  }
}
