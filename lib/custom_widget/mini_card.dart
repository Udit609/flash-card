import 'package:flash_card/custom_widget/body_card.dart';
import 'package:flash_card/db/f_card_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utilities/constants.dart';

class MiniCard extends StatefulWidget {
  MiniCard(
      {super.key,
      required this.id,
      required this.color,
      required this.title,
      required this.body,
      required this.isFavorite,
      required this.charLength,
      required this.creationDate,
      required this.insertFunction,
      required this.deleteFunction});

  final int? id;
  final int color;
  final String title;
  final String body;
  bool isFavorite;
  final int charLength;
  final DateTime creationDate;
  final Function insertFunction;
  final Function deleteFunction;

  @override
  State<MiniCard> createState() => _MiniCardState();
}

class _MiniCardState extends State<MiniCard> {
  bool isFavorited = false;
  int favCount = 0;

  void _toggleFavorite() {
    setState(() {
      if (widget.isFavorite) {
        favCount -= 1;
        widget.isFavorite = false;
      } else {
        favCount += 1;
        widget.isFavorite = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var anotherCard = FlashCard(
      id: widget.id,
      title: widget.title,
      body: widget.body,
      color: widget.color,
      isFavorite: widget.isFavorite,
      charLength: widget.charLength,
      creationDate: widget.creationDate,
    );

    // var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        widget.insertFunction(anotherCard);
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: <Widget>[
                BodyCard(
                  cardId: widget.id!,
                  deleteFunction: widget.deleteFunction,
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
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Color(widget.color),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  _toggleFavorite();
                  anotherCard.isFavorite = widget.isFavorite;
                  widget.insertFunction(anotherCard);
                },
                icon: widget.isFavorite
                    ? const Icon(Icons.favorite_outlined)
                    : const Icon(Icons.favorite_border),
                color: widget.isFavorite ? Colors.white : Colors.white,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: kMiniCardTStyle,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('dd MMM, yy').format(widget.creationDate),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
