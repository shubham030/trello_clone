import 'package:flutter/material.dart';
import 'package:trello_clone/common/strings.dart';
import 'package:trello_clone/models/trello_card_model.dart';

showCardDialog(BuildContext context, TrelloCardModel model,
    ValueChanged<TrelloCardModel> onModelUpdate) {
  TextEditingController _controller = TextEditingController(
    text: model.description ?? '',
  );
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SizedBox(
          width: 600,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.title),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        model.title,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: Strings.addDescription,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text("Update"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (_controller.text.isNotEmpty) {
                        onModelUpdate(
                          model.copyWith(description: _controller.text),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );
    },
  );
}
