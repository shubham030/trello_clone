import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat.yMMMEd().format(model.date),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
