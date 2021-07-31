import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:trello_clone/common/config.dart';
import 'package:trello_clone/common/exceptions.dart';
import 'package:trello_clone/models/trello_card_model.dart';
import 'package:trello_clone/models/trello_list_model.dart';

abstract class TrelloCardService {
  Future<Either<Failure, bool>> createCard(
      String listId, TrelloCardModel model);
  // Future<Either<Failure, bool>> deletedCard(String listId, cardId);
  Future<Either<Failure, bool>> createList(TrelloListModel model);
  Future<Either<Failure, bool>> deleteList(String listId);
  Future<Either<Failure, bool>> updateList(TrelloCardModel model);
}

class TrelloCardServiceImpl extends TrelloCardService {
  DocumentReference<Map<String, dynamic>> boardRef =
      FirebaseFirestore.instance.collection('boards').doc(Config().boardId);

  @override
  Future<Either<Failure, bool>> createCard(
    String listId,
    TrelloCardModel model,
  ) async {
    try {
      await boardRef.update(
        {
          '$listId.items': FieldValue.arrayUnion([model.toMap()])
        },
      );
      return right(true);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createList(TrelloListModel model) async {
    try {
      await boardRef.update(
        {
          '${model.id}': {model.toMap()}
        },
      );
      return right(true);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteList(String listId) async {
    try {
      await boardRef.update(
        {'$listId': FieldValue.delete()},
      );
      return right(true);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateList(TrelloCardModel model) async {
    try {
      await boardRef.update(
        {
          '${model.id}': model.toMap(),
        },
      );
      return right(true);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
