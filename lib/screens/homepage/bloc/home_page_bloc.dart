import 'package:rxdart/rxdart.dart';
import 'package:trello_clone/common/strings.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/models/trello_list_model.dart';
import 'package:uuid/uuid.dart';

class HomePageBloc {
  final _trelloLists = BehaviorSubject<List<TrelloListModel>>();

  Stream<List<TrelloListModel>> get trelloLists => _trelloLists.stream;

  Future<void> init() async {
    await Future.delayed(Duration(seconds: 2));
    List<TrelloListModel> data = [];

    sampleData.map(
      (animalList) {
        var listId = Uuid().v1();
        data.add(
          TrelloListModel(
            title: "Animals ${animalList.length}",
            id: listId,
            items: animalList
                .map(
                  (title) => TrelloCardModel(
                    id: Uuid().v1(),
                    listId: listId,
                    title: title,
                    date: DateTime.now(),
                  ),
                )
                .toList(),
          ),
        );
      },
    ).toList();

    _trelloLists.add(data);
  }

  void updateCardModel(TrelloCardModel model) {
    var value = _trelloLists.value;
    late int index;
    for (int i = 0; i < value.length; i++) {
      if (value[i].id == model.listId) {
        index = i;
        break;
      }
    }

    var trelloList = value[index];
    //restrucuture data to avoid updating model by copying all
    //avoid storing card models in list model
    List<TrelloCardModel> models = [];
    trelloList.items.forEach((element) {
      if (model.id == element.id) {
        models.add(element.copyWith(description: model.description));
      } else {
        models.add(element);
      }
    });

    value[index] = trelloList.copyWith(items: models);

    _trelloLists.add(value);
  }

  void addNewList(String title) {
    var value = _trelloLists.value;
    value.add(
      TrelloListModel(
        id: Uuid().v1(),
        title: title,
        items: [],
      ),
    );
    _trelloLists.add(value);
  }

  void addNewCard(String listId, String text) {
    var value = _trelloLists.value;
    value.firstWhere((element) => element.id == listId).items.add(
          TrelloCardModel(
            id: Uuid().v1(),
            listId: listId,
            title: text,
            date: DateTime.now(),
          ),
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

  void deletedList(String id) {
    var value = List<TrelloListModel>.from(_trelloLists.value);
    value.removeWhere((element) => element.id == id);

    _trelloLists.add(value);
  }

  void dispose() {
    _trelloLists.close();
  }
}
