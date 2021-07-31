import 'package:rxdart/rxdart.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/models/trello_list_model.dart';

class HomePageBloc {
  final _trelloLists = BehaviorSubject<List<TrelloListModel>>();

  Stream<List<TrelloListModel>> get trelloLists => _trelloLists.stream;

  Future<void> init() async {
    await Future.delayed(Duration(seconds: 2));
    var data = List.generate(
      3,
      (index) => TrelloListModel(
        title: "Item list $index",
        id: index.toString(),
        items: List.generate(
          (index + 1) * 10,
          (itemIndex) => TrelloCardModel(
              id: itemIndex.toString(), title: "Data $index$itemIndex"),
        ),
      ),
    );
    _trelloLists.add(data);
  }

  void removeData(int listId, String itemId) {
    var value = List<TrelloListModel>.from(_trelloLists.value);
    value[listId].items.removeWhere(
          (item) => item.id == itemId,
        );
    _trelloLists.add(value);
  }

  void addData(int listId, int index, TrelloCardModel model) {
    var value = List<TrelloListModel>.from(_trelloLists.value);
    value[listId].items.insert(index, model);
    _trelloLists.add(value);
  }

  void dispose() {
    _trelloLists.close();
  }
}
