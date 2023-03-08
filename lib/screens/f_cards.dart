import 'package:flash_card/custom_widget/card_title.dart';
import 'package:flash_card/db/f_card_model.dart';
import 'package:flash_card/utilities/constants.dart';
import 'package:flash_card/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';

class FCards extends StatefulWidget {
  final Function insertFunction;
  const FCards({required this.insertFunction, Key? key}) : super(key: key);

  @override
  State<FCards> createState() => _FCardsState();
}

class _FCardsState extends State<FCards> {
  TextEditingController bodyController = TextEditingController();
  Color selectedColor = const Color(0xFFE75466);
  int charLength = 0;

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.color_lens_outlined,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ColorPicker(
                              pickerColor:
                                  const Color(0xFFE75466), //default color
                              onColorChanged: (Color color) {
                                //on color picked
                                selectedColor = color;
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 8),
                                  child: Text("Done"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
          IconButton(
            onPressed: () {
              var myCard = FlashCard(
                title: CardTitle.cardTitle,
                body: bodyController.text,
                color: selectedColor.value,
                isFavorite: false,
                charLength: charLength,
                creationDate: DateTime.now(),
              );
              widget.insertFunction(myCard);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
            },
            icon: Icon(
              Icons.check,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ],
      ),
      // bottomNavigationBar: const BottomBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CardTitle.cardTitle,
                style: kAppBarTStyle.copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Text(
                    DateFormat('dd MMM, yyyy  HH:mm  |  ')
                        .format(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$charLength characters',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: kBodyTStyle,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your text here',
                  hintStyle: kBodyTStyle,
                ),
                cursorColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                onChanged: _onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
