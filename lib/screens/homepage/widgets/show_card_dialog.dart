import 'package:flutter/material.dart';
import 'package:trello_clone/models/trello_card_model.dart';

showCardDialog(BuildContext context, TrelloCardModel model) {
  showDialog(
    context: context,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.title),
                  Text(
                    model.title,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
