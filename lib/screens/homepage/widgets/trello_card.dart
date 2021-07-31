import 'package:flutter/material.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/screens/homepage/views/home_page.dart';

class TrelloCard extends StatelessWidget {
  final TrelloCardModel model;
  const TrelloCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: trelloCardHeight,
      width: trelloCardWidth,
      child: Card(
        child: Text(model.title),
      ),
    );
  }
}
