import 'package:flash_card/db/db_model.dart';
import 'package:flash_card/db/f_card_model.dart';
import 'package:flash_card/screens/edit_card.dart';
import 'package:flash_card/screens/home_screen.dart';
import 'package:flash_card/utilities/constants.dart';
import 'package:flutter/material.dart';

class BodyCard extends StatefulWidget {
  final int cardId;
  final Function deleteFunction;
  const BodyCard({
    Key? key,
    required this.cardId,
    required this.deleteFunction,
  }) : super(key: key);

  @override
  State<BodyCard> createState() => _BodyCardState();
}

class _BodyCardState extends State<BodyCard> {
  FlashCard flashCard = FlashCard(
    title: '',
    body: '',
    color: 0,
    charLength: 0,
    creationDate: DateTime.now(),
    isFavorite: false,
  );
  var db = DatabaseModel();

  @override
  void initState() {
    showCard();
    super.initState();
  }

  void showCard() async {
    flashCard = await db.readCard(widget.cardId);
    setState(() {});
  }

  void deleteItem(FlashCard fCardModel) async {
    await db.deleteCard(fCardModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: Color(flashCard.color),
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(flashCard.color),
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: MediaQuery.of(context).size.height / 1.5,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 15.0, top: 15.0, bottom: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        flashCard.title,
                        style: kMiniCardTStyle,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCard(
                                      flashCard: flashCard,
                                    ),
                                  ));
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          InkWell(
                            onTap: () {
                              widget.deleteFunction(flashCard);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                  (route) => false);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  SelectableText(
                    flashCard.body,
                    style: const TextStyle(fontSize: 22.0, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
