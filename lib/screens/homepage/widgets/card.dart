import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/screens/homepage/models/target_data_model.dart';

class TrelloCard extends StatelessWidget {
  final VoidCallback onDrageStarted;
  final ValueChanged<DragUpdateDetails> onDragUpdate;
  final ValueChanged onDragEnded;
  final ValueChanged<Offset> onEnter;

  final TrelloCardModel model;
  final int index;
  const TrelloCard({
    Key? key,
    required this.onEnter,
    required this.index,
    required this.onDrageStarted,
    required this.onDragUpdate,
    required this.onDragEnded,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        final box = context.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero);
        onEnter(pos);
      },
      child: Draggable<TargetDataModel<TrelloCardModel>>(
        data: TargetDataModel<TrelloCardModel>(data: model, fromList: index),
        child: Card(
          child: Text(model.title),
        ),
        feedback: Container(
          color: Colors.deepOrange,
          height: 40,
          width: 300,
          child: const Icon(Icons.directions_run),
        ),
        childWhenDragging: Container(
          height: 40.0,
          width: 300.0,
          color: Colors.pinkAccent,
          child: const Center(
            child: Text('Child When Dragging'),
          ),
        ),
        onDragStarted: onDrageStarted,
        onDragEnd: onDragEnded,
        onDragUpdate: onDragUpdate,
      ),
    );
    // Container(height: 40, child: Card(child: Text(text))),
  }
}
