import 'package:rxdart/rxdart.dart';
import 'package:trello_clone/common/config.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/models/trello_list_model.dart';
import 'package:trello_clone/services/trello_card_service.dart';
import 'package:uuid/uuid.dart';

class HomePageBloc {
  final _trelloLists = BehaviorSubject<List<TrelloListModel>>();
  final TrelloCardService trelloCardService = TrelloCardService();

  Stream<List<TrelloListModel>> get trelloLists => _trelloLists.stream;

  Future<void> init() async {
    trelloCardService.getAllLists().listen((event) {
      _trelloLists.add(event);
    });
    // await Future.delayed(Duration(seconds: 2));
    // List<TrelloListModel> data = [];
    // ["1", "4"].forEach(
    //   (id) {
    //     data.add(
    //       TrelloListModel(
    //         title: "Item list $id",
    //         id: Uuid().v1(),
    //         items: List.generate(
    //           20,
    //           (index) => TrelloCardModel(
    //             id: Uuid().v1(),
    //             title: "random data $index",
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  void addNewList(String title) {
    trelloCardService.createList(
      TrelloListModel(
        id: Uuid().v1(),
        title: title,
        items: [],
      ),
    );
    // var value = _trelloLists.value;
    // value.add(
    //   TrelloListModel(
    //     id: Uuid().v1(),
    //     title: title,
    //     items: [],
    //   ),
    // );
    // _trelloLists.add(value);
  }

  void addNewCard(String listId, String text) {
    trelloCardService.createCard(
      TrelloCardModel(
        boardId: Config().boardId,
        listId: listId,
        id: Uuid().v1(),
        title: text,
        createdAt: DateTime.now(),
        reOrderedAt: DateTime.now(),
      ),
    );
    // var value = _trelloLists.value;
    // value.firstWhere((element) => element.id == listId).items!.add(
    //       TrelloCardModel(id: Uuid().v1(), title: text),
    //     );

    // _trelloLists.add(value);
  }

  void moveCard(String toListId, TrelloCardModel model) {
    trelloCardService.reorderCard(
      model.copyWith(listId: toListId),
    );
  }

  // void removeData(String listId, String itemId) {
  //   // print("$listId $itemId");
  //   // var value = List<TrelloListModel>.from(_trelloLists.value);

  //   // value.firstWhere((element) => element.id == listId).items!.removeWhere(
  //   //       (d) => d.id == itemId,
  //   //     );

  //   // _trelloLists.add(value);
  // }

  // void addData(String listId, int index, TrelloCardModel model) {
  //   var value = _trelloLists.value;
  //   value
  //       .firstWhere((element) => element.id == listId)
  //       .items!
  //       .insert(index, model);

  //   _trelloLists.add(value);
  // }

//udpating list //need to figure out way to delete by id
  void deleteList(TrelloListModel model) {
    var updatedList = List<TrelloListModel>.from(_trelloLists.value);
    updatedList.removeWhere((element) => element.id == model.id);
    trelloCardService.deleteList(updatedList);
    // var value = List<TrelloListModel>.from(_trelloLists.value);
    // value.removeWhere((element) => element.id == id);

    // _trelloLists.add(value);
  }

  void dispose() {
    _trelloLists.close();
  }
}
