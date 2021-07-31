import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/common/strings.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/models/trello_list_model.dart';
import 'package:trello_clone/screens/homepage/bloc/drag_updates.dart';
import 'package:trello_clone/screens/homepage/bloc/home_page_bloc.dart';
import 'package:trello_clone/screens/homepage/models/drag_update_details_model.dart';
import 'package:trello_clone/screens/homepage/models/target_data_model.dart';
import 'package:trello_clone/screens/homepage/views/home_page.dart';
import 'package:trello_clone/screens/homepage/widgets/card_title_input_widget.dart';
import 'package:trello_clone/screens/homepage/widgets/list_pop_up_menu.dart';
import 'package:trello_clone/screens/homepage/widgets/trello_card_holder.dart';

class TrelloListHolder extends StatefulWidget {
  final TrelloListModel model;

  const TrelloListHolder({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _TrelloListHolderState createState() => _TrelloListHolderState();
}

class _TrelloListHolderState extends State<TrelloListHolder> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemHeight = (widget.model.items!.length) * trelloCardHeight;
    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight - 100),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: trelloCardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  widget.model.title,
                ),
                Spacer(),
                ListPopUpMenu(
                  onSelected: handlePopMenuSelection,
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              if (itemHeight > screenHeight - 200) {
                return Expanded(
                  child: buildListView(
                      widget.model.items ?? [], _scrollController),
                );
              } else {
                return SizedBox(
                  height: itemHeight,
                  child: buildListView(
                      widget.model.items ?? [], _scrollController),
                );
              }
            },
          ),
          CardTitleInput(
            maxLines: 3,
            buttonText1: Strings.addACard,
            buttonText2: Strings.addCard,
            hint: Strings.enterTitleForThisCard,
            onStart: () {
              if (itemHeight > screenHeight - 50) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent + 60,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
            onDataSubmit: (value) {
              Provider.of<HomePageBloc>(
                context,
                listen: false,
              ).addNewCard(
                widget.model.id,
                value,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildListView(
      List<TrelloCardModel> items, ScrollController controller) {
    return StreamBuilder<DragUpdateDetailsModel>(
        initialData: DragUpdateDetailsModel(
          itemIndex: null,
          listId: null,
          offset: null,
        ),
        stream: Provider.of<DragUpdatesBloc>(context).dragUpdateDetails,
        builder: (context, snapshot) {
          if (items.isEmpty) {
            return _buildDragTarget(0);
          }
          return ListView.builder(
            controller: controller,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final dragUpdateBloc = Provider.of<DragUpdatesBloc>(
                context,
                listen: false,
              );
              var child = Container(
                height: trelloCardHeight,
                child: TrelloCardHolder(
                  model: items[index],
                  parentListId: widget.model.id,
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
                        dragUpdateBloc.onHoveredListUpdate(widget.model.id);
                      }
                    }
                  },
                ),
              );

              if (index == snapshot.data?.itemIndex &&
                  snapshot.data?.listId == widget.model.id) {
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

  void handlePopMenuSelection(ListMenuItem item) {
    switch (item) {
      case ListMenuItem.Delete:
        Provider.of<HomePageBloc>(
          context,
          listen: false,
        ).deleteList(widget.model);
        break;
    }
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
          Provider.of<HomePageBloc>(context, listen: false).moveCard(
            widget.model.id,
            model.data,
          );
        }
        Provider.of<DragUpdatesBloc>(context, listen: false).clearData;
      },
    );
  }
}
