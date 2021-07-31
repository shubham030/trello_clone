import 'dart:ui';

class DragUpdateDetailsModel {
  final Offset? offset;
  final int? itemIndex;
  final int? listIndex;

  DragUpdateDetailsModel({
    required this.offset,
    required this.itemIndex,
    required this.listIndex,
  });
}
