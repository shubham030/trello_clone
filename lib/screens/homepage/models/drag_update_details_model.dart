import 'dart:ui';

class DragUpdateDetailsModel {
  final Offset? offset;
  final int? itemIndex;
  final String? listId;

  DragUpdateDetailsModel({
    required this.offset,
    required this.itemIndex,
    required this.listId,
  });
}
