import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/screens/homepage/models/target_data_model.dart';
import 'package:trello_clone/screens/homepage/widgets/show_card_dialog.dart';
import 'package:trello_clone/screens/homepage/widgets/trello_card.dart';

class TrelloCardHolder extends StatelessWidget {
  final VoidCallback onDrageStarted;
  final ValueChanged<DragUpdateDetails> onDragUpdate;
  final ValueChanged onDragEnded;
  final ValueChanged<Offset> onEnter;

  final TrelloCardModel model;
  final String parentListId;
  const TrelloCardHolder({
    Key? key,
    required this.onEnter,
    required this.onDrageStarted,
    required this.onDragUpdate,
    required this.onDragEnded,
    required this.model,
    required this.parentListId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        final box = context.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero);
        onEnter(pos);
      },
      child: InkWell(
        onTap: () {
          showCardDialog(context, model);
        },
        child: Draggable<TargetDataModel<TrelloCardModel>>(
          data: TargetDataModel<TrelloCardModel>(
              data: model, fromList: parentListId),
          child: TrelloCard(model: model),
          feedback: TrelloCard(model: model),
          childWhenDragging: Container(),
          onDragStarted: onDrageStarted,
          onDragEnd: onDragEnded,
          onDragUpdate: onDragUpdate,
        ),
      ),
    );
  }
}
