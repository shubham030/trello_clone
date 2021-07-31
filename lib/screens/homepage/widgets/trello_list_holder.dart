import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/screens/homepage/bloc/drag_updates.dart';
import 'package:trello_clone/screens/homepage/bloc/home_page_bloc.dart';
import 'package:trello_clone/screens/homepage/models/drag_update_details_model.dart';
import 'package:trello_clone/screens/homepage/models/target_data_model.dart';
import 'package:trello_clone/screens/homepage/views/home_page.dart';
import 'package:trello_clone/screens/homepage/widgets/card.dart';

class TrelloListHolder extends StatefulWidget {
  final String listTitle;
  final int listIndex;
  final VoidCallback onAddCardPressed;
  final ValueChanged onDataAdded;
  final VoidCallback onCanceled;
  final List<TrelloCardModel> items;
  const TrelloListHolder({
    Key? key,
    required this.listTitle,
    required this.onAddCardPressed,
    required this.onDataAdded,
    required this.onCanceled,
    required this.items,
    required this.listIndex,
  }) : super(key: key);

  @override
  _TrelloListHolderState createState() => _TrelloListHolderState();
}

class _TrelloListHolderState extends State<TrelloListHolder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: trelloCardWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.listTitle,
          ),
          Builder(
            builder: (context) {
              double screenHeight = MediaQuery.of(context).size.height;
              double itemHeight = (widget.items.length - 1) * trelloCardHeight;
              if (itemHeight > screenHeight) {
                return Expanded(
                  child: buildListView(widget.items),
                );
              } else {
                return SizedBox(
                  height: itemHeight,
                  child: buildListView(widget.items),
                );
              }
            },
          ),
          TextButton.icon(
              onPressed: () {}, label: Text('Add'), icon: Icon(Icons.add)),
        ],
      ),
    );
  }

  Widget buildListView(List<TrelloCardModel> items) {
    return StreamBuilder<DragUpdateDetailsModel>(
        initialData: DragUpdateDetailsModel(
            itemIndex: null, listIndex: null, offset: null),
        stream: Provider.of<DragUpdatesBloc>(context).dragUpdateDetails,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final dragUpdateBloc = Provider.of<DragUpdatesBloc>(
                context,
                listen: false,
              );
              var child = Container(
                height: trelloCardHeight,
                child: TrelloCard(
                  model: items[index],
                  index: widget.listIndex,
                  onDrageStarted: () {},
                  onDragUpdate: (details) {
                    dragUpdateBloc.onDragUpdate(details.globalPosition);
                  },
                  onDragEnded: (details) {
                    Provider.of<DragUpdatesBloc>(context, listen: false)
                        .clearData;
                  },
                  onEnter: (Offset global) {
                    if (snapshot.data?.offset != null) {
                      var _offset = snapshot.data!.offset;
                      var diffX = (global.dx - _offset!.dx).abs();
                      if (diffX < 320) {
                        dragUpdateBloc.onHoveredIndexUpdate(index);
                        dragUpdateBloc.onHoveredListUpdate(widget.listIndex);
                      }
                    }
                  },
                ),
              );

              if (index == snapshot.data?.itemIndex &&
                  snapshot.data?.listIndex == widget.listIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [_buildDragTarget(snapshot.data?.itemIndex), child],
                );
              } else {
                return child;
              }
            },
          );
        });
  }

  Widget _buildDragTarget(int? cardIndex) {
    return DragTarget<TargetDataModel<TrelloCardModel>>(
      builder: (
        context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Container(
          height: trelloCardHeight,
          width: trelloCardWidth,
          color: Colors.grey[300],
        );
      },
      onAccept: (TargetDataModel<TrelloCardModel> model) {
        print("on accept called");
        if (cardIndex != null) {
          Provider.of<HomePageBloc>(context, listen: false)
              .removeData(model.fromList, model.data.id);
          Provider.of<HomePageBloc>(context, listen: false)
              .addData(widget.listIndex, cardIndex, model.data);
        }

        // widget.items[widget.listIndex]
        //     .removeWhere((d) => d.id == model.data.id);
        // widget.items[model.fromList].add(model.data);
        Provider.of<DragUpdatesBloc>(context, listen: false).clearData;
      },
    );
  }
}
