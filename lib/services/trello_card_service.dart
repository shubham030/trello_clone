import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trello_clone/common/config.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/models/trello_list_model.dart';

abstract class TrelloCardService {
  Stream<List<TrelloListModel>> getAllLists();
  Future<bool> createCard(TrelloCardModel model);
  // Future<bool> deletedCard(String listId, cardId);
  Future<bool> createList(TrelloListModel model);
  Future<bool> deleteList(List<TrelloListModel> models);
  Future<bool> reorderCard(TrelloCardModel model);

  factory TrelloCardService() {
    return TrelloCardServiceImpl();
  }
}

class TrelloCardServiceImpl implements TrelloCardService {
  DocumentReference<Map<String, dynamic>> boardRef =
      FirebaseFirestore.instance.collection('boards').doc(Config().boardId);

  CollectionReference<Map<String, dynamic>> cardsRef =
      FirebaseFirestore.instance.collection('cards');

  @override
  Future<bool> createCard(
    TrelloCardModel model,
  ) async {
    try {
      await cardsRef.doc(model.id).set(
            model.toMap(),
          );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> createList(TrelloListModel model) async {
    try {
      await boardRef.update(
        {
          "lists": FieldValue.arrayUnion([model.toMap()]),
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteList(List<TrelloListModel> models) async {
    try {
      await boardRef.update(
        {
          "lists": models.map((e) => e.toMap()),
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // @override
  // Future<bool> updateList(TrelloCardModel model) async {
  //   try {
  //     await boardRef.update(
  //       {
  //         '${model.id}': model.toMap(),
  //       },
  //     );
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  @override
  Stream<List<TrelloListModel>> getAllLists() async* {
    var cards = cardsRef
        .where("boardId", isEqualTo: Config().boardId)
        .orderBy("reOrderedAt")
        .snapshots();
    var board = boardRef.snapshots();

    yield* CombineLatestStream.combine2<
        QuerySnapshot<Map<String, dynamic>>,
        DocumentSnapshot<Map<String, dynamic>>,
        List>(cards, board, (a, b) => [a, b]).transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          var cards = data[0] as QuerySnapshot<Map<String, dynamic>>;
          var board = data[1] as DocumentSnapshot<Map<String, dynamic>>;

          Map<String, List<TrelloCardModel>> itemsData = {};
          List<TrelloListModel> models = [];

          print("started cards ");

          cards.docs.forEach((element) {
            TrelloCardModel card = TrelloCardModel.fromMap(element.data());
            if (itemsData.containsKey(card.listId)) {
              itemsData[card.listId]?.add(card);
            } else {
              itemsData[card.listId] = [card];
            }
          });

          print("cards complete");

          if (board.data()!.containsKey("lists")) {
            board.data()!["lists"].forEach((item) {
              TrelloListModel list = TrelloListModel.fromMap(item);
              if (itemsData.containsKey(list.id)) {
                list = list.copyWith(items: itemsData[list.id]);
              } else {
                list = list.copyWith(items: []);
              }
              models.add(list);
            });
          }

          print("bodard complete");
          sink.add(models);
        },
      ),
    );
  }

  @override
  Future<bool> reorderCard(TrelloCardModel model) async {
    try {
      await cardsRef.doc(model.id).update(
        {
          "listId": model.listId,
          "reOrderedAt": DateTime.now().millisecondsSinceEpoch,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
