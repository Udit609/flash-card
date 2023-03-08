import 'package:flash_card/db/f_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import '../db/db_model.dart';
import '../utilities/constants.dart';
import 'home_screen.dart';

class EditCard extends StatefulWidget {
  final FlashCard flashCard;
  const EditCard({
    Key? key,
    required this.flashCard,
  }) : super(key: key);

  @override
  State<EditCard> createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  late final TextEditingController bodyController;
  late final TextEditingController titleController;
  Color selectedColor = const Color(0xFFFFFFFF);

  var db = DatabaseModel();

  void updateItem(FlashCard flashCard) async {
    await db.updateCard(flashCard);
    setState(() {});
  }

  int charLength = 0;

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
    });
  }

  @override
  void initState() {
    titleController = TextEditingController(text: widget.flashCard.title);
    bodyController = TextEditingController(text: widget.flashCard.body);
    selectedColor = Color(widget.flashCard.color);
    charLength = widget.flashCard.charLength;
    super.initState();
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
                                  Color(widget.flashCard.color), //default color
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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false);
              var myCard = FlashCard(
                id: widget.flashCard.id,
                title: titleController.text,
                body: bodyController.text,
                color: selectedColor.value,
                isFavorite: widget.flashCard.isFavorite,
                charLength: charLength,
                creationDate: DateTime.now(),
              );

              updateItem(myCard);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                autofocus: false,
                textCapitalization: TextCapitalization.sentences,
                controller: titleController,
                style: kAppBarTStyle.copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                maxLength: 20,
                cursorColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counter: SizedBox.shrink(),
                ),
              ),
              Row(
                children: [
                  Text(
                    DateFormat('dd MMM, yyyy  HH:mm  |  ')
                        .format(widget.flashCard.creationDate),
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
                autofocus: false,
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
