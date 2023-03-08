import 'package:flash_card/custom_widget/mini_card.dart';
import 'package:flutter/material.dart';
import '../db/db_model.dart';

class FutureBuild extends StatelessWidget {
  FutureBuild(
      {required this.insertFunction,
      required this.deleteFunction,
      required this.future,
      Key? key})
      : super(key: key);
  final Function insertFunction;
  final Function deleteFunction;
  final Future<List<dynamic>>? future;
  final db = DatabaseModel();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return FutureBuilder(
      future: future,
      initialData: const [],
      builder: (_, AsyncSnapshot<List> snapshot) {
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Add a card',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
            ),
          );
        } else {
          return GridView.builder(
            itemCount: snapshot.data!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                childAspectRatio: 0.75),
            itemBuilder: (context, index) => MiniCard(
              id: snapshot.data![index].id,
              color: snapshot.data![index].color,
              title: snapshot.data![index].title,
              body: snapshot.data![index].body,
              isFavorite: snapshot.data![index].isFavorite,
              charLength: snapshot.data![index].charLength,
              creationDate: snapshot.data![index].creationDate,
              insertFunction: insertFunction,
              deleteFunction: deleteFunction,
            ),
          );
        }
      },
    );
  }
}
