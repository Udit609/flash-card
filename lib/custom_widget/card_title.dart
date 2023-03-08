import 'package:flash_card/screens/f_cards.dart';
import 'package:flash_card/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTitle extends StatelessWidget {
  final textController = TextEditingController();
  static String cardTitle = '';
  final Function insertFunction;
  CardTitle({required this.insertFunction, Key? key}) : super(key: key);

  void isEmpty() {
    if (textController.text.isEmpty) {
      cardTitle = 'Title';
    } else {
      cardTitle = textController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      width: 300.0,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 0.0,
        color: Colors.white,
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
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 20,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: textController,
                textAlign: TextAlign.center,
                cursorColor: Colors.black,
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  hintText: 'Title of the card',
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
                  isEmpty();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FCards(insertFunction: insertFunction)));
                  textController.clear();
                },
                style: TextButton.styleFrom(
                  backgroundColor: secondaryColor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                child: const Text(
                  'Add Card',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
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
