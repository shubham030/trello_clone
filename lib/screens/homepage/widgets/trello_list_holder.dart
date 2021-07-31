import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trello_clone/common/strings.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/models/trello_list_model.dart';
import 'package:trello_clone/screens/homepage/bloc/drag_updates.dart';
import 'package:trello_clone/screens/homepage/bloc/home_page_bloc.dart';
import 'package:trello_clone/screens/homepage/models/drag_update_details_model.dart';
import 'package:trello_clone/screens/homepage/models/target_data_model.dart';
import 'package:trello_clone/screens/homepage/views/home_page.dart';
import 'package:trello_clone/screens/homepage/widgets/card.dart';

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
  final _showAddCard = BehaviorSubject<bool>.seeded(false);
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _showAddCard.close();
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemHeight = (widget.model.items.length) * trelloCardHeight;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: trelloCardWidth,
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model.title,
            ),
          ),
          Builder(
            builder: (context) {
              if (itemHeight > screenHeight - 100) {
                return Expanded(
                  child: buildListView(widget.model.items, _scrollController),
                );
              } else {
                return SizedBox(
                  height: itemHeight,
                  child: buildListView(widget.model.items, _scrollController),
                );
              }
            },
          ),
          StreamBuilder<bool>(
            stream: _showAddCard.stream,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data ?? false) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Card(
                        child: TextField(
                          controller: _textEditingController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: Strings.enterTitleForThisCard,
                            hintStyle: TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.all(4.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_textEditingController.text.isNotEmpty) {
                                Provider.of<HomePageBloc>(
                                  context,
                                  listen: false,
                                ).addNewCard(
                                  widget.model.id,
                                  _textEditingController.text,
                                );
                              }
                              _textEditingController.clear();
                              _showAddCard.add(false);
                            },
                            child: Text(Strings.addCard),
                          ),
                          IconButton(
                            splashColor: Colors.transparent,
                            icon: Icon(Icons.close),
                            onPressed: () {
                              _showAddCard.add(false);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _showAddCard.add(true);
                      if (itemHeight > screenHeight - 50) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent + 60,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Text(Strings.addACard),
                        ],
                      ),
                    ),
                  ),
                );
              }
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
                child: TrelloCard(
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
              .addData(widget.model.id, cardIndex, model.data);
        }
        Provider.of<DragUpdatesBloc>(context, listen: false).clearData;
      },
    );
  }
}
