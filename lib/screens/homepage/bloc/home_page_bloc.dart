import 'package:rxdart/rxdart.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/models/trello_list_model.dart';
import 'package:uuid/uuid.dart';

class HomePageBloc {
  final _trelloLists = BehaviorSubject<List<TrelloListModel>>();

  Stream<List<TrelloListModel>> get trelloLists => _trelloLists.stream;

  Future<void> init() async {
    await Future.delayed(Duration(seconds: 2));
    List<TrelloListModel> data = [];
    ["1", "2", "3"].forEach(
      (id) {
        data.add(
          TrelloListModel(
            title: "Item list $id",
            id: Uuid().v1(),
            items: List.generate(
              10,
              (index) => TrelloCardModel(
                id: Uuid().v1(),
                title: "random data $index",
              ),
            ),
          ),
        );
      },
    );

    _trelloLists.add(data);
  }

  void addNewCard(String listId, String text) {
    var value = _trelloLists.value;
    value.firstWhere((element) => element.id == listId).items.add(
          TrelloCardModel(id: Uuid().v1(), title: text),
        );

    _trelloLists.add(value);
  }

  void removeData(String listId, String itemId) {
    print("$listId $itemId");
    var value = List<TrelloListModel>.from(_trelloLists.value);

    value.firstWhere((element) => element.id == listId).items.removeWhere(
          (d) => d.id == itemId,
        );

    _trelloLists.add(value);
  }

  void addData(String listId, int index, TrelloCardModel model) {
    var value = _trelloLists.value;
    value
        .firstWhere((element) => element.id == listId)
        .items
        .insert(index, model);

    _trelloLists.add(value);
  }

  void dispose() {
    _trelloLists.close();
  }
}
