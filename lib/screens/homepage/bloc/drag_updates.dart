import 'dart:ui';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:trello_clone/screens/homepage/models/drag_update_details_model.dart';

class DragUpdatesBloc {
  final _dragUpdate = BehaviorSubject<Offset?>.seeded(null);
  final _hoveredIndex = BehaviorSubject<int?>.seeded(null);
  final _hoveredList = BehaviorSubject<String?>();

  Function(Offset) get onDragUpdate => _dragUpdate.sink.add;
  Function(int) get onHoveredIndexUpdate => _hoveredIndex.sink.add;
  Function(String) get onHoveredListUpdate => _hoveredList.sink.add;

  Stream<Offset?> get dragUpdate => _dragUpdate.stream;
  Stream<int?> get hoveredIndex => _hoveredIndex.stream;
  Stream<String?> get hoveredList => _hoveredList.stream;

  Stream<DragUpdateDetailsModel> get dragUpdateDetails => CombineLatestStream
          .combine3<Offset?, int?, String?, DragUpdateDetailsModel>(
        dragUpdate,
        hoveredIndex,
        hoveredList,
        (a, b, c) => DragUpdateDetailsModel(
          offset: a,
          itemIndex: b,
          listId: c,
        ),
      );

  void get clearData {
    _dragUpdate.add(null);
    _hoveredIndex.add(null);
    _hoveredList.add(null);
  }

  void dispose() {
    _dragUpdate.close();
    _hoveredIndex.close();
    _hoveredList.close();
  }
}
